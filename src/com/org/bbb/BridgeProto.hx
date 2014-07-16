package com.org.bbb;

import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.Config.BuildMat;
import com.org.bbb.Config.JointType;
import com.org.bbb.Template.TemplateParams;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.Top;
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
class BridgeProto extends Sprite
{
    var joint : Constraint;
    var top : Top;
    var entfactory : EntFactory;
    var grid : Entity;
    var cmpGrid : CmpGrid;
    var cmpControl : CmpControlBuild;
    var uiSprite : Sprite;
    var textField : TextField;
    var prevTime : Float = 0;
    var inited = false;
    public function new() 
    {
        super();
        top = new Top();
        entfactory = new EntFactory(top);
        grid = entfactory.createGridEnt(40, [4]);
        cmpGrid = grid.getCmp(CmpGrid);
        uiSprite = new Sprite();
        
        textField = new TextField();
        textField.defaultTextFormat = new TextFormat("Arial", null, 0xffffff);
        textField.selectable = false;
        textField.width = 1280;
        textField.height = 800;
        addChild(textField);
        
        addEventListener(Event.ENTER_FRAME, enterFrame);
        addEventListener(Event.ADDED_TO_STAGE, init);
        
    }
        var prev : Body = null;
    
        var found : PivotJoint;
        var found1 : PivotJoint;
        
    function init(_) 
    {
        if (inited) return;
        
        var s1 = new MESState(top);
        s1.sys = [new SysPhysics(top, null), new SysRender(top, null, Lib.current.stage), new SysControl(top, Lib.current.stage)];
        
        inited = true;
        top.changeState(s1);
        
        Cmp.cmpManager.makeParentChild(CmpRender, [CmpRenderGrid, CmpRenderBuildControl]);
        Cmp.cmpManager.registerCmp(CmpPhys);
        Cmp.cmpManager.makeParentChild(CmpPhys, [CmpBeam, CmpJoint, CmpMultiBeam,
                                                CmpSharedJoint, CmpCable, CmpMover, CmpMoverCar]);
        Cmp.cmpManager.registerCmp(CmpControl);
        Cmp.cmpManager.makeParentChild(CmpControl, [CmpControlBuild, CmpControlCar]);
        
        trace(Cmp.cmpManager.printAll() );
        top.insertEnt(grid);
        
        var level = top.createEnt();
        var cl = CmpLevel.genFromXml("levels/b01.xml");
        level.attachCmp(cl);
        top.insertEnt(level);
        
        top.getSystem(SysPhysics).space = cl.space;
        
        var controllerEnt = top.createEnt();
        cmpControl = new CmpControlBuild(Lib.current.stage, cl.space, cmpGrid);
        controllerEnt.attachCmp(cmpControl);
        controllerEnt.attachCmp(new CmpRenderBuildControl(Lib.current.stage, cmpControl) );
        top.insertEnt(controllerEnt);

        var rootWidget = UIBuilder.get('root');
        rootWidget.w = stage.stageWidth;
        rootWidget.h = stage.stageWidth;
    }
    
    function enterFrame(_) {
        var curTime = Lib.getTimer();
        var deltaTime:Float = (curTime - prevTime);
        prevTime = curTime;
        
        top.update(deltaTime);
        var space = top.getSystem(SysPhysics).space;

        var mp = Vec2.get(mouseX, mouseY);
        var bb : BodyList = space.bodiesUnderPoint(mp, null, null);
        
        if (bb != null && bb.length > 0) {
            textField.text = printBodyForces(bb.at(0) );
        } else {
            textField.text = "";
        }
        
        var cp = cmpGrid.getClosestCell(mp);
        textField.text += "\n" + cp +"\n" + mp +"\n";
        textField.text += cmpControl.isDeck + "\n";
    }
    
    function printBodyForces(body : Body)
    {
        var str =        "body id: " + body.id + "\n"
                       + "total contacts: " + body.totalContactsImpulse().Vec3ToIntString() + ",\n" 
                       + "total impulse: " + body.totalImpulse().Vec3ToIntString() + "\n" 
                       + "total constraint: " + body.constraintsImpulse().Vec3ToIntString() + "\n"
                       + "total stress: " + body.calculateBeamStress().xy(true) + "\n";
                       
        for (c in body.constraints) {
            str += "constraint impulse: " + c.bodyImpulse(body).Vec3ToIntString() +"\n";
        }
        return str;
    }

}