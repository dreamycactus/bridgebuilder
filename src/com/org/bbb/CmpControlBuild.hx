package com.org.bbb;
import com.org.bbb.BuildMat.MatType;
import com.org.bbb.CmpAnchor.AnchorStartEnd;
import com.org.bbb.CmpSpawn.SpawnType;
import com.org.bbb.GameConfig.MaterialNames;
import haxe.ds.GenericStack;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.ObjectMap;
import haxe.xml.Printer;
import nape.constraint.ConstraintList;
import nape.constraint.PivotJoint;
import nape.geom.AABB;
import nape.phys.BodyType;
import nape.phys.Material;
import openfl.display.StageDisplayState;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.utils.Object;
import ru.stablex.ui.widgets.Floating;
import ru.stablex.ui.widgets.Radio;
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
using com.org.utils.ArrayHelper;

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
    public var beamDeleteMode(default, set_beamDeleteMode) : Bool = false;
    var startBody : Body;
    var inited : Bool = false;
    
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
    public var deckSelectMode = false;

    public var camera : Camera;
    var camBody : Body;
    var prevMouse : Vec2 = new Vec2( 0, 0 );
    public var level : CmpLevel;
    
    public var editSpace : Space;
    public var builtBeams : Array<Entity> = new Array();
    public var buildHistory : BuildHistory;
    var lineChecker : LineChecker = new LineChecker();
    
    public var wcb : WControlBar;


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
        trace(level.space.bodies.length);
        
        var anchors : List<Body>= level.space.bodies.ffilter(function(b) { return b.userData.entity != null && !b.userData.entity.hasCmp(CmpSpawn); } );
        anchors.foreach(function(b) { builtBeams.push(b.userData.entity);} );
        
        buildHistory.snapAndPush(builtBeams, lineChecker.copy());
        #if flash
        baseMemory = System.totalMemoryNumber;
        #end
        wcb = cast(UIBuilder.get('controlbar'));
        if (inW == null) {
            inW = cast(UIBuilder.get('inWidth'), InputText);
            inH = cast(UIBuilder.get('inHeight'), InputText);
            inX = cast(UIBuilder.get('inX'), InputText);
            inY = cast(UIBuilder.get('inY'), InputText);
            inLevelW = cast(UIBuilder.get('levelWidth'), InputText);
            inLevelW.text = Std.string(level.width/ GameConfig.gridCellWidth) ;
            inLevelH = cast(UIBuilder.get('levelHeight'), InputText);
            inLevelH.text = Std.string(level.height/ GameConfig.gridCellWidth);
            console = cast(UIBuilder.get('console'), Text);
        }
        regEvents();
        
        material = GameConfig.nameToMat(level.materialsAllowed[0]); 
        this.camBody.inertia = 50; 

        camera = state.getSystem(SysRender).camera;
        inited = true;
    }
    
    override public function update() : Void
    {
        if (!inited) return;
        #if flash
        //cast(UIBuilder.get('mem'), Text).text = "mem: " + (("" + (System.totalMemoryNumber - baseMemory) / (1024 * 1024)).substr(0, 5)) + "Mb";
        #end
        if (isDrag) {
            dragCamera();
        } else if (isDrawing) {
            panCamera();
        }
        
        if (editMode) {
            levelWidth = Std.parseFloat(inLevelW.text) * GameConfig.gridCellWidth;
            levelHeight = Std.parseFloat(inLevelH.text)* GameConfig.gridCellWidth;
        }
        
        if (hand != null && hand.active) {
            hand.anchor1 = prevMouse;
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
            setPos();
            setBox();
        }

        prevMouse = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        
        //console.text = cmpGrid.getClosestCell(prevMouse) + '\n';
        //var res = level.space.bodiesUnderPoint(prevMouse);
        //res.foreach(ppp);

    }
    function ppp(b) 
    {
        console.text += printBodyForces(b) + '\n';
    }
    function printBodyForces(body : Body) : String
    {
        var e : Entity = body.userData.entity;
        var str = "";
        if (e != null) {
            str = 'entity id: ${e.id}\n';
        }
        str +=        "body id: " + body.id + "\n"
                       + 'body mass: ' + body.mass + ' \n'
                       + 'body gmass: ' + body.gravMass + ' \n'
                       + 'body massMode: ' + body.massMode + ' \n'
                       + 'body gmassMode: ' + body.gravMassMode + ' \n'
                       + "rotation: " + body.rotation +'\n'
                       + "total contacts: " + body.totalContactsImpulse().Vec3ToIntString() + ",\n" 
                       + "total impulse: " + body.totalImpulse().Vec3ToIntString() + "\n" 
                       + "total constraint: " + body.constraintsImpulse().Vec3ToIntString() + "\n"
                       + "total stress: " + body.calculateBeamStress().xy(true) + "\n"
                       + "total stress body space: " + body.localVectorToWorld(body.calculateBeamStress().xy(true)) + "\n"
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
        state.insertEnt(EntFactory.inst.createAnchor(Vec2.get(300, 300), { w : 300, h : 300 }, false, AnchorStartEnd.NONE));
    }
    
    public function createSpawn()
    {
        state.insertEnt(EntFactory.inst.createSpawn(SpawnType.Car, Vec2.get(300, 300), 1, 200, 30));
    }
    
    function beamDown(_) 
    {
        var mousePos = Vec2.get(stage.mouseX, stage.mouseY);
        var mp = camera.screenToWorld(mousePos);
        var cp = cmpGrid.getClosestCell(mp);
        var cFilter = GameConfig.cgAnchor | GameConfig.cgSharedJoint;
        var bb : BodyList = level.space.bodiesUnderPoint(mp, new InteractionFilter(GameConfig.cgSensor, GameConfig.cgBeam | GameConfig.cgCable | GameConfig.cgDeck) ) ;

        if (mousePos.y > 100 && mousePos.x < GameConfig.stageWidth - 100) {
            //TODO MOVE THIS
            wcb.hide();
            if (state.getSystem(SysPhysics).paused) {
                
            }
            //} else if (bb.length == 0) {
                //togglePause();
            //}
        }
        spawn1 = cmpGrid.getCellPos(cp.x, cp.y);

        if (beamDeleteMode || deckSelectMode) {
            spawn1 = mp;
            cFilter = GameConfig.cgBeam | GameConfig.cgCable | GameConfig.cgDeck;
        } 
        bb  = level.space.bodiesUnderPoint(mp, new InteractionFilter(GameConfig.cgSensor, cFilter) ) ;
        var otherBody : Body = null;
        startBody = null;
        isDrawing = true;
        /* Prefer to join to shared joint if possible */
        //var sharedJointFilter = GameConfig.cgSharedJoint;
        //if (beamDeleteMode||deckSelectMode) {
            //sharedJointFilter = ~1;
        //}
        
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
        
        if (hand != null && startBody != null && startBody.isDynamic()) {
            hand.body2 = startBody;
            hand.active = true;
            hand.anchor1 = mp;
            hand.anchor2 = startBody.worldPointToLocal(mp);
        }
        
        if (startBody == null) {
            isDrawing = false;
            isDrag = true;
        }
    }
    
    function beamUp(_)
    {
        if (hand != null) {
            hand.active = false;
            hand.body2 = null;
        }
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

        if ( (!beamDeleteMode && !deckSelectMode) && ((cp1.x == cp2.x && cp1.y == cp2.y) || startBody == null || !validLine) ) {
            return;
        }
        var cFilter = GameConfig.cgAnchor | GameConfig.cgSharedJoint;
        if (beamDeleteMode || deckSelectMode) {
            cFilter = GameConfig.cgBeam | GameConfig.cgCable | GameConfig.cgDeck;
            spawn2 = camera.screenToWorld(Vec2.weak(stage.mouseX, stage.mouseY));
        }
        
        var bb : BodyList = level.space.bodiesUnderPoint(spawn2, new InteractionFilter(GameConfig.cgSensor, cFilter, 1, 0, 1, 0) );
        var endBody : Body = null;
        var otherBody : Body = null;
        
        if (beamDeleteMode && startBody != null && state.getSystem(SysPhysics).paused) {
            var ent : Entity = startBody.userData.entity;
            var sameBody = false;
            if (ent != null && bb.has(startBody)) {
                var cmpBeam : CmpBeamBase = ent.getCmpHavingAncestor(CmpBeamBase);
                buildHistory.snapAndPush(builtBeams, lineChecker.copy());
                lineChecker.removeLine(cmpBeam.p1, cmpBeam.p2);
                builtBeams.remove(ent);
                sendMsg(Msgs.BEAMDELETE, this, { length : cmpBeam.unitLength, cost : cmpBeam.material.cost } );
                state.deleteEnt(startBody.userData.entity);
                startBody = null;
            }
            return;
        }
        if (deckSelectMode && startBody != null) {
            var ent : Entity = startBody.userData.entity;
            toggleBeamRoad(ent);
            return;
        }
        
        for (b in bb) {
            if ((b.shapes.at(0).filter.collisionGroup&GameConfig.cgSharedJoint) != 0) {
                endBody = b;
            } else {
                otherBody = b;
            }
        }
        if (startBody == otherBody) {
            return;
        }
        var genBody : { body : Body, ent : Entity } = null;
        var beamStartBody : Body = null;
        var lastBody : Body = null;
        var beamEnt : Entity = null;
        
        buildHistory.snapAndPush(builtBeams, lineChecker.copy());
        
        var sharedJoint : CmpSharedJoint = startBody.userData.sharedJoint;
        if (sharedJoint == null) {
            var e = EntFactory.inst.createSharedJoint(spawn1, [startBody]);
            sharedJoint = e.getCmp(CmpSharedJoint);
            state.insertEnt(e);
            builtBeams.push(e);
        }
        
        if (endBody == null) {
            var e = EntFactory.inst.createSharedJoint(spawn2, [otherBody]);
            state.insertEnt(e);
            builtBeams.push(e);
            endBody = e.getCmp(CmpSharedJoint).body;
        }
        var sharedJoint2 = endBody.userData.sharedJoint;

        var cmp : CmpCable = null;
        switch(material.matType) {
        case MatType.BEAM:
            genBody = genBeam(endBody, otherBody, new InteractionFilter(GameConfig.cgBeam, GameConfig.cmBeam));
            lastBody = genBody.body;
            beamStartBody = lastBody;
            beamEnt = genBody.ent;
        case MatType.CABLE:
            var cab = EntFactory.inst.createCable(spawn1, spawn2, material);
            var cmp = cab.getCmp(CmpCable);
            cab.attachCmp(cmp);
            beamEnt = cab;
            cmp.sj1 = sharedJoint;
            cmp.sj2 = sharedJoint2;
            lastBody = cmp.last;
            beamStartBody = cmp.first;
            // Swap
            var dp = spawn1.sub(lastBody.position);
            var dp2 = spawn1.sub(beamStartBody.position);
            if (dp.lsq() < dp2.lsq()) {
                var t = lastBody;
                lastBody = beamStartBody;
                beamStartBody = t;
            }
            // Make sure to insert last because sysphysics will send msg once inserted
            state.insertEnt(cab);


        default:
        }
        if (beamEnt != null) {
            builtBeams.push(beamEnt);
        }
        lineChecker.addLine(spawn1, spawn2);
        
        if (endBody.userData.sharedJoint != null) {
            endBody.userData.sharedJoint.addBody(lastBody);
        }
            
        sharedJoint.addBody(beamStartBody);
        var beam = beamEnt.getCmpsHavingAncestor(CmpBeamBase)[0];
        sendMsg(Msgs.BEAMDOWN, this, { length : beam.unitLength, cost : cast(beam.material.cost, Int) } );
        
        // Add extra bolt for foundation pillar
        if (material.matType != MatType.CABLE && sharedJoint.isAnchored) {
            var pl = Util.parametricEqn(spawn1, spawn2);
            var xx = { min : pl.b, max : pl.a + pl.b };
            var yy = { min : pl.d, max : pl.c + pl.d };
            if (Math.abs(pl.c/pl.a) < 4) {
                
            } else {
                var bbb = [xx, yy];
                var anchor = sharedJoint.getAnchor();
                var bounds = anchor.bounds;
                var boundValues = [(bounds.x - pl.b) / pl.a, (bounds.x + bounds.width - pl.b) / pl.a
                                 , (bounds.y - pl.d) / pl.c, (bounds.y + bounds.height - pl.d) / pl.c];
                if (boundValues[0] > boundValues[1]) {
                    var tmp = boundValues[0];
                    boundValues[0] = boundValues[1];
                    boundValues[1] = tmp;
                }
                if (boundValues[2] > boundValues[3]) {
                    var tmp = boundValues[2];
                    boundValues[2] = boundValues[3];
                    boundValues[3] = tmp;
                }
                var resIndex = -1;
                for (i in 0...boundValues.length) {
                    var bv = boundValues[i];
                    if (bv >= boundValues[0] && bv <= boundValues[1]
                     && bv >= boundValues[2] && bv <= boundValues[3]
                     && bv >= 0.0 && bv <= 1.0) {
                        resIndex = i;
                        break;
                    }
                }
                if (resIndex != -1) {
                    var t = boundValues[resIndex];
                    var p1 = Vec2.get(pl.a * t + pl.b, pl.c * t + pl.d);
                    var pfinal = cmpGrid.getClosestCellPos(p1);
                    var findAnchor = level.space.bodiesUnderPoint(pfinal, new InteractionFilter(GameConfig.cgSensor, GameConfig.cgAnchor));
                    var i = 0;
                    var makeFoundation = true;
                    while (!findAnchor.has(anchor)) {
                        t -= 0.14;
                        p1 = Vec2.get(pl.a * t + pl.b, pl.c * t + pl.d);
                        pfinal = cmpGrid.getClosestCellPos(p1);
                        findAnchor = level.space.bodiesUnderPoint(pfinal, new InteractionFilter(GameConfig.cgSensor, GameConfig.cgAnchor));
                        if (i++ > 1) {
                            makeFoundation = false;
                            break;
                        }
                    }
                    
                    // if we found a UNUSED spot for anchoring to surface
                    if (makeFoundation && sharedJoint.body.position.sub(pfinal).lsq() > 2) {
                        var e = EntFactory.inst.createSharedJoint(pfinal, [anchor, beamStartBody]);
                        state.insertEnt(e);
                        builtBeams.push(e);
                    }
                }
            }

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
                                    material.material, iFilter );
        body.shapes.add(beamshape);
        body.rotation = spawn2.sub(spawn1).angle;
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
    public function loadLevelFromXml(state : StateBridgeLevel)
    {
        var loadText = cast(UIBuilder.get('load'), InputText).text;
        cast(UIBuilder.get('levelEdit'), Floating).hide();
        cast(UIBuilder.get('build'), Floating).hide();
        UIBuilder.get('rootWidget').free(true);
        UIBuilder.get('build').free(true);
        UIBuilder.get('levelEdit').free(true);

        if (state == null) { state = new StateBridgeLevel(top); }
        
        var l = CmpLevel.genLevelFromString(state, loadText);
        
        top.changeState(new StateTransPan(top, cast(top.state), StateBridgeLevel.createFromLevel(state, top, l)));
    }
    
    public function generateLevelXML()
    {
        var xml = level.generateLevelXML(levelWidth, levelHeight);
        cast(UIBuilder.get('load'), InputText).text = haxe.xml.Printer.print(xml);
    }
    
    public function setPos()
    {
        var x = Std.int(Std.parseFloat(inX.text)*100) / 100.0;
        var y = Std.int(Std.parseFloat(inY.text)*100) / 100.0;
        
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
        var w = Std.int(Std.parseFloat(inW.text) * 100) / 100.0;
        var h = Std.int(Std.parseFloat(inH.text) * 100) / 100.0;
        
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
                var oldHeight = lastSelectedBody.bounds.height;
                var oldWidth = lastSelectedBody.bounds.width;
                newShape = new Polygon( Polygon.box(w, h, true)
                                      , null
                                      , new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor));

                var pos = lastSelectedBody.position;
                pos.addeq(Vec2.weak((w - oldWidth) * 0.5, (h - oldHeight) * 0.5));
                inX.text = cast(pos.x);
                inY.text = cast(pos.y);
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
        camera.dragCamera(Vec2.get(dx, dy));
    }
    
    public function restore()
    {
        for (e in builtBeams) {
            state.deleteEnt(e);
        }
        var buildstate = buildHistory.pop();
        if (buildHistory.length == 0) {
            buildHistory.snapAndPush(buildstate.ents, buildstate.lines.copy());
        }
        builtBeams = buildstate.ents;
        lineChecker = buildstate.lines;
        //var anchors = level.space.bodies.filter(function(b) { return b.shapes.at(0).filter.collisionGroup == GameConfig.cgAnchor; } );
        //anchors.foreach(function(b) { builtBeams.push(b.userData.entity);  } );
        
        var costs : Array<{length : Int, cost : Int}> = new Array();
        for (e in builtBeams) {
            state.insertEnt(e);
            var bbeam = e.getCmpHavingAncestor(CmpBeamBase);
            if (bbeam != null) { 
                costs.push( { length : bbeam.unitLength, cost : cast(bbeam.material.cost) } );
            }
        }
        sendMsg(Msgs.BEAMRECALC, this, {beams : costs});
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
        var cb = cast(UIBuilder.get('controlbar'), WControlBar);
        //cb.toggleVisible();
        if (sys.paused) {
            buildHistory.snapAndPush(builtBeams, lineChecker.copy());
            var frb = findRoadBeams();
            for (e in frb) {
                toggleBeamRoad(e);
            }
            cmpGrid.entity.getCmp(CmpRenderGrid).visible = false;
        } else {
            restore();
            cmpGrid.entity.getCmp(CmpRenderGrid).visible = true;
        }

        state.getSystem(SysLevelDirector).runExecution(sys.paused);

        sys.paused = !sys.paused;
        deckSelectMode = !sys.paused;
       
    }
    
    function toggleBeamRoad(e : Entity) : Entity
    {
        if (e == null) { return e; }
        var rends = e.getCmpsHavingAncestor(CmpRender);
        var beamz = e.getCmpsHavingAncestor(CmpBeamBase);
        var beam = beamz[0];
        if (beam.isRoad) {
            if (rends.length > 0) {
                rends[0].tintColour(59, 60, 0.79, 255);
            }
            for (sj in beam.sharedJoints) {
                if (sj.getAnchor() != null && sj.isRolling) {
                    sj.isRolling = false;
                }
            }
            beam.changeFilter(new InteractionFilter(GameConfig.cgBeam, GameConfig.cmBeam));
        } else {
            if (rends.length > 0) {
                rends[0].tintColour(200, 200, 250, 255);
            }
            for (sj in beam.sharedJoints) {
                var anc = sj.getAnchor();
                if (anc != null && cast(anc.userData.entity, Entity).getCmp(CmpAnchor).startEnd == AnchorStartEnd.START) {
                    sj.isRolling = true;
                }
            }
            beam.changeFilter(new InteractionFilter(GameConfig.cgDeck, GameConfig.cmDeck));

        }
        return e;
    }
    
    
    public function nextLevel()
    {
        var s1 = StateBridgeLevel.createLevelState(top, "levels/b" + (level.id + 1) + ".xml");
        top.changeState(new StateTransPan(top, cast(top.state), cast(s1)), true);
    }
    
    public function levelSelect()
    {
        cast(UIBuilder.get('levelEdit'), Floating).show();
        if (top != null && !top.transitioning) {
            top.changeState(new StateTransPan(top, cast(top.state), new StateLevelSelect(top)), true);
        }
    }
    
    function deleteLastSelected()
    {
        if (lastSelectedBody != null) {
            state.deleteEnt(lastSelectedBody.userData.entity);
        }
    }
    
    function findRoadBeams() : Array<Entity>
    {
        var res = new Array<Entity>();
        var space = level.space;
        var startAnchor : Body = null;
        var endAnchor : Body = null;
        var funccy = function(b:Body) {
            var e : Entity = b.userData.entity;
            if (e != null) {
                var cmpa = e.getCmp(CmpAnchor);
                if (cmpa == null) {
                    return false;
                }
                if (cmpa.startEnd == AnchorStartEnd.START) {
                    startAnchor = b;
                } else if (cmpa.startEnd == AnchorStartEnd.END) {
                    endAnchor = b;
                }
            }
            return true;
        };
        space.bodies.foreach(funccy);
        //if (endAnchor == null || startAnchor == null) {
            //space.compounds.foreach(function(c) {
                //c.bodies.foreach(funccy);
            //});
        //}
        // Bridge does not connect start and end... don't guess
        if (endAnchor == null) {
            return res;
        }
        if (startAnchor != null) {
            var a1 = startAnchor;
            var a1e : Entity = a1.userData.entity;
            var anchorBounds = a1e.getCmp(CmpAnchor).body.bounds;
            var anchorTopRight = Vec2.get(anchorBounds.x + anchorBounds.width, anchorBounds.y);
            var bod : Body = a1;
            var bodEnt : Entity = a1.userData.entity;
            var parentList : IntMap<Entity> = new IntMap();
            var markers : IntMap<Bool> = new IntMap();
            var stack : GenericStack<Body> = new GenericStack<Body>();
            stack.add(a1);
            
            while (!stack.isEmpty()) {
                var bod = stack.pop();
                var bodEnt : Entity = bod.userData.entity;
                if (!markers.exists(bodEnt.id)) {
                    markers.set(bodEnt.id, true);
                    var ca = bodEnt.getCmp(CmpAnchor);
                    if (bodEnt.id != a1.userData.entity.id && ca != null && ca.startEnd == AnchorStartEnd.END) {
                        var array = new Array<Entity>();
                        var ent = parentList.get(bodEnt.id);
                        while (ent != null) {
                            if (!ent.hasCmp(CmpAnchor)) {
                                array.push(ent);
                            }
                            ent = parentList.get(ent.id);
                        }
                        return array;
                    }
                    var cmpCable = bodEnt.getCmp(CmpCable);
                    if (cmpCable != null) {
                        if (bod == cmpCable.first) {
                            bod = cmpCable.last;
                        } else {
                            bod = cmpCable.first;
                        }
                    }
                    var cb : Array<Body> = null; // connected bodies
                    if (bodEnt.hasCmp(CmpAnchor)) {
                        cb = bodEnt.getCmp(CmpAnchor).findAdjacentBodies();
                    } else {
                        cb = bodEnt.getCmpHavingAncestor(CmpBeamBase).findAdjacentBodies();
                    }
                    var sorter = bod == a1 ? firstNode.bind(a1e) : flattestSlope;
                    cb = cb.filter(beamsOnly.bind(markers));
                    cb.sort(sorter);
                    for (i in 0...cb.length) {
                        var b = cb[i];
                        var e : Entity = b.userData.entity;
                        stack.add(b);
                        parentList.set(e.id, bodEnt);
                    }
                }
            }
        }
        return new Array<Entity>();
    }
    
    function firstNode(a1e:Entity, a:Body, b:Body) : Int
    {
        var anchorBounds = a1e.getCmp(CmpAnchor).body.bounds;
        var anchorTopRight = Vec2.get(anchorBounds.x + anchorBounds.width, anchorBounds.y);
        var abounds = a.bounds;
        var bbounds = b.bounds;
        var aclose = Math.min(Math.abs(abounds.y - anchorTopRight.y), Math.abs(abounds.y + abounds.height - anchorTopRight.y));
        var bclose = Math.min(Math.abs(bbounds.y - anchorTopRight.y), Math.abs(bbounds.y + bbounds.height - anchorTopRight.y));
        if (aclose < bclose) {
            return 1;
        } else if (aclose == bclose){
            return flattestSlope(a, b);
        } else {
            return -1;
        }
    }
    
    function flattestSlope(a:Body, b:Body) : Int
    {
        var e1 : Entity = a.userData.entity;
        var e2 : Entity = b.userData.entity;
        
        if (e1.hasCmp(CmpAnchor)) {
            return 1;
        }
        if (e2.hasCmp(CmpAnchor)) {
            return -1;
        }
        
        var b1 = e1.getCmpsHavingAncestor(CmpBeamBase)[0];
        var b2 = e2.getCmpsHavingAncestor(CmpBeamBase)[0];
        
        var sl1 = Math.abs(b1.slope);
        var sl2 = Math.abs(b2.slope);
        if (sl1 > sl2) {
            return -1;
        } else {
            return 1;
        }
        
    }
    
    function beamsOnly(markers : IntMap<Bool>, b : Body) : Bool
    {
        var e : Entity = b.userData.entity;
        var tooSteep = false;
        var beamz = e.getCmpsHavingAncestor(CmpBeamBase);
        if (beamz.length != 0 && Math.abs(beamz[0].slope) > 1.5) {
            tooSteep = true;
        }
        return e != null && !e.hasCmp(CmpSharedJoint) && !markers.exists(e.id) && !tooSteep;
    }
    
    
    
    function set_editMode(m : Bool) : Bool
    {
        this.editMode = m;
        if (m) {
            cast(UIBuilder.get('levelEdit'), Floating).show();
        } else {
            cast(UIBuilder.get('levelEdit'), Floating).hide();
        }
        camera.isUnlocked = editMode;
        if (m) {
            unregEvents();
            stage.addEventListener(MouseEvent.MOUSE_DOWN, dragBox);
            stage.addEventListener(MouseEvent.MOUSE_UP, unDragBox);
            stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, expandBox);
            stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, unExpandBox);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
            
            cmpGrid.offset = Vec2.get(0, (GameConfig.gridCellWidth-GameConfig.matSteel.height)*0.5);
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
        isDrag = false;
        selectBody();
        if (selectedBody != null) {
            isDraggingBox = true;
        } else {
            isDrag = true;
        }
    }
    
    function unDragBox(_)
    {
        isDraggingBox = false;
        isDrag = false;
        
    }
    
    function expandBox(_)
    {
        var bbs = level.space.bodiesUnderPoint(prevMouse, new InteractionFilter(GameConfig.cgSensor, GameConfig.cgSharedJoint));
        if (bbs.length > 0) {
            var ent : Entity = bbs.at(0).userData.entity;
            if (ent != null) {
                ent.getCmp(CmpSharedJoint).isRolling = true;
            }
        }
        //selectBody();
        //if (selectedBody != null) {
            //isExpandingBox = true;
        //}
    }
    
    function unExpandBox(_)
    {
        isExpandingBox = false;
    }
    
    function set_beamDeleteMode(b : Bool) : Bool
    {
        beamDeleteMode = b;
        if (b) {
            wcb.setMaterial(MaterialNames.NULL);
        }
        return b;
    }
    
    function set_material(m : BuildMat) : BuildMat
    {
        beamDeleteMode = false;
        material = m;
        var enumName = m.ename;
        if (wcb != null) wcb.setMaterial(enumName);
        return m;
    }
    
    
    var hand:PivotJoint;
    
    function keyDown(ev:KeyboardEvent) 
    {
        if (hand == null) {
            hand = new PivotJoint(level.space.world, null, Vec2.weak(), Vec2.weak());
            hand.active = false;
            hand.stiff = false;
            hand.maxForce = 1e6;
            hand.space = level.space;
        }
        if (ev.keyCode == Keyboard.SPACE ) {
            togglePause();
        } else if (ev.keyCode == Keyboard.PAGE_UP) {
            camera.zoom += 0.1;
        } else if (ev.keyCode == Keyboard.PAGE_DOWN) {
            camera.zoom -= 0.1;
        } else if (ev.keyCode == Keyboard.F) {
            //if (stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE) {
                //stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
                //trace(stage.displayState);
            //} else {
                //stage.displayState = StageDisplayState.NORMAL;
            //}
            //GameConfig.resize(stage.stageWidth, stage.stageHeight);
            //state.getSystem(SysRender).resize(stage.stageWidth, stage.stageHeight);
        }
        if (ev.keyCode == Keyboard.L) {
            state.getSystem(SysRender).drawDebug = !state.getSystem(SysRender).drawDebug;
        }
        
        if (lastSelectedBody == null) return;
        
        var w = Std.parseFloat(inW.text);
        var h = Std.parseFloat(inH.text);
        var x = Std.parseFloat(inX.text);
        var y = Std.parseFloat(inY.text);
        var rate = 1.0;
        if (!ev.shiftKey) {
            rate = 7.0;
        }

        if (ev.keyCode == Keyboard.Q) {
            inW.text = cast(w-rate);
        } else if (ev.keyCode == Keyboard.W) {
            inW.text = cast(w+rate);
        } else if (ev.keyCode == Keyboard.A) {
            inH.text = cast(h-rate);
        } else if (ev.keyCode == Keyboard.S) {
            inH.text = cast(h+rate);
        }
        
        if (ev.keyCode == Keyboard.UP) {
            inY.text = cast(y-rate);
        } else if (ev.keyCode == Keyboard.DOWN) {
            inY.text = cast(y+rate);
        } else if (ev.keyCode == Keyboard.LEFT) {
            inX.text = cast(x-rate);
        } else if (ev.keyCode == Keyboard.RIGHT) {
            inX.text = cast(x+rate);
        }
        
        setPos();        
        setBox();
    }
}
