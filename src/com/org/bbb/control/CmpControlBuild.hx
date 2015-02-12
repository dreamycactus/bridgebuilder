package com.org.bbb.control ;
import com.org.bbb.level.LevelSerializer;
import com.org.bbb.level.CmpGrid;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.physics.BuildMat;
import com.org.bbb.physics.BuildMat.MatType;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpAnchor.AnchorStartEnd;
import com.org.bbb.level.CmpSpawn.SpawnType;
import com.org.bbb.GameConfig.MaterialNames;
import com.org.bbb.physics.CmpBeamBase;
import com.org.bbb.physics.CmpCable;
import com.org.bbb.physics.CmpSharedJoint;
import com.org.bbb.render.Camera;
import com.org.bbb.render.CmpRender;
import com.org.bbb.render.CmpRenderGrid;
import com.org.bbb.states.StateBridgeLevel;
import com.org.bbb.states.StateLevelSelect;
import com.org.bbb.states.StateTransPan;
import com.org.bbb.systems.SysLevelDirector;
import com.org.bbb.systems.SysPhysics;
import com.org.bbb.systems.SysRender;
import com.org.bbb.widgets.WControlBar;
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
    var stage : Stage;
    var top : Top;
    var state : MESState;
    
    public var level : CmpLevel;
    public var camera : Camera;
    var cmpGrid : CmpGrid;
    
    var inited : Bool = false;
    var builder : CmpBridgeBuild;
    var material(get, set) : BuildMat;
    var prevMouse : Vec2;
    public var wcb : WControlBar;


    public function new(bridgebuilder : CmpBridgeBuild) 
    {
        super();
        
        this.builder = bridgebuilder;
        
        this.stage = builder.stage;
        this.top = builder.top;
        this.state = builder.state;
        this.level = builder.level;
        this.camera = builder.camera;
        this.cmpGrid = builder.cmpGrid;
    }
    
    override public function init()
    {
        wcb = cast(UIBuilder.get('controlbar'));

        regEvents();
        
        material = level.materialsAllowed.length > 0 ?
            GameConfig.nameToMat(level.materialsAllowed[0]) :
            GameConfig.matSteel;

        camera = state.getSystem(SysRender).camera;
        inited = true;
    }
    
    override public function update() : Void
    {
        if (!inited) return;
        #if flash
        //cast(UIBuilder.get('mem'), Text).text = "mem: " + (("" + (System.totalMemoryNumber - baseMemory) / (1024 * 1024)).substr(0, 5)) + "Mb";
        #end
        //if (isDrag) {
            //dragCamera();
        //} else if (isDrawing) {
            //panCamera();
        //}
        
        
        //if (editMode) {
            //if (selectedBody != null) {
                //var dirty = false;
                //if (isDraggingBox) {
                    //var v = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
                    //selectedBody.type = BodyType.DYNAMIC;
                    //selectedBody.position.addeq(v.sub(prevMouse, true));
                    //selectedBody.type = BodyType.STATIC;
                    //inX.text = cast(selectedBody.position.x);
                    //inY.text = cast(selectedBody.position.y);
                    //dirty = true;
                //} else if (isExpandingBox) {
                    //if (isSpawn) {
                        //selectedBody.type = BodyType.DYNAMIC;
                        //if (prevMouse.x > selectedBody.position.x) {
                            //selectedBody.rotation = 0;
                        //} else {
                            //selectedBody.rotation = Math.PI;
                        //}
                        //selectedBody.type = BodyType.STATIC;
                    //} else {
                        //var dp = Vec2.get(stage.mouseX, stage.mouseY).sub(prevMouse);
                        //var dx = Util.clampf(1+dp.x*0.005, 0.7, 1.3);
                        //var dy = Util.clampf(1-dp.y*0.005, 0.7, 1.3);
                        //selectedBody.type = BodyType.DYNAMIC;
                        //selectedBody.scaleShapes(dx, dy);
                        //selectedBody.type = BodyType.STATIC;
                        //inW.text = cast(selectedBody.bounds.width);
                        //inH.text = cast(selectedBody.bounds.height);
                        //dirty = true;
                    //}
                    //
                //}
            //}
            //setPos();
            //setBox();
        //}

        prevMouse = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        
        //console.text = cmpGrid.getClosestCell(prevMouse) + '\n';
        //var res = level.space.bodiesUnderPoint(prevMouse);
        //res.foreach(ppp);

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
        stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    }
    
    function unregEvents()
    {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    }
    
    function mouseDown(e) : Void
    {
        builder.beamDown();
    } 
    function mouseUp(e) : Void
    {
        builder.beamUp();
    }
    
    override public function deinit()
    {
        unregEvents();
    }
    
    //public function createBox()
    //{
        //state.insertEnt(EntFactory.inst.createAnchor(Vec2.get(300, 300), { w : 300, h : 300 }, false, AnchorStartEnd.NONE));
    //}
    //
    //public function createSpawn()
    //{
        //state.insertEnt(EntFactory.inst.createSpawn(SpawnType.Car, Vec2.get(300, 300), 1, 200, 30));
    //}
    //
    //
    //function selectBody()
    //{
        //var mousePos = camera.screenToWorld(Vec2.get(stage.mouseX, stage.mouseY));
        //var results = level.space.bodiesUnderPoint(mousePos, new InteractionFilter(GameConfig.cgSensor, (GameConfig.cmAnchor|GameConfig.cmEditable)));
        //
        //if (results.length == 0) {
            //selectedBody = null;
            //return;
        //}
        //selectedBody = results.at(0);
        //lastSelectedBody = selectedBody;
//
        //if (selectedBody.shapes.at(0).filter.collisionGroup == GameConfig.cgSpawn) {
            //isSpawn = true;
        //} else {
            //isSpawn = false;
        //}
        //
    //}
    public function loadLevelFromXml(state : StateBridgeLevel)
    {
        var loadText = cast(UIBuilder.get('load'), InputText).text;
        UIBuilder.get('rootWidget').free(true);
        UIBuilder.get('build').free(true);
        UIBuilder.get('levelEdit').free(true);

        if (state == null) { state = new StateBridgeLevel(top); }
        var levelserializer = new LevelSerializer(state);
        var l = levelserializer.loadLevelXml(loadText);
        
        top.changeState(new StateTransPan(top, cast(top.state), StateBridgeLevel.createFromLevel(state, top, l)));
    }
    
    //public function generateLevelXML()
    //{
        //var xml = level.generateLevelXML(levelWidth, levelHeight);
        //cast(UIBuilder.get('load'), InputText).text = haxe.xml.Printer.print(xml);
    //}
    //
    //public function setPos()
    //{
        //var x = Std.int(Std.parseFloat(inX.text)*100) / 100.0;
        //var y = Std.int(Std.parseFloat(inY.text)*100) / 100.0;
        //
        //if (Math.isNaN(x)) {
            //x = -10000;
        //}
        //if (Math.isNaN(y)) {
            //y = -10000;
        //}
        //
        //if (lastSelectedBody != null && !Math.isNaN(x) && !Math.isNaN(y)) {
            //lastSelectedBody.type = BodyType.DYNAMIC;
            //lastSelectedBody.position.setxy(x, y);
            //lastSelectedBody.type = BodyType.STATIC;
        //}
    //}
    //
    //public function setBox()
    //{
        //var w = Std.int(Std.parseFloat(inW.text) * 100) / 100.0;
        //var h = Std.int(Std.parseFloat(inH.text) * 100) / 100.0;
        //
        //if (Math.isNaN(w) || w < 1) {
            //w = 1;
        //}
        //if (Math.isNaN(h) || h < 1) {
            //h = 1;
        //}
        //
        //if (lastSelectedBody != null && !Math.isNaN(w) && !Math.isNaN(h)) {
            //lastSelectedBody.type = BodyType.DYNAMIC;
            //var newShape = null;
            //if (!isSpawn) {
                //var oldHeight = lastSelectedBody.bounds.height;
                //var oldWidth = lastSelectedBody.bounds.width;
                //newShape = new Polygon( Polygon.box(w, h, true)
                                      //, null
                                      //, new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor));
//
                //var pos = lastSelectedBody.position;
                //pos.addeq(Vec2.weak((w - oldWidth) * 0.5, (h - oldHeight) * 0.5));
                //inX.text = cast(pos.x);
                //inY.text = cast(pos.y);
            //} else {
                //newShape = cast(lastSelectedBody.shapes.at(0).copy());
            //}
            //lastSelectedBody.shapes.pop();
            //lastSelectedBody.shapes.push(newShape);
            //lastSelectedBody.type = BodyType.STATIC;
        //}
    //}
    
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
    
    public function togglePause()
    {
        var sys = state.getSystem(SysPhysics);
        var cb = cast(UIBuilder.get('controlbar'), WControlBar);
        cb.toggleVisible();
        if (sys.paused) {
            builder.saveState();
            var frb = findRoadBeams();
            for (e in frb) {
                toggleBeamRoad(e);
            }
            cmpGrid.entity.getCmp(CmpRenderGrid).visible = false;
        } else {
            builder.restore();
            cmpGrid.entity.getCmp(CmpRenderGrid).visible = true;
        }

        state.getSystem(SysLevelDirector).runExecution(sys.paused);

        sys.paused = !sys.paused;
        builder.deckSelectMode = !sys.paused;
       
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
        if (top != null && !top.transitioning) {
            top.changeState(new StateTransPan(top, cast(top.state), new StateLevelSelect(top)), true);
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
    
    
    
    //function set_editMode(m : Bool) : Bool
    //{
        //this.editMode = m;
        //if (m) {
            //cast(UIBuilder.get('levelEdit'), Floating).show();
        //} else {
            //cast(UIBuilder.get('levelEdit'), Floating).hide();
        //}
        //camera.isUnlocked = editMode;
        //if (m) {
            //unregEvents();
            //stage.addEventListener(MouseEvent.MOUSE_DOWN, dragBox);
            //stage.addEventListener(MouseEvent.MOUSE_UP, unDragBox);
            //stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, expandBox);
            //stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, unExpandBox);
            //stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
            //
            //cmpGrid.offset = Vec2.get(0, (GameConfig.gridCellWidth-GameConfig.matSteel.height)*0.5);
        //} else {
            //regEvents();
            //stage.removeEventListener(MouseEvent.MOUSE_DOWN, dragBox);
            //stage.removeEventListener(MouseEvent.MOUSE_UP, unDragBox);
            //stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, expandBox);
            //stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, unExpandBox);
            //cmpGrid.offset = Vec2.get();
        //}
        //return m;
    //}
    
    
    //function dragBox(_)
    //{
        //isDrag = false;
        //selectBody();
        //if (selectedBody != null) {
            //isDraggingBox = true;
        //} else {
            //isDrag = true;
        //}
    //}
    //
    //function unDragBox(_)
    //{
        //isDraggingBox = false;
        //isDrag = false;
        //
    //}
    //
    //function expandBox(_)
    //{
        //var bbs = level.space.bodiesUnderPoint(prevMouse, new InteractionFilter(GameConfig.cgSensor, GameConfig.cgSharedJoint));
        //if (bbs.length > 0) {
            //var ent : Entity = bbs.at(0).userData.entity;
            //if (ent != null) {
                //ent.getCmp(CmpSharedJoint).isRolling = true;
            //}
        //}
        ////selectBody();
        ////if (selectedBody != null) {
            ////isExpandingBox = true;
        ////}
    //}
    //
    //function unExpandBox(_)
    //{
        //isExpandingBox = false;
    //}
    //
    //function set_beamDeleteMode(b : Bool) : Bool
    //{
        //beamDeleteMode = b;
        //if (b) {
            //wcb.setMaterial(MaterialNames.NULL);
        //}
        //return b;
    //}
    
    
    function keyDown(ev:KeyboardEvent) 
    {
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
        
        //if (lastSelectedBody == null) return;
        
        //var w = Std.parseFloat(inW.text);
        //var h = Std.parseFloat(inH.text);
        //var x = Std.parseFloat(inX.text);
        //var y = Std.parseFloat(inY.text);
        //var rate = 1.0;
        //if (!ev.shiftKey) {
            //rate = 7.0;
        //}
//
        //if (ev.keyCode == Keyboard.Q) {
            //inW.text = cast(w-rate);
        //} else if (ev.keyCode == Keyboard.W) {
            //inW.text = cast(w+rate);
        //} else if (ev.keyCode == Keyboard.A) {
            //inH.text = cast(h-rate);
        //} else if (ev.keyCode == Keyboard.S) {
            //inH.text = cast(h+rate);
        //}
        //
        //if (ev.keyCode == Keyboard.UP) {
            //inY.text = cast(y-rate);
        //} else if (ev.keyCode == Keyboard.DOWN) {
            //inY.text = cast(y+rate);
        //} else if (ev.keyCode == Keyboard.LEFT) {
            //inX.text = cast(x-rate);
        //} else if (ev.keyCode == Keyboard.RIGHT) {
            //inX.text = cast(x+rate);
        //}
        //
        //setPos();        
        //setBox();
    }
    
    function get_material() : BuildMat
    {
        return builder.material;
    }
    
    function set_material(m: BuildMat) : BuildMat
    {
        builder.material = m;
        return m;
    }
}
