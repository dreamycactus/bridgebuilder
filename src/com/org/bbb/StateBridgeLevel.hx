package com.org.bbb;

import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.GameConfig.BuildMat;
import com.org.bbb.GameConfig.JointType;
import com.org.bbb.Template.TemplateParams;
import com.org.mes.Cmp;
import com.org.mes.Entity;
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

/**
 * ...
 * @author 
 */
class StateBridgeLevel extends BBBState
{
    var joint : Constraint;
    var entfactory : EntFactory;
    var grid : Entity;
    public var cmpGrid : CmpGrid;
    public var cmpControl : CmpControlBuild;
    var uiSprite : Sprite;
    var textField : TextField;
    var inited = false;
    @:isVar public var level(default, set_level) : CmpLevel;
    
    var prev : Body = null;
    var stage : Stage;

    public static function createLevelState(top : Top, levelPath : String) : BBBState
    {
        var s1 = new StateBridgeLevel(top);
        var allsys = [new SysPhysics(s1, null), new SysRender(s1, null, Lib.current.stage), new SysControl(s1, Lib.current.stage)];
        for (s in allsys) {
            s1.insertSystem(s);
        }
        EntFactory.inst.state = s1;
        
        var level = s1.createEnt();
        var cl = CmpLevel.loadLevelXml(s1, levelPath);
        level.attachCmp(cl);
        s1.getSystem(SysRender).camera.dragBounds = { x : 0, y : 0, width : cl.width, height : cl.height };
        s1.getSystem(SysRender).camera.zoom = -1;
        s1.insertEnt(level);
        
        var grid = EntFactory.inst.createGridEnt(cl.width, cl.height, GameConfig.gridCellWidth, [4]);
        var cmpGrid = grid.getCmp(CmpGrid);
        s1.insertEnt(grid);
        s1.cmpGrid = cmpGrid;
        
        s1.renderSys = s1.getSystem(SysRender);
        s1.getSystem(SysPhysics).level = cl;
        s1.getSystem(SysRender).level = cl;
        
        var controllerEnt = s1.createEnt();
        var cmpControl = new CmpControlBuild(Lib.current.stage, cmpGrid, cl);
        s1.cmpControl = cmpControl;
        controllerEnt.attachCmp(cmpControl);
        controllerEnt.attachCmp(new CmpRenderControlBuild(Lib.current.stage, cmpControl) );
        controllerEnt.attachCmp( new CmpRenderControlUI(cmpControl, GameConfig.stageWidth, GameConfig.stageHeight) );

        s1.insertEnt(controllerEnt);
        
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
        //this.stage.addChild(textField);
        
    }
        
    override public function get_mainSprite()
    {
        return getSystem(SysRender).mainSprite;
    }
    
    override public function disableControl() : Void
    {
        getSystem(SysControl).active = false;
    }
    
    override public function enableControl() : Void
    {
        getSystem(SysControl).active = true;
    }
    
    override function init() 
    {
        //var rootWidget = UIBuilder.get('root');
        //rootWidget.w = stage.stageWidth;
        //rootWidget.h = stage.stageWidth;
    }
    
    override function update() 
    {
        super.update();
        var space = getSystem(SysPhysics).level.space;

        var mp = Vec2.get(stage.mouseX, stage.mouseY);
        var bb : BodyList = space.bodiesUnderPoint(getSystem(SysRender).camera.screenToWorld(mp), null, null);
        
        //if (bb != null && bb.length > 0) {
            //textField.text = printBodyForces(bb.at(0) );
        //} else {
            //textField.text = "";
        //}
        
        var cp = cmpGrid.getClosestCell(mp);
        textField.text += "\n" + cp +"\n" + mp +"\n";
        
        
    }
    
    function set_level(cl : CmpLevel) : CmpLevel
    {
        level = cl;
        getSystem(SysPhysics).level = cl;
        getSystem(SysRender).level = cl;
        cmpControl.level = cl;
        return cl;
    }

}