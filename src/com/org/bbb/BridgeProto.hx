package com.org.bbb;

import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.Config.BuildMat;
import com.org.bbb.Config.CableMat;
import com.org.bbb.Config.JointType;
import com.org.bbb.Template.TemplateParams;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.Top;
import nape.dynamics.InteractionFilter;
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
class BridgeProto extends Template
{
    var joint : Constraint;
    var top : Top;
    var entfactory : EntFactory;
    var grid : Entity;
    var cmpGrid : CmpGrid;
    var uiSprite : Sprite;
    
    public function new() 
    {
        super( {
            generator: generateObject,
            gravity: Vec2.get(0, 600),
            noReset: true
        });
        top = new Top();
        entfactory = new EntFactory(top);
        grid = entfactory.createGridEnt(40, [4]);
        cmpGrid = grid.getCmp(CmpGrid);
        uiSprite = new Sprite();
    }
        var prev : Body = null;
    
        var found : PivotJoint;
        var found1 : PivotJoint;
        
    override function init() 
    {
        super.init();
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseDown);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, handMouseUp);
        top.insertSystem(new SysPhysics(top, this.space) );
        top.insertSystem(new SysRender(top, this.space, Lib.current.stage) );
        top.insertSystem(new SysControl(top) );
        top.init();
        
        Cmp.cmpManager.makeParentChild(CmpRender, [CmpRenderGrid, CmpRenderBuildControl]);
        Cmp.cmpManager.registerCmp(CmpPhys);
        Cmp.cmpManager.makeParentChild(CmpPhys, [CmpBeam, CmpJoint, CmpMultiBeam, CmpSharedJoint, CmpCable]);
        Cmp.cmpManager.registerCmp(CmpControl);
        Cmp.cmpManager.makeParentChild(CmpControl, [CmpBuildControl]);
        
        trace(Cmp.cmpManager.printAll() );
        top.insertEnt(grid);
        
        var w = Lib.current.stage.stageWidth;
        var h = Lib.current.stage.stageHeight;   
        
        var floor = new Body(BodyType.STATIC);
        floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
        floor.space = space;
        
        var floor1 = new Body(BodyType.STATIC);
        floor1.shapes.add(new Polygon(Polygon.box(100, 500)));
        floor1.position.setxy(150, 350);
        floor1.shapes.at(0).filter.collisionGroup = Config.cgAnchor;
        floor1.shapes.at(0).filter.collisionMask = ~(Config.cgBeam|Config.cgBeamSplit|Config.cgDeck);
        floor1.space = space;
        
        var floor2 = new Body(BodyType.STATIC);
        floor2.shapes.add(  new Polygon( Polygon.box(100, 500) )  );
        floor2.position.setxy(1000, 350);
        floor2.shapes.at(0).filter.collisionGroup = Config.cgAnchor;
        floor2.shapes.at(0).filter.collisionMask = ~(Config.cgBeam|Config.cgBeamSplit|Config.cgDeck);
        floor2.space = space;
        
        var controllerEnt = top.createEnt();
        var cc = new CmpBuildControl(Lib.current.stage, space, cmpGrid);
        controllerEnt.attachCmp(cc);
        controllerEnt.attachCmp(new CmpRenderBuildControl(Lib.current.stage, cc) );
        top.insertEnt(controllerEnt);
    }
    
    override function enterFrame(_) {
        var curTime = Lib.getTimer();
        var deltaTime:Float = (curTime - prevTime);
        prevTime = curTime;
        
        super.enterFrame(_);
        top.update(deltaTime);
        hand.anchor1.setxy(mouseX, mouseY);
        var bodies = space.bodies;
        
        var mp = Vec2.get(mouseX, mouseY);
        var bb : BodyList = space.bodiesUnderPoint(mp, null, null);
        
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
                       + "total contacts: " + body.totalContactsImpulse().Vec3ToIntString() + ",\n" 
                       + "total impulse: " + body.totalImpulse().Vec3ToIntString() + "\n" 
                       + "total constraint: " + body.constraintsImpulse().Vec3ToIntString() + "\n"
                       + "total stress: " + body.calculateBeamStress().xy(true) + "\n";
                       
        for (c in body.constraints) {
            str += "constraint impulse: " + c.bodyImpulse(body).Vec3ToIntString() +"\n";
        }
        return str;
    }
    
    function generateObject(pos:Vec2) {
        var body = new Body();
        body.position = pos;
 
        body.shapes.add(new Polygon(Polygon.box(20, 20)));
        body.shapes.at(0).filter.collisionGroup = Config.cgLoad;
            
        body.mass = 50;
        body.space = space;
    }
    
    override function mouseDown(_) {
        var mp = Vec2.get(mouseX, mouseY);
        var cp = cmpGrid.getClosestCell(mp);
        super.mouseDown(_);
        if (useHand) {
            // re-use the same list each time.
            bodyList = space.bodiesUnderPoint(mp, new InteractionFilter(Config.cgSensor), bodyList);
            trace(bodyList.length);
            for (body in bodyList) {
                if (body.isDynamic()) {
                    hand.body2 = body;
                    hand.anchor2 = body.worldPointToLocal(mp, true);
                    hand.active = true;
                    break;
                }
            }

            if (bodyList.empty()) {
                if (params.generator != null) {
                    params.generator(mp);
                }
            }
            else if (!hand.active) {
                if (params.staticClick != null) {
                    params.staticClick(mp);
                }
            }

            // recycle nodes.
            bodyList.clear();
        }
        else {
            if (params.generator != null) {
                params.generator(mp);
            }
        }
    }

    override function handMouseUp(_) {
        hand.active = false;
    }

}