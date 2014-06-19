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
    var material : BuildMat = BuildMat.STEELBEAM;
    
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
        var w = Lib.current.stage.stageWidth;
        var h = Lib.current.stage.stageHeight;
        super.init();
        top.insertSystem(new SysPhysics(top, this.space) );
        top.insertSystem(new SysRender(top, this.space, Lib.current.stage) );
       
        top.init();
        
        Cmp.cmpManager.makeParentChild(CmpRender, [CmpRenderGrid]);
        Cmp.cmpManager.registerCmp(CmpPhys);
        Cmp.cmpManager.makeParentChild(CmpPhys, [CmpBeam,CmpJoint,CmpMultiBeam, CmpSharedJoint, CmpCable]);
        trace(Cmp.cmpManager.printAll() );
        
        top.insertEnt(grid);
        
        Lib.current.addChild(uiSprite);
        
        
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
        
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightmouseDown);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, rightmouseUp);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        
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
        textField.text += "\n" + cp +"\n" + mp +"\n" + material;
        
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
    
    var spawn1 : Vec2;
    var spawn2 : Vec2;
    var startBody : Body;
    
    function rightmouseDown(_) {
        var mp = Vec2.get(mouseX, mouseY);
        var cp = cmpGrid.getClosestCell(mp);
        spawn1 = cmpGrid.getCellPos(cp.x, cp.y);
        var bb : BodyList = space.bodiesUnderPoint(spawn1, new InteractionFilter(Config.cgSensor) ) ;
        
        var otherBody : Body = null;
        startBody = null;
        /* Prefer to join to shared joint if possible */
        for (b in bb) {
            if (b.shapes.at(0).filter.collisionGroup&(Config.cgSharedJoint|Config.cgAnchor) != 0) {
                startBody = b;
            } else {
                otherBody = b;
            }
        }
        if (startBody == null) {
            startBody = otherBody;
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
        
        var bb : BodyList = space.bodiesUnderPoint(spawn2);
        var endBody : Body = null;
        var otherBody : Body = null;
        
        for (b in bb) {
            if ((b.shapes.at(0).filter.collisionGroup&Config.cgSharedJoint) != 0) {
                endBody = b;
            } else {
                otherBody = b;
            }
        }
        
        var lastBody : Body = null;
        switch(material) {
        case BuildMat.STEELBEAM:
            var body : Body = new Body();
            var center = spawn1.add(spawn2).mul(0.5);
            var mat = Config.matIron;
            var beamshape = new Polygon(Polygon.box(spawn1.sub(spawn2).length + 10, mat.height) );
            
            beamshape.filter.collisionGroup = Config.cgBeam;
            beamshape.filter.collisionMask = Config.cmBeam;

            body.shapes.add(beamshape);
            body.rotation = spawn2.sub(spawn1).angle;
            body.mass = 1;
            body.space = space;
            top.insertEnt(entfactory.createBeamEnt(center, body, "bob") );
            
            var ejoint = entfactory.createJointEnt(spawn1, startBody, body, JointType.ANCHOR);
            top.insertEnt(ejoint);        
            lastBody = body;
            if (endBody == null) {
                var e = entfactory.createSharedJoint(spawn2, [lastBody, otherBody]);
                top.insertEnt(e);
                endBody = e.getCmp(CmpSharedJoint).body;
            } else {
                if (endBody.userData.sharedJoint != null) {
                    endBody.userData.sharedJoint.addBody(body);
                }
            }
        case BuildMat.CABLE:
            var cableMat : CableMat = { segWidth : 30, segHeight : 15, maxTension : 1e8 };
            var cab = top.createEnt();
            var end = endBody == null ? otherBody : endBody;
            var cmp = new CmpCable(startBody, end, spawn1, spawn2, cableMat);
            cab.attachCmp(cmp);
            top.insertEnt(cab);
            lastBody = cmp.compound.bodies.at(0);
        default:
        } 

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
            ca = CmpMultiBeam.createFromBeam(deck, SplitType.MOMENT, cast(deck.constraints.at(0) ) );
            ca.space = space;
            //deck.space = null;
        } else if (ev.keyCode == Keyboard.RIGHT) {
            //ca.rotate(Vec2.get(), 0.01);
        } else if (ev.keyCode == Keyboard.D) {
            var bbb = space.bodiesUnderPoint(Vec2.weak(mouseX, mouseY), new InteractionFilter(Config.cgSensor) );
            trace("t" + bbb.length);
            bbb.foreach(function(b) {
                trace(b.constraints.length);
                for (i in 0...b.constraints.length) {
                    b.constraints.at(i).space = null;
                }
                b.space = null;
            });
        } else if (ev.keyCode == Keyboard.NUMBER_1) {
            material = BuildMat.STEELBEAM;
        } else if (ev.keyCode == Keyboard.NUMBER_2) {
            material = BuildMat.CABLE;
        }
    }
}