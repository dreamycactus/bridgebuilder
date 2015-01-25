package com.org.bbb.control ;
import com.org.bbb.level.CmpGrid;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.level.CmpSpawn;
import com.org.bbb.physics.BuildMat;
import com.org.bbb.physics.BuildMat.MatType;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpAnchor.AnchorStartEnd;
import com.org.bbb.physics.CmpBeamBase;
import com.org.bbb.physics.CmpCable;
import com.org.bbb.physics.CmpSharedJoint;
import com.org.bbb.render.Camera;
import com.org.bbb.render.CmpRender;
import com.org.bbb.systems.SysPhysics;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.Top;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.shape.Polygon;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.Lib;

/**
 * ...
 * @author ...
 */

using com.org.utils.ArrayHelper;
 
class CmpBridgeBuild extends Cmp
{
    public var material(default, set_material) : BuildMat;

    // External top level objects
    public var stage : Stage;
    public var top : Top;
    public var state : MESState;
    
    public var level : CmpLevel;
    public var camera : Camera;
    public var cmpGrid : CmpGrid;

    // Draw state
    public var builtBeams : Array<Entity> = new Array();
    public var buildHistory : BuildHistory;
    public var lineChecker : LineChecker = new LineChecker();
    
    public var spawn1 : Vec2;
    public var spawn2 : Vec2;
    var startBody : Body;
    
    public var isDrawing : Bool;
    public var beamDeleteMode(default, set) = false;
    public var deckSelectMode = false;
    var prevMouse : Vec2 = new Vec2( 0, 0 );
    
    public var levelWidth : Float;
    public var levelHeight : Float;
    var inited : Bool = false;

    public function new(top : Top, state : MESState, level : CmpLevel, camera : Camera, cmpGrid : CmpGrid) 
    {
        super();
        this.top = top;
        this.stage = Lib.current.stage;
        this.state = state;
        this.camera = camera;
        this.cmpGrid = cmpGrid;
        this.level = level;
        
        init();
    }
    
    public function init()
    {
        buildHistory = new BuildHistory(state);
        saveState();
        
        // TODO remove anchor from history
        var anchors : List<Body>= level.space.bodies.ffilter(function(b) { return b.userData.entity != null && !b.userData.entity.hasCmp(CmpSpawn); } );
        anchors.foreach(function(b) { builtBeams.push(b.userData.entity);} );
        
        saveState();
    }
    
    public function beamDown() 
    {
        var mousePos = Vec2.get(stage.mouseX, stage.mouseY);
        var mp = camera.screenToWorld(mousePos);
        var cp = cmpGrid.getClosestCell(mp);
        var cFilter = GameConfig.cgAnchor | GameConfig.cgSharedJoint;
        var bb : BodyList = level.space.bodiesUnderPoint(mp, new InteractionFilter(GameConfig.cgSensor, GameConfig.cgBeam | GameConfig.cgCable | GameConfig.cgDeck) ) ;

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
            if (b.shapes.at(0).filter.collisionGroup&GameConfig.cgSharedJoint != 0) {
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
        }
    }
    
    public function beamUp()
    {
        isDrawing = false;
        
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
                saveState();
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
        
        saveState();
        
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
    
    public function toggleBeamRoad(e : Entity) : Entity
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
    
    public function restore()
    {
        for (e in builtBeams) {
            state.deleteEnt(e);
        }
        var buildstate = buildHistory.pop();
        if (buildHistory.length == 0) {
            saveState();
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
            restore();
        }
    }
    
    public function saveState()
    {
        buildHistory.snapAndPush(builtBeams, lineChecker.copy());
    }
    
    function set_material(m : BuildMat) : BuildMat
    {
        beamDeleteMode = false;
        material = m;
        var enumName = m.ename;
        //if (wcb != null) wcb.setMaterial(enumName);
        return m;
    }
    function set_beamDeleteMode(b : Bool) : Bool
    {
        beamDeleteMode = b;
        return b;
    }
}