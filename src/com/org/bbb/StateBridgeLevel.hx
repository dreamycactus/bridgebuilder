package com.org.bbb;

import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.GameConfig.JointType;
import com.org.bbb.Template.TemplateParams;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.EntityType;
import com.org.mes.MESState;
import com.org.mes.Top;
import flash.display.Stage;
import haxe.macro.Context;
import haxe.Resource;
import nape.dynamics.InteractionFilter;
import openfl.Assets;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import ru.stablex.ui.UIBuilder;
//import com.org.mes.Entity;
//import com.org.mes.Top;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.ui.Keyboard;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.shape.Circle;
import nape.shape.Polygon;

using com.org.bbb.Util;

class StateBridgeLevel extends BBBState
{
    var joint : Constraint;
    var entfactory : EntFactory;
    var grid : Entity;
    public var cmpGrid : CmpGrid;
    public var cmpControl : CmpControlBuild;
    public var controllerEnt : Entity;
    var uiSprite : Sprite;
    var textField : TextField;
    var inited = false;
    @:isVar public var level(default, set_level) : CmpLevel;
    
    var camera : Camera;
    var playerCar : CmpMoverCar;
    
    var prev : Body = null;
    var stage : Stage;

    public static function createLevelState(top : Top, levelPath : String) : BBBState
    {
        var state = new StateBridgeLevel(top);
        EntFactory.inst.state = state;
        var cl = CmpLevel.loadLevelXml(state, levelPath);
        return createFromLevel(state, top, cl);
    }
    
    public static function createFromLevel(s1 : StateBridgeLevel, top : Top, cl : CmpLevel) : BBBState
    {
        if (s1 == null) { s1 = new StateBridgeLevel(top); }
        var allsys = [new SysPhysics(s1, null), new SysRender(s1, null, Lib.current.stage)
                    , new SysControl(s1, Lib.current.stage), new SysRuntimeOverlord(s1), new SysObjective(s1)
                    , new SysLevelDirector(s1, null)];
        for (s in allsys) {
            s1.insertSystem(s);
        }
        EntFactory.inst.state = s1;
        
        var level = s1.createEnt();
        level.attachCmp(cl);
        s1.getSystem(SysRender).camera.dragBounds = { x : 0, y : 0, width : cl.width, height : cl.height };
        s1.getSystem(SysRender).camera.zoom = -1;
        s1.insertEnt(level);
        
        var grid = EntFactory.inst.createGridEnt(cl.width, cl.height, GameConfig.gridCellWidth, [7]);
        var cmpGrid = grid.getCmp(CmpGrid);
        s1.insertEnt(grid);
        s1.cmpGrid = cmpGrid;
       
        s1.renderSys = s1.getSystem(SysRender);
        s1.getSystem(SysPhysics).level = cl;
        s1.getSystem(SysRender).level = cl;
        s1.getSystem(SysLevelDirector).level = cl;
        s1.getSystem(SysRuntimeOverlord).level = cl;
        
        s1.camera = s1.getSystem(SysRender).camera;
        
        var controllerEnt = s1.createEnt();
        var cmpControl = new CmpControlBuild(Lib.current.stage, cmpGrid, cl);
        s1.cmpControl = cmpControl;
        controllerEnt.attachCmp(cmpControl);
        controllerEnt.attachCmp(new CmpRenderControlBuild(Lib.current.stage, cmpControl) );
        controllerEnt.attachCmp(new CmpRenderControlUI(cmpControl, cl, GameConfig.stageWidth, GameConfig.stageHeight) );
        s1.controllerEnt = controllerEnt;
        s1.insertEnt(controllerEnt);
        
        for (e in cl.ents) {
            s1.insertEnt(e);
        }
        
        //var cob = s1.createEnt();
        //var cmpCob = new CmpObjectiveBudget(cl, 0, 0, 0);
        //cob.attachCmp(cmpCob);
        //s1.insertEnt(cob);
        
        var eobj = s1.createEnt();
        eobj.attachCmp(new CmpObjectiveAllPass(cl));
        s1.insertEnt(eobj);
        
        
        //var starbg = s1.createEnt();
        //starbg.attachCmp(new CmpRenderBgStarfield(400, cl.width, cl.height/2));
        //s1.insertEnt(starbg);
        //
        //var rainbg = s1.createEnt();
        //rainbg.attachCmp(new CmpRenderRain(Std.int(cl.width), Std.int(cl.height), false));
        //s1.insertEnt(rainbg);
        
        //var tt = s1.createEnt();
        //tt.attachCmp(new CmpRenderPony());
        //s1.insertEnt(tt);
        
        return s1;
    }
    
    public function new(top : Top) 
    {
        super(top);
        textField = new TextField();
        textField.defaultTextFormat = new TextFormat("Arial", null, 0xffffff);
        textField.selectable = false;
        textField.width = 1280;
        textField.height = 800;
        textField.mouseEnabled = false;
        
        this.stage = Lib.current.stage;
        var etCar = new EntityType(GameConfig.tCar, [CmpMoverCar], [], []);
        entityTypeManager.registerType(etCar);
        //this.stage.addChild(textField);
        
    }
        
    override public function get_mainSprite()
    {
        return getSystem(SysRender).mainSprite;
    }
    
    override public function disableControl() : Void
    {
        getSystem(SysControl).active = false;
        //controllerEnt.delete();
    }
    
    override public function enableControl() : Void
    {
        getSystem(SysControl).active = true;
    }
    
    override function init() 
    {
    }
    
    override function update() 
    {
        super.update();
        
        if (playerCar != null) {
            camera.pos = playerCar.body.position.mul(-1).add(Vec2.weak(512, 288));
        }
        
    }
    
    function set_level(cl : CmpLevel) : CmpLevel
    {
        level = cl;
        getSystem(SysPhysics).level = cl;
        getSystem(SysRender).level = cl;
        cmpControl.level = cl;
        return cl;
    }
    
    override public function distributeMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        switch(msgType) {
        case Msgs.NEWPLAYER:
            playerCar = options.cmpMover;
        }
        super.distributeMsg(msgType, sender, options);
    }


}