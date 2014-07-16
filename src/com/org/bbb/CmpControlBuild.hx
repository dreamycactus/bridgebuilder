package com.org.bbb;
import com.org.bbb.Config.BuildMat;
import com.org.bbb.Config.MatType;
import com.org.bbb.Config.JointType;
import com.org.mes.Cmp;
import com.org.mes.Top;
import flash.display.Stage;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;
import ru.stablex.ui.UIBuilder;

using com.org.bbb.Util;

/**
 * ...
 * @author 
 */
class CmpControlBuild extends CmpControl
{
    var material : BuildMat;

    var stage : Stage;
    var top : Top;
    var space : Space;
    var cmpGrid : CmpGrid;
    public var spawn1 : Vec2;
    public var spawn2 : Vec2;
    public var isDrawing : Bool = false;
    public var isDrag : Bool = false;
    public var isDeck : Bool = false;

    var startBody : Body;
    
    public var camera : Camera;
    var camBody : Body;
    var prevMouse : Vec2;
    var level : CmpLevel;

    public function new(stage : Stage, space : Space, cmpGrid : CmpGrid, level : CmpLevel) 
    {
        super();
        this.stage = stage;
        this.space = space;
        this.cmpGrid = cmpGrid;
        this.camBody = new Body();
        this.level = level;
    }
    
    override public function update() : Void
    {
        if (isDrag) {
            dragCamera();
        }
        prevMouse = Vec2.get(stage.mouseX, stage.mouseY);
        //trace(camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY)));
    }
    
    override public function init()
    {
        this.top = entity.top;
        stage.addEventListener(MouseEvent.MOUSE_DOWN, beamDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, beamUp);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        
        material = Config.matSteelDeck;
        this.camBody.inertia = 50; 

        camera = top.getSystem(SysRender).camera;
    }
    
    override public function deinit()
    {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, beamDown);
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, beamUp);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    }
    
    function beamDown(_) 
    {
        var mp = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        var cp = cmpGrid.getClosestCell(mp);
        spawn1 = cmpGrid.getCellPos(cp.x, cp.y);
        trace(spawn1 + ", " + cp + ", " + mp);
        var bb : BodyList = space.bodiesUnderPoint(spawn1, new InteractionFilter(Config.cgSensor) ) ;
        var otherBody : Body = null;
        startBody = null;
        isDrawing = true;
        /* Prefer to join to shared joint if possible */
        for (b in bb) {
            if (b.shapes.at(0).filter.collisionGroup&(Config.cgSharedJoint|Config.cgAnchor) != 0) {
                startBody = b;
            } else {
                otherBody = b;
            }
        }
        if (startBody == null && otherBody != null) {
            startBody = otherBody;
        }
        
        if (startBody == null) {
            isDrawing = false;
            isDrag = true;
        }
    }
    
    function beamUp(_)
    {
        var mp = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        var cp1 = cmpGrid.getClosestCell(spawn1);
        var cp2 = cmpGrid.getClosestCell(mp);
        spawn2 = cmpGrid.getCellPos(cp2.x, cp2.y);
        isDrawing = false;
        isDrag = false;
        
        if ( (cp1.x == cp2.x && cp1.y == cp2.y) || startBody == null) {
            return;
        }
        
        var bb : BodyList = space.bodiesUnderPoint(spawn2, new InteractionFilter(Config.cgSensor) );
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
        switch(material.matType) {
        case MatType.DECK:
            var body : Body = new Body();
            var center = spawn1.add(spawn2).mul(0.5);
            var beamshape = new Polygon(Polygon.box(spawn1.sub(spawn2).length + 10, material.height), 
                                        null, new InteractionFilter(Config.cgDeck, Config.cmDeck) );
            body.shapes.add(beamshape);
            body.rotation = spawn2.sub(spawn1).angle;
            body.mass = 1;
            body.space = space;
            top.insertEnt(EntFactory.inst.createBeamEnt(center, body, "bob") );
            
            var ejoint = EntFactory.inst.createJointEnt(spawn1, startBody, body, JointType.ANCHOR);
            top.insertEnt(ejoint);        
            lastBody = body;
            if (endBody == null) {
                var e = EntFactory.inst.createSharedJoint(spawn2, [lastBody, otherBody]);
                top.insertEnt(e);
                endBody = e.getCmp(CmpSharedJoint).body;
            } else {
                if (endBody.userData.sharedJoint != null) {
                    endBody.userData.sharedJoint.addBody(body);
                }
            }
        case MatType.BEAM:
            var body : Body = new Body();
            var center = spawn1.add(spawn2).mul(0.5);
            var beamshape = new Polygon(Polygon.box(spawn1.sub(spawn2).length + 10, material.height), 
                                        null, new InteractionFilter(Config.cgBeam, Config.cmBeam) );
            body.shapes.add(beamshape);
            body.rotation = spawn2.sub(spawn1).angle;
            body.mass = 1;
            body.space = space;
            top.insertEnt(EntFactory.inst.createBeamEnt(center, body, "bob") );
            
            var ejoint = EntFactory.inst.createJointEnt(spawn1, startBody, body, JointType.ANCHOR);
            top.insertEnt(ejoint);        
            lastBody = body;
            if (endBody == null) {
                var e = EntFactory.inst.createSharedJoint(spawn2, [lastBody, otherBody]);
                top.insertEnt(e);
                endBody = e.getCmp(CmpSharedJoint).body;
            } else {
                if (endBody.userData.sharedJoint != null) {
                    endBody.userData.sharedJoint.addBody(body);
                }
            }
        case MatType.CABLE:
            var cab = top.createEnt();
            var end = endBody == null ? otherBody : endBody;
            if (end != null && startBody != null) {
                var cmp = new CmpCable(startBody, end, spawn1, spawn2, Config.matCable);
                cab.attachCmp(cmp);
                top.insertEnt(cab);
                //lastBody = cmp.compound.bodies.at(0); 
            }
        default:
        } 

        spawn1 = null;
        spawn2 = null;
        startBody = null;
    }
    
    function dragCamera()
    {
        camera.pos = camera.pos.sub(prevMouse.sub(Vec2.weak(stage.mouseX, stage.mouseY) ).mul(Config.camDragCoeff) );
    }
    
    public function togglePause()
    {
       var sys = top.getSystem(SysPhysics);
       sys.paused = !sys.paused;
    }
    
    function keyDown(ev:KeyboardEvent) 
    {
        // 'r'
        if (ev.keyCode == Keyboard.SPACE ) {
            togglePause();
        } else if (ev.keyCode == Keyboard.C) {
            top.insertEnt( EntFactory.inst.createCar( camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY))) );
        } else if (ev.keyCode == Keyboard.D) {
            var bbb = space.bodiesUnderPoint(Vec2.weak(stage.mouseX, stage.mouseY), new InteractionFilter(Config.cgSensor) );
            bbb.foreach(function(b) {
                for (i in 0...b.constraints.length) {
                    b.constraints.at(i).space = null;
                }
                b.space = null;
            });
        } else if (ev.keyCode == Keyboard.NUMBER_1) {
            material = Config.matSteelBeam;
        } else if (ev.keyCode == Keyboard.NUMBER_2) {
            material = Config.matCable;
        } else if (ev.keyCode == Keyboard.NUMBER_0) {
            isDeck = !isDeck;
        } else if (ev.keyCode == Keyboard.PAGE_UP) {
            camera.zoom += 0.1;
        } else if (ev.keyCode == Keyboard.PAGE_DOWN) {
            camera.zoom -= 0.1;
        }
    }
}