package com.org.bbb;

import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.Config.BuildMat;
import com.org.bbb.Config.JointType;
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
        
        if (bb != null && bb.length > 0) {
            textField.text = printBodyForces(bb.at(0) );
        } else {
            textField.text = "";
        }
        
        var cp = cmpGrid.getClosestCell(mp);
        textField.text += "\n" + cp +"\n" + mp +"\n";
    }
    
    function printBodyForces(body : Body)
    {
        var str =        "body id: " + body.id + "\n"
                       + "rotation: " + body.rotation
                       + "total contacts: " + body.totalContactsImpulse().Vec3ToIntString() + ",\n" 
                       + "total impulse: " + body.totalImpulse().Vec3ToIntString() + "\n" 
                       + "total constraint: " + body.constraintsImpulse().Vec3ToIntString() + "\n"
                       + "total stress: " + body.calculateBeamStress().xy(true) + "\n";
                       
        for (c in body.constraints) {
            str += "constraint impulse: " + c.bodyImpulse(body).Vec3ToIntString() +"\n";
        }
        return str;
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