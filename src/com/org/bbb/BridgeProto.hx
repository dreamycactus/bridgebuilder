package com.org.bbb;

import com.org.bbb.Template.TemplateParams;
import com.org.mes.Entity;
import com.org.mes.Top;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.ui.Keyboard;
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
        var w = 800;
        var h = 600;
        super.init();
        top.insertSystem(new SysPhysics(top, this.space) );
        top.insertSystem(new SysRender(top, this.space, Lib.current.stage) );
        
        top.insertEnt(grid);
        
        top.init();
        
        Lib.current.stage.addChild(uiSprite);
        
        var joint : PivotJoint = new PivotJoint(space.world, null, Vec2.get(), Vec2.get());
        joint.breakUnderForce = true;
        joint.maxForce = 2e5;
        joint.frequency = 20;
        joint.stiff = false;
        joint.damping = 0.4;
        joint.active = false;
        
        var len = 4; 
        var first : Body = null;
        var segLen = 100.0;
        
        //for (i in 0...len) {
            //var x = 210.0 + i * segLen;
            //var y = 210.0;
            //var box = new Body(BodyType.DYNAMIC);
            //box.shapes.add(new Polygon(Polygon.box(segLen, 10)));
            //box.space = space;
            //var ebeam = entfactory.createBeamEnt(Vec2.get(x,y), box);
            //top.insertEnt(ebeam);
            //trace(box.position);
            //
            //if ( first == null ) {
                //first = box;
            //}
            //if ( prev != null ) { 
                //var j = new WeldJoint(box, prev, Vec2.weak(-segLen * 0.5, 0), Vec2.weak(segLen * 0.5, 0) );
                ////j.frequency = 10000;
                //j.space = space;
                //j.breakUnderForce = true;
                //j.maxForce = 5e6;
                //var ejoint = entfactory.createJointEnt(Vec2.get(), [ j ] );
                //top.insertEnt(ejoint);
            //}
            //prev = box;
        //}
        
        //
        //found1 = new PivotJoint(space.world, prev, prev.position.add( Vec2.get(40.0,0.0) ), Vec2.get(40.0,0.0) );
        //found1.breakUnderForce = true;
        //found1.maxForce = 4e5;
        ////found1.frequency = 10;
        //found1.stiff = false;
        ////found1.damping = 0.4;
        ////found1.active = false;
        //found1.space = space;
        //var ejoint1 = entfactory.createJointEnt(prev.position.add( Vec2.get(40.0,0.0) ), [ found1 ] );
        //top.insertEnt(ejoint1);
        //
        //found  = new PivotJoint(space.world, prev, prev.position.add( Vec2.get(90.0,0.0) ), Vec2.get(90.0,0.0) );
        //found.breakUnderForce = false;
        //found.maxForce = 4e5;
        ////found.frequency = 10;
        //found.stiff = false;
        ////found.damping = 0.4;
        ////found.active = false;
        //found.space = space;
        //var ejoint = entfactory.createJointEnt(prev.position.add( Vec2.get(90.0,0.0) ), [ found ] );
        //top.insertEnt(ejoint);
        
        
        var floor = new Body(BodyType.STATIC);
        floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
        floor.space = space;
        
        var floor1 = new Body(BodyType.STATIC);
        floor1.shapes.add(new Polygon(Polygon.box(100, 100)));
        floor1.position.setxy(150, 150);
        floor1.shapes.at(0).filter.collisionMask = 0;
        floor1.space = space;
        
        var comp = CmpBeam.splitBeam(floor1);
        //comp.translate(Vec2.get(100, 200 ) );
        comp.space = space;
        
        var floor2 = new Body(BodyType.STATIC);
        floor2.shapes.add(  new Polygon( Polygon.box(100, 100) )  );
        floor2.position.setxy(650, 150);
        floor2.shapes.at(0).filter.collisionMask = 0;
        floor2.space = space;
        
        var wpoint = Vec2.get(50, h - 50);
        
        //var j1 = new PivotJoint(first, floor1, Vec2.weak( -segLen * 0.5, 0), Vec2.weak(50, 0) );
        //var j2 = new PivotJoint(prev, floor2, Vec2.weak( segLen * 0.5, 0), Vec2.weak( -50, 0) );
        //j1.space = space;
        //j2.space = space;

        
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightmouseDown);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, rightmouseUp);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        
    }
    
    override function enterFrame(_) {
        var curTime = Lib.getTimer();
        var deltaTime:Float = (curTime - prevTime);
        prevTime = curTime;
        
        super.enterFrame(_);
        //prevTime = curTime;
        top.update(deltaTime);
        
        var bodies = space.bodies;
        
        var mp = Vec2.get(mouseX, mouseY);
        var bb : BodyList = space.bodiesUnderPoint(mp, null, null);
        
        if (bb != null && bb.length > 0) {
            textField.text = printBodyForces(bb.at(0) );
        } else {
            //textField.text = "";
        }
        
        if (spawn1 != null) {
            var g = uiSprite.graphics;
        
            g.clear();
            g.lineStyle(1, 0xFF0088, 0.6);
            g.beginFill(0xFFFFFF, 1.0);
        
            g.moveTo(spawn1.x, spawn1.y);
            g.lineTo(mouseX, mouseY);    
            g.endFill();
        }
        var cp = cmpGrid.getClosestCell(mp);
        textField.text += "\n" + cp +"\n" + mp;
        
        //for ( b in bodies ) {
            //trace( "force: " + b.totalImpulse() );
        //}
    }
    
    function printBodyForces(body : Body)
    {
        var str =        "body id: " + body.id + "\n"
                       + "total contacts: " + body.totalContactsImpulse().Vec3ToIntString() + ",\n" 
                       + "total impulse: " + body.totalImpulse().Vec3ToIntString() + "\n" 
                       + "total constraint: " + body.constraintsImpulse().Vec3ToIntString() + "\n";
                       
        for (c in body.constraints) {
            str += "constraint impulse: " + c.bodyImpulse(body).Vec3ToIntString() +"\n";
        }
        return str;
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
            body.shapes.at(0).filter.collisionGroup = 2;
            body.mass = 10;
        }
        else {
            body.shapes.add(new Polygon(Polygon.regular(10, 10, 5)));
        }
 
        body.space = space;
    }
    
    override function mouseDown(_) {
        var mp = Vec2.get(mouseX, mouseY);
        var cp = cmpGrid.getClosestCell(mp);
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
    
    var spawn1 : Vec2;
    var spawn2 : Vec2;
    var startBody : Body;
    
    function rightmouseDown(_) {
        var mp = Vec2.get(mouseX, mouseY);
        var cp = cmpGrid.getClosestCell(mp);
        spawn1 = cmpGrid.getCellPos(cp.x, cp.y);
        var bb : BodyList = space.bodiesUnderPoint(spawn1, null, null);
        
        if (bb != null && bb.length > 0) {
            startBody = bb.at(0);
            trace(startBody);
        }
    }
    var deck : Body = null;
    function rightmouseUp(_) {
        var mp = Vec2.get(mouseX, mouseY);
        var cp1 = cmpGrid.getClosestCell(spawn1);
        var cp2 = cmpGrid.getClosestCell(mp);
        spawn2 = cmpGrid.getCellPos(cp2.x, cp2.y);
        
        if ( (cp1.x == cp2.x && cp1.y == cp2.y) || startBody == null) {
            return;
        }
        
        var body : Body = new Body();
        var center = spawn1.add(spawn2).mul(0.5);
        var beamshape = new Polygon(Polygon.box(spawn1.sub(spawn2).length, 7.0) );
        
        beamshape.filter.collisionGroup = 1;
            beamshape.filter.collisionMask = ~1;

        body.shapes.add(beamshape);
        body.rotation = spawn2.sub(spawn1).angle;
        body.space = space;
        top.insertEnt(entfactory.createBeamEnt(center, body, "bob") );

        var j : PivotJoint = new PivotJoint(startBody, body, startBody.worldPointToLocal(spawn1), body.worldPointToLocal(spawn1) );
        j.stiff = true;
        j.space = space;
        var ejoint = entfactory.createJointEnt(Vec2.get(), [ j ] );
        top.insertEnt(ejoint);
        
        var bb : BodyList = space.bodiesUnderPoint(spawn2, null, null);
        var endBody : Body = null;
        
        bb.foreach(function(b) {
            if (b != startBody && b != body) {
                endBody = b;
                return;
            }
        });
         
        if (endBody != null) {
            var j : PivotJoint = new PivotJoint(endBody, body, endBody.worldPointToLocal(spawn2), body.worldPointToLocal(spawn2) );
            j.stiff = true;
            j.space = space;
            var ejoint = entfactory.createJointEnt(Vec2.get(), [ j ] );
            top.insertEnt(ejoint);
        }
        
        if (deck == null) {
            deck = body;
        }
        //
        //var c = CmpBeam.splitBeam(body);
        //c.space = space;
        //body.space = null;
        
        spawn1 = null;
        spawn2 = null;
        startBody = null;
    }
    
    var ca : Compound;
    override function keyDown(ev:KeyboardEvent) {
        // 'r'
        if (ev.keyCode == Keyboard.SPACE ) {
           var sys = top.getSystem(SysPhysics);
           sys.paused = !sys.paused;
        } else if (ev.keyCode == Keyboard.C && deck != null) {
            ca = CmpBeam.splitBeam(deck);
            ca.space = space;
            deck.space = null;
        } else if (ev.keyCode == Keyboard.RIGHT) {
            //ca.rotate(Vec2.get(), 0.01);
        }
    }
}