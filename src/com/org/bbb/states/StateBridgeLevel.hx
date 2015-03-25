package com.org.bbb.states ;

import com.org.bbb.control.CmpBridgeBuild;
import com.org.bbb.control.CmpControlBuild;
import com.org.bbb.editor.CmpAnchorInstance;
import com.org.bbb.editor.CmpControlEditor;
import com.org.bbb.level.CmpSpawn.SpawnType;
import com.org.bbb.level.LevelParser;
import com.org.bbb.level.LevelSerializer;
import com.org.bbb.level.CmpGrid;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.level.CmpObjectiveAllPass;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpMoverCar;
import com.org.bbb.physics.CmpMultiBeam.SplitType;
import com.org.bbb.GameConfig.JointType;
import com.org.bbb.physics.CmpTransform;
import com.org.bbb.render.Camera;
import com.org.bbb.render.CmpRenderControlBuild;
import com.org.bbb.render.CmpRenderControlUI;
import com.org.bbb.render.CmpRenderEditorUI;
import com.org.bbb.systems.SysControl;
import com.org.bbb.systems.SysLevelDirector;
import com.org.bbb.systems.SysObjective;
import com.org.bbb.systems.SysPhysics;
import com.org.bbb.systems.SysRender;
import com.org.bbb.systems.SysRuntimeOverlord;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.EntityType;
import com.org.mes.MESState;
import com.org.mes.Top;
import flash.display.Stage;
import haxe.macro.Context;
import haxe.Resource;
import nape.dynamics.InteractionFilter;
import nape.geom.AABB;
import nape.space.Space;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Text;
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
    public var controllerEnt : Entity;
    public var editor : CmpControlEditor;
    
    var uiSprite : Sprite;
    var textField : TextField;
    var inited = false;
    @:isVar public var level(default, set_level) : CmpLevel;
    
    public var builder : CmpBridgeBuild;
    var camera : Camera;
    var playerCar : CmpMoverCar;
    
    var prev : Body = null;
    var stage : Stage;

    public static function createLevelState(top : Top, levelPath : String) : BBBState
    {
        var state = new StateBridgeLevel(top);
        EntFactory.inst.state = state;
        state.init();
        var space = new Space();
        var levelserializer = new LevelParser(state);
        var cl = levelserializer.loadLevelXml(levelPath);
        state.level = cl;

        return state;
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
        entityTypeManager.registerType(new EntityType(GameConfig.tTransform, [CmpTransform], [], []));
        //this.stage.addChild(textField);
        
                var allsys = [new SysPhysics(this, null), new SysRender(this, null, Lib.current.stage)
                    , new SysControl(this, Lib.current.stage), new SysRuntimeOverlord(this), new SysObjective(this)
                    , new SysLevelDirector(this, null)];
        for (s in allsys) {
            insertSystem(s);
        }
        EntFactory.inst.state = this;
        
        getSystem(SysRender).camera.zoom = -1;
        var grid = EntFactory.inst.createGridEnt(920, 480, GameConfig.gridCellWidth, [7]);
        var cmpGrid = grid.getCmp(CmpGrid);
        insertEnt(grid);
       
        renderSys = getSystem(SysRender);
        camera = getSystem(SysRender).camera;
        
        controllerEnt = createEnt();
        builder = new CmpBridgeBuild(top, this, getSystem(SysPhysics).space, camera, cmpGrid);
        //var cmpControl = new CmpControlBuild(cmpBuilder);
        builder.cmpGrid = cmpGrid;

        editor = new CmpControlEditor(builder);
        controllerEnt.attachCmp(editor);
        controllerEnt.attachCmp(new CmpRenderControlBuild(Lib.current.stage, builder) );
        controllerEnt.attachCmp(new CmpRenderEditorUI(editor, 1024, 576) );
        //controllerEnt.attachCmp(new CmpRenderControlUI(cmpControl, cl, GameConfig.stageWidth, GameConfig.stageHeight) );
        insertEnt(controllerEnt);
        
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
        getSystem(SysPhysics).level = cl;
        getSystem(SysRender).level = cl;
        getSystem(SysRender).camera.dragBounds = { x : 0, y : 0, width : cl.width, height : cl.height };
        getSystem(SysLevelDirector).level = cl;
        getSystem(SysRuntimeOverlord).level = cl;
        editor.level = cl;
        
        builder.space = cl.space;
        //builder.cmpGrid = cmpGrid;

        for (e in cl.ents) {
            insertEnt(e);
        }
        return level = cl;
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