package com.org.bbb;

import com.org.bbb.Template.TemplateParams;
import com.org.mes.Top;
import flash.events.MouseEvent;
import flash.Lib;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
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
    
    public function new() 
    {
        super( {
            generator: generateObject,
            gravity: Vec2.get(0, 600),
            noReset: true
        });
        top = new Top();
        entfactory = new EntFactory(top);
    }
        var prev : Body = null;
    
        var found : PivotJoint;
        var found1 : PivotJoint;
    override function init() 
    {
        var w = 800;
        var h = 600;
        super.init();
        top.insertSystem(new SysPhysics(top, this.space) );
        top.insertSystem(new SysRender(top, this.space) );
        
        
        var joint : PivotJoint = new PivotJoint(space.world, null, Vec2.get(), Vec2.get());
        joint.breakUnderForce = true;
        joint.maxForce = 2e5;
        joint.frequency = 20;
        joint.stiff = false;
        joint.damping = 0.4;
        joint.active = false;
        
        var len = 3; 
        var first : Body = null;
        
        for (i in 0...len) {
            var x = 50.0 + i * 200.0;
            var y = 250.0;
            var box = new Body(BodyType.DYNAMIC);
            box.shapes.add(new Polygon(Polygon.box(200, 20)));
            box.position.setxy(x, y);
            box.space = space;
            var ebeam = entfactory.createBeamEnt(null, box);
            top.insertEnt(ebeam);
            
            if ( first == null ) {
                first = box;
            }
            if ( prev != null ) { 
                var j : PivotJoint = cast(joint.copy() );
                j.body1 = prev;
                j.body2 = box;
                j.anchor1 = prev.worldPointToLocal(Vec2.weak(x-75, y), true);
                j.anchor2 = box.worldPointToLocal(Vec2.weak(x-75, y), true);
                j.active = true;
                j.space = space;
                var ejoint = entfactory.createJointEnt(Vec2.get(), [ j ] );
                top.insertEnt(ejoint);
            }
            prev = box;
        }
        
        found1 = new PivotJoint(space.world, prev, prev.position.add( Vec2.get(40.0,0.0) ), Vec2.get(40.0,0.0) );
        found1.breakUnderForce = true;
        found1.maxForce = 4e5;
        //found1.frequency = 10;
        found1.stiff = false;
        //found1.damping = 0.4;
        //found1.active = false;
        found1.space = space;
        var ejoint1 = entfactory.createJointEnt(prev.position.add( Vec2.get(40.0,0.0) ), [ found1 ] );
        top.insertEnt(ejoint1);
        
        found  = new PivotJoint(space.world, prev, prev.position.add( Vec2.get(90.0,0.0) ), Vec2.get(90.0,0.0) );
        found.breakUnderForce = false;
        found.maxForce = 4e5;
        //found.frequency = 10;
        found.stiff = false;
        //found.damping = 0.4;
        //found.active = false;
        found.space = space;
        var ejoint = entfactory.createJointEnt(prev.position.add( Vec2.get(90.0,0.0) ), [ found ] );
        top.insertEnt(ejoint);
        
        
        var floor = new Body(BodyType.STATIC);
        floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
        floor.space = space;
        
        var wpoint = Vec2.get(50, h - 50);
        
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightmouseDown);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, rightmouseUp);
        
    }
    
    override function enterFrame(_) {
        var curTime = Lib.getTimer();
        var deltaTime:Float = (curTime - prevTime);
        trace(deltaTime);
        
        super.enterFrame(_);
        //prevTime = curTime;
        top.update(deltaTime);
        
        var bodies = space.bodies;
        
        //for ( b in bodies ) {
            //trace( "force: " + b.totalImpulse() );
        //}
        textField.text = "total contacts: " + prev.totalContactsImpulse().Vec3ToIntString() + ",\n" 
                       + "total impulse: " + prev.totalImpulse().Vec3ToIntString() + "\n" 
                       + "total constraint: " + prev.constraintsImpulse().Vec3ToIntString() + "\n"
                       + "joint 40 :" + found.bodyImpulse(prev).Vec3ToIntString() + ", " + found.impulse() + "\n"
                       + "joint 90 :" + found1.bodyImpulse(prev).Vec3ToIntString() + ", " + found1.impulse() + "\n";
    }
    
    function generateObject(pos:Vec2) {
        var body = new Body();
        body.position = pos;
 
        // Add random one of either a Circle, Box or Pentagon.
        if (Math.random() < 0) {
            body.shapes.add(new Circle(10));
        }
        else if (Math.random() < 2.5) {
            body.shapes.add(new Polygon(Polygon.box(20, 20)));
            body.mass = 10;
        }
        else {
            body.shapes.add(new Polygon(Polygon.regular(10, 10, 5)));
        }
 
        body.space = space;
    }
    
    override function mouseDown(_) {
        var mp = Vec2.get(mouseX, mouseY);
        if (useHand) {
            // re-use the same list each time.
            bodyList = space.bodiesUnderPoint(mp, null, bodyList);

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
        mp.dispose();
    }

    override function handMouseUp(_) {
        hand.active = false;
    }
    
    function rightmouseDown(_) {
        
    }
    
    function rightmouseUp(_) {
        
    }
    
}