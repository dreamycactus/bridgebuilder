package com.org.bbb;
import nape.constraint.ConstraintList;
import nape.phys.BodyType;
import nape.phys.Material;
import openfl.geom.Point;
import openfl.system.System;
import ru.stablex.ui.widgets.Radio;
import com.org.bbb.GameConfig.BuildMat;
import com.org.bbb.GameConfig.MatType;
import com.org.bbb.GameConfig.JointType;
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
    public var material(default, set_material) : BuildMat;

    var stage : Stage;
    var top : Top;
    var state :MESState;
    var cmpGrid : CmpGrid;
    
    public var spawn1 : Vec2;
    public var spawn2 : Vec2;
    public var isDrawing : Bool = false;
    public var isDrag : Bool = false;
    public var isDeck : Bool = false;
    public var isDeleteBeam : Bool = false;
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
    var baseMemory : Float;
    override public function init()
    {
        this.top = entity.state.top;
        this.state = entity.state;
        buildHistory = new BuildHistory(state);
        buildHistory.snapAndPush(builtBeams, lineChecker.copy());
        #if flash
        baseMemory = System.totalMemoryNumber;
        #end
        
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
        
        material = GameConfig.matDeck;
        this.camBody.inertia = 50; 

        camera = state.getSystem(SysRender).camera;
    }
    
    override public function update() : Void
    {
        #if flash
        //cast(UIBuilder.get('mem'), Text).text = "mem: " + (("" + (System.totalMemoryNumber - baseMemory) / (1024 * 1024)).substr(0, 5)) + "Mb";
        #end

        if (isDrag) {
            dragCamera();
        } else if (isDrawing) {
            panCamera();
        }
        
        if (editMode) {
            levelWidth = Std.parseFloat(inLevelW.text);
            levelHeight = Std.parseFloat(inLevelH.text);
        }
        
        if (editMode) {
            if (selectedBody != null) {
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
        }

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
                       + "total stress: " + body.calculateBeamStress().xy(true) + "\n"
                       + "space: " + body.space + "\n";
                       
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
    }
    
    function unregEvents()
    {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, beamDown);
        stage.removeEventListener(MouseEvent.MOUSE_UP, beamUp);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    }
    
    override public function deinit()
    {
        unregEvents();
    }
    
    public function createBox()
    {
        var b = new Body(BodyType.STATIC);
        b.shapes.add(new Polygon(Polygon.box(100, 100), null, new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor)));
        b.mass = 100;
        b.position.setxy(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
        b.space = level.space;
    }
    
    public function createSpawn()
    {
        var spawnIcon = new Body(BodyType.STATIC);
        spawnIcon.shapes.add(new Polygon(Polygon.box(30, 30), null, new InteractionFilter(GameConfig.cgSpawn, GameConfig.cmEditable)));
        spawnIcon.position = Vec2.get(300, 300);
        spawnIcon.space = level.space;
    }
    
    function beamDown(_) 
    {
        var mp = camera.screenToWorld(Vec2.weak(stage.mouseX, stage.mouseY));
        var cp = cmpGrid.getClosestCell(mp);
        var cFilter = GameConfig.cgAnchor | GameConfig.cgSharedJoint;
        
        if (isDeleteBeam) {
            spawn1 = mp;
            cFilter = GameConfig.cgBeam | GameConfig.cgCable | GameConfig.cgDeck;
        } else {
            spawn1 = cmpGrid.getCellPos(cp.x, cp.y);
        }
        var bb : BodyList = level.space.bodiesUnderPoint(spawn1, new InteractionFilter(GameConfig.cgSensor, cFilter) ) ;
        var otherBody : Body = null;
        startBody = null;
        isDrawing = true;
        /* Prefer to join to shared joint if possible */
        var sharedJointFilter = GameConfig.cgSharedJoint;
        if (isDeleteBeam) {
            sharedJointFilter = ~1;
        }
        for (b in bb) {
            if (b.shapes.at(0).filter.collisionGroup&cFilter != 0) {
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
        
        var validLine = lineChecker.isValidLine(spawn1, spawn2);

        if ( !isDeleteBeam && ((cp1.x == cp2.x && cp1.y == cp2.y) || startBody == null || !validLine) ) {
            return;
        }
        var cFilter = GameConfig.cgAnchor | GameConfig.cgSharedJoint;
        if (isDeleteBeam) {
            cFilter = GameConfig.cgBeam | GameConfig.cgCable | GameConfig.cgDeck;
            spawn2 = camera.screenToWorld(Vec2.weak(stage.mouseX, stage.mouseY));
        }
        
        var bb : BodyList = level.space.bodiesUnderPoint(spawn2, new InteractionFilter(GameConfig.cgSensor, cFilter) );
        var endBody : Body = null;
        var otherBody : Body = null;
        
        if (isDeleteBeam && startBody != null) {
            var ent : Entity = startBody.userData.entity;
            if (ent != null && bb.has(startBody)) {
                var cmpBeam = ent.getCmpsHavingAncestor(CmpBeamBase)[0];
                buildHistory.snapAndPush(builtBeams, lineChecker.copy());
                lineChecker.removeLine(cmpBeam.p1, cmpBeam.p2);
                builtBeams.remove(ent);
                state.deleteEnt(startBody.userData.entity);
                startBody = null;
            }
            return;
        }
        
        for (b in bb) {
            if ((b.shapes.at(0).filter.collisionGroup&GameConfig.cgSharedJoint) != 0) {
                endBody = b;
            } else {
                otherBody = b;
            }
        }
        var genBody : { body : Body, ent : Entity } = null;
        var beamStartBody : Body = null;
        var lastBody : Body = null;
        var beamEnt : Entity = null;
        
        buildHistory.snapAndPush(builtBeams, lineChecker.copy());

        if (endBody == null) {
            var e = EntFactory.inst.createSharedJoint(spawn2, [otherBody]);
            state.insertEnt(e);
            builtBeams.push(e);
            endBody = e.getCmp(CmpSharedJoint).body;
        }

        switch(material.matType) {
        case MatType.DECK:
            genBody = genBeam(endBody, otherBody, new InteractionFilter(GameConfig.cgDeck, GameConfig.cmDeck));
            lastBody = genBody.body;
            beamStartBody = lastBody;
            beamEnt = genBody.ent;
        case MatType.BEAM:
            genBody = genBeam(endBody, otherBody, new InteractionFilter(GameConfig.cgBeam, GameConfig.cmBeam));
            lastBody = genBody.body;
            beamStartBody = lastBody;
            beamEnt = genBody.ent;
        case MatType.CABLE:
            var cab = state.createEnt("cc");
            var cmp = new CmpCable(spawn1, spawn2, GameConfig.matCable);
            cab.attachCmp(cmp);
            state.insertEnt(cab);
            beamEnt = cab;
            lastBody = cmp.getBody(cmp.compound.bodies.length - 1);
            beamStartBody = cmp.getBody(0);
            // Swap
            var dp = spawn1.sub(lastBody.position);
            var dp2 = spawn1.sub(beamStartBody.position);
            if (dp.lsq() < dp2.lsq()) {
                var t = lastBody;
                lastBody = beamStartBody;
                beamStartBody = t;
            }

        default:
        }
        
        lineChecker.addLine(spawn1, spawn2);
        
        if (endBody.userData.sharedJoint != null) {
            endBody.userData.sharedJoint.addBody(lastBody);
        }
        
        if (beamEnt != null) {
            builtBeams.push(beamEnt);
        }
        
        if (startBody.userData.sharedJoint == null) {
            var e = EntFactory.inst.createSharedJoint( spawn1, [startBody, beamStartBody]);
            state.insertEnt(e);
            builtBeams.push(e);
        } else {
            startBody.userData.sharedJoint.addBody(beamStartBody);
        }
        
        trace(builtBeams.length);

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
        
        var ent = EntFactory.inst.createBeamEnt(spawn1, spawn2, center, body, spawn1.sub(spawn2).length + 10, material, "bob");
        state.insertEnt(ent);
        

        body.userData.entity = ent;
        if (startBody.userData.sharedJoint != null) {
            startBody.userData.sharedJoint.addBody(body);
        } else {
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
                maxlen -= GameConfig.gridCellWidth * 0.5;
            }
        }
        return cp;
    }
    
    function selectBody()
    {
        var mousePos = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        var results = level.space.bodiesUnderPoint(mousePos, new InteractionFilter(GameConfig.cgSensor, (GameConfig.cmAnchor|GameConfig.cmEditable)));
        
        if (results.length == 0) {
            selectedBody = null;
            return;
        }
        selectedBody = results.at(0);
        lastSelectedBody = selectedBody;

        if (selectedBody.shapes.at(0).filter.collisionGroup == GameConfig.cgSpawn) {
            isSpawn = true;
        } else {
            isSpawn = false;
        }
        if (inW != null) {
            inW.text = cast(lastSelectedBody.bounds.width);
            inH.text = cast(lastSelectedBody.bounds.height);
            inX.text = cast(lastSelectedBody.position.x);
            inY.text = cast(lastSelectedBody.position.y);
        }
        
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
                                      , new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor));
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
                                GameConfig.camDragCoeff) );
    }
    
    function panCamera()
    {
        var dx = 0.0;
        var dy = 0.0;
        if (stage.mouseX < GameConfig.stageWidth * GameConfig.panBorder) {
            dx = GameConfig.panRate;
        } else if (stage.mouseX > GameConfig.stageWidth * (1 - GameConfig.panBorder)) {
            dx = -GameConfig.panRate;
        }
        if (stage.mouseY < GameConfig.stageHeight * GameConfig.panBorder) {
            dy = GameConfig.panRate;
        } else if (stage.mouseY > GameConfig.stageHeight * (1 - GameConfig.panBorder)) {
            dy = -GameConfig.panRate;
        }
        
        camera.pos = camera.pos.add(Vec2.weak(dx, dy));
    }
    
    public function restore()
    {
        for (e in builtBeams) {
            state.deleteEnt(e);
        }
        trace('built beams $builtBeams.length');
        var buildstate = buildHistory.pop();
        builtBeams = buildstate.ents;
        lineChecker = buildstate.lines;
        for (e in builtBeams) {
            state.insertEnt(e);
        }
    }
    
    public function undo()
    {
        if (buildHistory.length > 0) {
            //buildHistory.pop();
            restore();
        }
    }
    
    public function togglePause()
    {
        var sys = state.getSystem(SysPhysics);
        if (sys.paused) {
            buildHistory.snapAndPush(builtBeams, lineChecker.copy());
        } else {
            restore();
        }
        state.getSystem(SysLevelDirector).runExecution(sys.paused);

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
            
            cmpGrid.offset = Vec2.get(0, GameConfig.gridCellWidth-GameConfig.matDeck.height*0.5);
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
    
    function set_material(m : BuildMat) : BuildMat
    {
        isDeleteBeam = false;
        material = m;
        return m;
    }
    function keyDown(ev:KeyboardEvent) 
    {
        if (ev.keyCode == Keyboard.SPACE ) {
            togglePause();
        }
    }
}