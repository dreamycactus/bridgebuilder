package com.org.bbb;
import nape.constraint.ConstraintList;
import nape.phys.BodyType;
import openfl.geom.Point;
import ru.stablex.ui.widgets.Radio;
import com.org.bbb.Config.BuildMat;
import com.org.bbb.Config.MatType;
import com.org.bbb.Config.JointType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.Top;
import openfl.display.Stage;
import haxe.xml.Check.Filter;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.ui.Keyboard;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.InputText;
import ru.stablex.ui.widgets.Text;

using com.org.bbb.Util;

class CmpControlBuild extends CmpControl
{
    var material : BuildMat;

    var stage : Stage;
    var top : Top;
    var state :MESState;
    var cmpGrid : CmpGrid;
    
    public var spawn1 : Vec2;
    public var spawn2 : Vec2;
    public var isDrawing : Bool = false;
    public var isDrag : Bool = false;
    public var isDeck : Bool = false;
    var startBody : Body;
    
    var inW : InputText;
    var inH : InputText;
    var inX : InputText;
    var inY : InputText;
    var inLevelW : InputText;
    var inLevelH : InputText;
    var console : Text;
    
    
    public var selectedBody : Body;
    public var lastSelectedBody : Body;
    public var levelWidth : Float;
    public var levelHeight : Float;
    @:isVar public var editMode(default, set_editMode) : Bool = false;
    public var isDraggingBox : Bool = false;
    public var isExpandingBox : Bool = false;
    public var isSpawn : Bool = false;

    public var camera : Camera;
    var camBody : Body;
    var prevMouse : Vec2;
    public var level : CmpLevel;
    
    public var editSpace : Space;
    public var builtBeams : Array<Entity> = new Array();
    public var buildHistory : BuildHistory;
    var lineChecker : LineChecker = new LineChecker();


    public function new(stage : Stage, cmpGrid : CmpGrid, level : CmpLevel) 
    {
        super();
        this.stage = stage;
        this.cmpGrid = cmpGrid;
        this.camBody = new Body();
        this.level = level;
        
        levelWidth = level.width;
        levelHeight = level.height;
        
    }
    
    override public function update() : Void
    {

        if (isDrag) {
            dragCamera();
        } else if (isDrawing) {
            panCamera();
        }
        
        if (inW != null) {
            levelWidth = Std.parseFloat(inLevelW.text);
            levelHeight = Std.parseFloat(inLevelH.text);
        }
        
        if (editMode && selectedBody != null) {
            var dirty = false;
            if (isDraggingBox) {
                var v = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
                selectedBody.type = BodyType.DYNAMIC;
                selectedBody.position.addeq(v.sub(prevMouse, true));
                selectedBody.type = BodyType.STATIC;
                inX.text = cast(selectedBody.position.x);
                inY.text = cast(selectedBody.position.y);
                dirty = true;
            } else if (isExpandingBox) {
                if (isSpawn) {
                    selectedBody.type = BodyType.DYNAMIC;
                    if (prevMouse.x > selectedBody.position.x) {
                        selectedBody.rotation = 0;
                    } else {
                        selectedBody.rotation = Math.PI;
                    }
                    selectedBody.type = BodyType.STATIC;
                } else {
                    var dp = Vec2.get(stage.mouseX, stage.mouseY).sub(prevMouse);
                    var dx = Util.clampf(1+dp.x*0.005, 0.7, 1.3);
                    var dy = Util.clampf(1-dp.y*0.005, 0.7, 1.3);
                    selectedBody.type = BodyType.DYNAMIC;
                    selectedBody.scaleShapes(dx, dy);
                    selectedBody.type = BodyType.STATIC;
                    inW.text = cast(selectedBody.bounds.width);
                    inH.text = cast(selectedBody.bounds.height);
                    dirty = true;
                }
                
            }
        }
        setBox();
        setPos();
        prevMouse = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        
        console.text = "";
        var res = level.space.bodiesUnderPoint(prevMouse);
        res.foreach(function(b) {
            console.text += printBodyForces(b) + '\n';
        });

    }
    
    function printBodyForces(body : Body) : String
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
    
    function regEvents()
    {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, beamDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, beamUp);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        //stage.addEventListener(MouseEvent.RIGHT_CLICK, createBox.bind(null));
    }
    
    function unregEvents()
    {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, beamDown);
        stage.removeEventListener(MouseEvent.MOUSE_UP, beamUp);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        //stage.removeEventListener(MouseEvent.RIGHT_CLICK, spawnBox);
    }
    
    override public function init()
    {
        this.top = entity.state.top;
        this.state = entity.state;
        this.buildHistory = new BuildHistory(state);
        
        if (inW == null) {
            inW = cast(UIBuilder.get('inWidth'), InputText);
            inH = cast(UIBuilder.get('inHeight'), InputText);
            inX = cast(UIBuilder.get('inX'), InputText);
            inY = cast(UIBuilder.get('inY'), InputText);
            inLevelW = cast(UIBuilder.get('levelWidth'), InputText);
            inLevelW.text = Std.string(level.width);
            inLevelH = cast(UIBuilder.get('levelHeight'), InputText);
            inLevelH.text = Std.string(level.height);
            console = cast(UIBuilder.get('console'), Text);
        }
        regEvents();
        
        material = Config.matSteelDeck;
        this.camBody.inertia = 50; 

        camera = state.getSystem(SysRender).camera;
    }
    
    override public function deinit()
    {
        unregEvents();
    }
    
    public function createBox()
    {
        var b = new Body(BodyType.STATIC);
        b.shapes.add(new Polygon(Polygon.box(100, 100), null, new InteractionFilter(Config.cgAnchor, Config.cmAnchor)));
        b.mass = 100;
        b.position.setxy(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
        b.space = level.space;
    }
    
    public function createSpawn()
    {
        var spawnIcon = new Body(BodyType.STATIC);
        spawnIcon.shapes.add(new Polygon(Polygon.box(30, 30), null, new InteractionFilter(Config.cgSpawn, Config.cmSpawn)));
        spawnIcon.position = Vec2.get(300, 300);
        spawnIcon.space = level.space;
    }
    
    function beamDown(_) 
    {
        var mp = camera.screenToWorld(Vec2.weak(stage.mouseX, stage.mouseY));
        var cp = cmpGrid.getClosestCell(mp);
        spawn1 = cmpGrid.getCellPos(cp.x, cp.y);
        var bb : BodyList = level.space.bodiesUnderPoint(spawn1, new InteractionFilter(Config.cgSensor) ) ;
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
        if (isDrag) {
            isDrag = false;
            return;
        }
        
        isDrawing = false;
        isDrag = false;
        
        if (spawn1 == null) {
            return;
        }
        
        var cp1 = cmpGrid.getClosestCell(spawn1);
        spawn2 = calculateBeamEnd();
        var cp2 = cmpGrid.getClosestCell(spawn2);
        
        var validLine = lineChecker.addLine(spawn1, spawn2);

        if ( (cp1.x == cp2.x && cp1.y == cp2.y) || startBody == null || !validLine) {
            return;
        }
        
        var bb : BodyList = level.space.bodiesUnderPoint(spawn2, new InteractionFilter(Config.cgSensor) );
        var endBody : Body = null;
        var otherBody : Body = null;
        
        for (b in bb) {
            if ((b.shapes.at(0).filter.collisionGroup&Config.cgSharedJoint) != 0) {
                endBody = b;
            } else {
                otherBody = b;
            }
        }
        var genBody : { body : Body, ent : Entity } = null;
        switch(material.matType) {
        case MatType.DECK:
            genBody = genBeam(endBody, otherBody, new InteractionFilter(Config.cgDeck, Config.cmDeck));
        case MatType.BEAM:
            genBody = genBeam(endBody, otherBody, new InteractionFilter(Config.cgBeam, Config.cmBeam));
        case MatType.CABLE:
            var cab = state.createEnt();
            var end = endBody == null ? otherBody : endBody;
            if (end != null && startBody != null) {
                var cmp = new CmpCable(startBody, end, spawn1, spawn2, Config.matCable);
                cab.attachCmp(cmp);
                state.insertEnt(cab);
                //lastBody = cmp.compound.bodies.at(0); 
            }
            builtBeams.push(cab);
        default:
        } 
        
        if (startBody.userData.sharedJoint == null) {
            var e = EntFactory.inst.createSharedJoint( spawn1, [startBody, genBody.body]);
            state.insertEnt(e);
            builtBeams.push(e);
        }

        spawn1 = null;
        spawn2 = null;
        startBody = null;
    }
    
    function genBeam(endBody : Body, otherBody : Body, iFilter : InteractionFilter) : { body : Body, ent : Entity }
    {
        var body : Body = new Body();
        var center = spawn1.add(spawn2).mul(0.5);
        var beamshape = new Polygon(Polygon.box(spawn1.sub(spawn2).length + 10, material.height), 
                                    null, iFilter );
        body.shapes.add(beamshape);
        body.rotation = spawn2.sub(spawn1).angle;
        body.mass = 1;
        body.space = level.space;
        
        var ent = EntFactory.inst.createBeamEnt(center, body, spawn1.sub(spawn2).length + 10, material, "bob");
        state.insertEnt(ent);
        builtBeams.push(ent);
        
        //var ejoint = EntFactory.inst.createJointEnt(spawn1, startBody, body, JointType.BEAM);
        //state.insertEnt(ejoint);
        if (startBody.userData.sharedJoint != null) {
            startBody.userData.sharedJoint.addBody(body);
        } else {
            //var ejoint = EntFactory.inst.createJointEnt(spawn1, startBody, body, JointType.BEAM);
            //state.insertEnt(ejoint);
            //builtBeams.push(ejoint);
        }
        var lastBody = body;
        if (endBody == null) {
            var e = EntFactory.inst.createSharedJoint(spawn2, [lastBody, otherBody]);
            state.insertEnt(e);
            builtBeams.push(e);
            endBody = e.getCmp(CmpSharedJoint).body;
        } else {
            if (endBody.userData.sharedJoint != null) {
                endBody.userData.sharedJoint.addBody(body);
            }
        }
        return { body : body, ent : ent };
    }
    
    public function calculateBeamEnd() : Vec2
    {
        var mouseWorldPos = camera.screenToWorld(Vec2.weak(stage.mouseX, stage.mouseY));
        var delta = mouseWorldPos.sub(spawn1);
        var maxlen = cmpGrid.lengthOfCells(material.maxLength-1);
        var cp : Vec2 = null;
        while(true) {
            var beamMax = delta.length >= maxlen ? 
                delta.copy().normalise().mul(maxlen).add(spawn1) 
              : delta.add(spawn1);
            var cell = cmpGrid.getClosestCell(beamMax);
            var cellpos = cmpGrid.getCellPos(cell.x, cell.y);
            
            if (spawn1.sub(cellpos).length <= maxlen) {
                cp = cellpos;
                break;
            } else {
                maxlen -= Config.gridCellWidth * 0.5;
            }
        }
        return cp;
    }
    
    function selectBody()
    {
        var mousePos = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        var results = level.space.bodiesUnderPoint(mousePos, new InteractionFilter(Config.cgSensor, (Config.cgSpawn|Config.cgAnchor)));
        
        if (results.length == 0) {
            selectedBody = null;
            return;
        }
        selectedBody = results.at(0);
        lastSelectedBody = selectedBody;

        if (selectedBody.shapes.at(0).filter.collisionGroup == Config.cgSpawn) {
            isSpawn = true;
        } else {
            isSpawn = false;
        }
        inW.text = cast(lastSelectedBody.bounds.width);
        inH.text = cast(lastSelectedBody.bounds.height);
        inX.text = cast(lastSelectedBody.position.x);
        inY.text = cast(lastSelectedBody.position.y);
        
    }
    public function loadLevelFromXml(state : MESState)
    {
        var loadText = cast(UIBuilder.get('load'), InputText).text;
        if (state == null) { state = entity.state; }
        cast(state, StateBridgeLevel).level = CmpLevel.genLevelFromString(state, loadText);
    }
    
    public function generateLevelXML()
    {
        var xml = level.generateLevelXML(levelWidth, levelHeight);
        cast(UIBuilder.get('gen'), InputText).text = xml.toString();
    }
    
    public function setPos()
    {
        var x = Std.parseFloat(inX.text);
        var y = Std.parseFloat(inY.text);
        
        if (Math.isNaN(x)) {
            x = -10000;
        }
        if (Math.isNaN(y)) {
            y = -10000;
        }
        
        if (lastSelectedBody != null && !Math.isNaN(x) && !Math.isNaN(y)) {
            lastSelectedBody.type = BodyType.DYNAMIC;
            lastSelectedBody.position.setxy(x, y);
            lastSelectedBody.type = BodyType.STATIC;
        }
    }
    
    public function setBox()
    {
        var w = Std.parseFloat(inW.text);
        var h = Std.parseFloat(inH.text);
        
        if (Math.isNaN(w) || w < 1) {
            w = 1;
        }
        if (Math.isNaN(h) || h < 1) {
            h = 1;
        }
        
        if (lastSelectedBody != null && !Math.isNaN(w) && !Math.isNaN(h)) {
            lastSelectedBody.type = BodyType.DYNAMIC;
            var newShape = null;
            if (!isSpawn) {
                newShape = new Polygon( Polygon.box(w, h, true)
                                      , null
                                      , new InteractionFilter(Config.cgAnchor, Config.cmAnchor));
            } else {
                newShape = cast(lastSelectedBody.shapes.at(0).copy());
            }
            lastSelectedBody.shapes.pop();
            lastSelectedBody.shapes.push(newShape);
            lastSelectedBody.type = BodyType.STATIC;
        }
    }
    
    function dragCamera()
    {
        camera.dragCamera(camera.screenToWorld(Vec2.weak(stage.mouseX, stage.mouseY)).sub(
                            prevMouse).mul(
                                Config.camDragCoeff) );
    }
    
    function panCamera()
    {
        var dx = 0.0;
        var dy = 0.0;
        if (stage.mouseX < Config.stageWidth * Config.panBorder) {
            dx = Config.panRate;
        } else if (stage.mouseX > Config.stageWidth * (1 - Config.panBorder)) {
            dx = -Config.panRate;
        }
        if (stage.mouseY < Config.stageHeight * Config.panBorder) {
            dy = Config.panRate;
        } else if (stage.mouseY > Config.stageHeight * (1 - Config.panBorder)) {
            dy = -Config.panRate;
        }
        
        camera.pos = camera.pos.add(Vec2.weak(dx, dy));
    }
    
    public function togglePause()
    {
        var sys = state.getSystem(SysPhysics);
        if (sys.paused) {
            buildHistory.snapAndPush(builtBeams, lineChecker);
        } else {
            for (e in builtBeams) {
                state.deleteEnt(e);
            }
            builtBeams = buildHistory.pop();
            for (e in builtBeams) {
                state.insertEnt(e);
            }
        }
       sys.paused = !sys.paused;
       
    }
    
    
    public function nextLevel()
    {
        var s1 = StateBridgeLevel.createLevelState(top, "levels/b" + (level.id + 1) + ".xml");
        top.changeState(new TransPan(top, cast(top.state), cast(s1)), true);
    }
    
    function set_editMode(m : Bool) : Bool
    {
        this.editMode = m;
        if (m) {
            unregEvents();
            stage.addEventListener(MouseEvent.MOUSE_DOWN, dragBox);
            stage.addEventListener(MouseEvent.MOUSE_UP, unDragBox);
            stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, expandBox);
            stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, unExpandBox);
            
            cmpGrid.offset = Vec2.get(0, 25-Config.matSteelDeck.height*0.5);
        } else {
            regEvents();
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, dragBox);
            stage.removeEventListener(MouseEvent.MOUSE_UP, unDragBox);
            stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, expandBox);
            stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, unExpandBox);
            cmpGrid.offset = Vec2.get();
        }
        return m;
    }
    
    
    function dragBox(_)
    {
        selectBody();
        if (selectedBody != null) {
            isDraggingBox = true;
        }
    }
    
    function unDragBox(_)
    {
        isDraggingBox = false;
    }
    
    function expandBox(_)
    {
        selectBody();
        if (selectedBody != null) {
            isExpandingBox = true;
        }
    }
    
    function unExpandBox(_)
    {
        isExpandingBox = false;
    }
    
    
    function keyDown(ev:KeyboardEvent) 
    {
        // 'r'
        if (ev.keyCode == Keyboard.SPACE ) {
            togglePause();
        } else if (ev.keyCode == Keyboard.D) {
            var bbb = level.space.bodiesUnderPoint(Vec2.weak(stage.mouseX, stage.mouseY), new InteractionFilter(Config.cgSensor) );
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
        } else if (ev.keyCode == Keyboard.RIGHT) {
            nextLevel();
        } else if (ev.keyCode == Keyboard.K) {
            selectBody();
        }  else if (ev.keyCode == Keyboard.G) {
            var g = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));
            trace(g);
        } 
    }
}