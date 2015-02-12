package com.org.bbb;
import com.org.bbb.control.CmpControlCar;
import com.org.bbb.control.CmpControlCarPlayer;
import com.org.bbb.level.CmpGrid;
import com.org.bbb.level.CmpSpawn;
import com.org.bbb.physics.BuildMat;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.physics.CmpAnchor.AnchorStartEnd;
import com.org.bbb.physics.CmpBeam;
import com.org.bbb.physics.CmpCable;
import com.org.bbb.physics.CmpMoverCar;
import com.org.bbb.physics.CmpMoverTrainCar;
import com.org.bbb.physics.CmpMoverTruckRigid;
import com.org.bbb.physics.CmpMoverTruckTractor;
import com.org.bbb.physics.CmpMoverTruckTrailer;
import com.org.bbb.physics.CmpMultiBeam;
import com.org.bbb.physics.CmpMultiBeam.SplitType;
import com.org.bbb.physics.CmpSharedJoint;
import com.org.bbb.physics.CmpTerrain;
import com.org.bbb.physics.CmpTransform;
import com.org.bbb.render.CmpRenderAnchor;
import com.org.bbb.render.CmpRenderCable;
import com.org.bbb.render.CmpRenderCar;
import com.org.bbb.render.CmpRenderGrid;
import com.org.bbb.render.CmpRenderMultiBeam;
import com.org.bbb.render.CmpRenderMultiBeam.BodyBitmap;
import com.org.bbb.level.CmpSpawn.SpawnType;
import com.org.bbb.GameConfig.JointType;
import com.org.bbb.render.CmpRenderSharedJoint;
import com.org.bbb.render.CmpRenderSprite;
import com.org.bbb.render.CmpRenderTerrain;
import com.org.bbb.render.CmpRenderTrainCar;
import com.org.bbb.render.CmpRenderTrainLocomotive;
import com.org.bbb.render.CmpRenderTruckRigid;
import com.org.bbb.render.CmpRenderTruckTractor;
import com.org.bbb.render.CmpRenderTruckTrailer;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.Top;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.Lib;
import com.org.bbb.physics.CmpMoverTrainEngine;

/**
 * ...
 * @author 
 */

enum TruckType {
    RIGID;
    TRACTOR_ONLY;
    HEAVY_COMBINATION;
}

class EntFactory
{
    public static var inst(get_inst, null) : EntFactory; // Forgive me..
    static var instance : EntFactory;
    public var top : Top;
    public var state : MESState;
    
    public function new(top : Top, state : MESState) 
    {
        if (instance != null) {
            throw "Only one...... QQ";
        }
        inst = this;
        this.top = top;
        this.state = state;
    }
    
    public static function get_inst() 
    {
        if (instance == null) {
            instance = new EntFactory(null, null);
        }
        return inst;
    }
    
    public function createBeamEnt(p1 : Vec2, p2 : Vec2, pos : Vec2, body : Body, width : Float, material : BuildMat, name : String = "") : Entity
    {
        var e = state.createEnt("be");
        var trans = new CmpTransform();
        e.attachCmp(trans);
        var cmpbeam = new CmpBeam(trans, p1, p2, body, width, material);
        
        //var length = body.shapes.at(0).bounds.width;
        var assetPath : String = "";
        var offset = Vec2.get();
        switch(material.name) {
            case "Steel":
                assetPath = "img/beam.png";
            case "Wood":
                assetPath = "img/wood.png";            
            case "Concrete":
                assetPath = "img/concrete.png";
            case "deck":
                assetPath = "img/deck.png";
                offset.y = -20;
            default:
                assetPath = "img/beam.png";
        }
        var bbit = GfxFactory.inst.createBeamBitmap(assetPath, width);
        var cmprend = new CmpRenderMultiBeam([ { bitmap : bbit, body : body } ], offset);
        cmprend.tintColour(86, 86, 115, 255);
        if (pos != null) {
            body.position = pos;
        }
        body.userData.entity = e;
        body.userData.width = width;
        body.userData.height = material.height;
        body.userData.matType = material.matType;
        body.cbTypes.add(GameConfig.cbOneWay);
        
        if (body.rotation > Math.PI/2 && body.rotation < Math.PI*1.5) {
            body.rotation += Math.PI;
        } else if (body.rotation < -Math.PI/2 && body.rotation > -Math.PI*1.5) {
            body.rotation -= Math.PI;
        }
        
        e.attachCmp(cmpbeam);
        e.attachCmp(cmprend);
        
        return e;
    }    
    
    public function createTerrain(terrainsrc : String, space : Space, offset : Vec2)
    {
        var terrain = state.createEnt("terrain");
        var bd = Assets.getBitmapData(terrainsrc);
        var ct = new CmpTerrain(terrainsrc, space, offset);
        
        terrain.attachCmp(ct);
        terrain.attachCmp(new CmpRenderTerrain(ct));
        
        return terrain;
    }
    
    public function createCable(p1 : Vec2, p2 : Vec2, material : BuildMat) : Entity
    {
        var cab = state.createEnt("cc");
        var trans = new CmpTransform();
        var cmp = new CmpCable(trans, p1, p2, material);
        var bitmap = new Bitmap(Assets.getBitmapData('img/cable.png'));
        var rcmp = new CmpRenderCable(cmp, bitmap);
        cab.attachCmp(trans);
        cab.attachCmp(cmp);
        cab.attachCmp(rcmp);
        return cab;
    }
    
    public function createMultiBeamEnt(pos : Vec2, entity : Entity, splitType : SplitType, name : String = "") : Entity
    {
        var e = state.createEnt(name);
        var oldCmpBeam = entity.getCmp(CmpBeam);
        var cmpbeam = CmpMultiBeam.createFromBeam(oldCmpBeam.transform, oldCmpBeam, splitType, null);
        if (cmpbeam == null) return null;
        var pairs : Array<BodyBitmap> = new Array();
        
        var oldrender = entity.getCmp(CmpRenderMultiBeam);
        var cmprender = new CmpRenderMultiBeam(
            GfxFactory.inst.breakBeamBitmap(cmpbeam.compound
                                          , oldrender.pairs[0].bitmap), oldrender.offset);
        cmprender.tintColour(86, 86, 115, 255);
        e.attachCmp(cmpbeam);
        e.attachCmp(cmprender);
        
        return e;
    }
    
    public function createSharedJoint(pos : Vec2, bodies : Array<Body>=null, name : String = "") : Entity
    {
        var e = state.createEnt("sj");
        var trans = new CmpTransform();
        e.attachCmp(trans);
        var sj = new CmpSharedJoint(trans, pos, bodies);
        var rsj = new CmpRenderSharedJoint(sj);
        rsj.tintColour(84, 84, 115, 255);
        
        e.attachCmp(sj);
        e.attachCmp(rsj);
        
        return e;
    }
    
    public function createDoubleJoint(pos1 : Vec2, pos2 : Vec2, body1 : Body, body2 : Body,
                                      compound : Compound, name : String = "") : Entity
    {
        var e = state.createEnt(name);
        var joint : PivotJoint = GameConfig.pivotJoint(JointType.MULTISTIFF);
        joint.body1 = body1;
        joint.body2 = body2;
        joint.anchor1 = body1.worldPointToLocal(pos1);
        joint.anchor2 = body2.worldPointToLocal(pos1);
        joint.compound = compound;
        
        var joint2 : PivotJoint = GameConfig.pivotJoint(JointType.MULTIELASTIC);
        joint2.body1 = body1;
        joint2.body2 = body2;
        joint2.anchor1 = body1.worldPointToLocal(pos2);
        joint2.anchor2 = body2.worldPointToLocal(pos2);
        joint2.compound = compound;
        
        var trans = new CmpTransform();
        e.attachCmp(trans);
        
        var cmpbeam = new CmpMultiBeam(trans, pos1, pos2, compound);
        
        e.attachCmp(cmpbeam);
        
        return e;
    }
    
    public function createGridEnt(w : Float, h : Float, cellsz : Int, cellCount : Array<Int>) : Entity
    {
        var e = state.createEnt("grid");
        var cmpGrid = new CmpGrid(w, h, cellsz, cellCount);
        var cmpRenderGrid = new CmpRenderGrid(cmpGrid);
        
        e.attachCmp(cmpGrid);
        e.attachCmp(cmpRenderGrid);
        
        return e;
    }
    
    public function createCar(pos :Vec2, dir : Int, playerControlled : Bool = false) : Entity
    {
        var e = state.createEnt();
        var trans = new CmpTransform();
        e.attachCmp(trans);
        var cm = new CmpMoverCar(trans, pos);
        cm.set_entity(e);
        if (!playerControlled) {
            var cc = new CmpControlCar(cm);
            cc.speed = GameConfig.carSpeed * dir;
            e.attachCmp(cc);
        }   
        else {
            var cc = new CmpControlCarPlayer(Lib.current.stage, cm);
            e.attachCmp(cc);
        }
        var cr = new CmpRenderCar(cm);
        
        e.attachCmp(cm);
        e.attachCmp(cr);
        
        return e;
    }

    public function createTruck(pos : Vec2, dir : Int, type : TruckType) : Array<Entity>
    {
        var truck = new Array<Entity>();
        switch(type) {
            case TRACTOR_ONLY:
                var e = state.createEnt();
                var trans = new CmpTransform();
                var tractor = new CmpMoverTruckTractor(trans, pos);
                var render = new CmpRenderTruckTractor(tractor);
                e.attachCmp(trans);
                e.attachCmp(tractor);
                e.attachCmp(render);
                truck.push(e);
            case HEAVY_COMBINATION:
                var e1 = state.createEnt();
                var trans1 = new CmpTransform();
                var tractor = new CmpMoverTruckTractor(trans1, pos);
                var render = new CmpRenderTruckTractor(tractor);
                e1.attachCmp(trans1);
                e1.attachCmp(tractor);
                e1.attachCmp(render);
                var e2 = state.createEnt();
                var trans2 = new CmpTransform();
                var trailer = new CmpMoverTruckTrailer(trans2, pos.add(Vec2.weak(-GameConfig.truckTractorCabDim.w*0.5-10, 0 )));
                var renderTrailer = new CmpRenderTruckTrailer(trailer);
                e2.attachCmp(trans2);
                e2.attachCmp(trailer);
                e2.attachCmp(renderTrailer);
                tractor.addTrailer(trailer);
                truck.push(e1);
                truck.push(e2);
            case RIGID:
                var e = state.createEnt();
                var trans = new CmpTransform();
                var mover = new CmpMoverTruckRigid(trans, pos);
                var render = new CmpRenderTruckRigid(mover);
                e.attachCmp(trans);
                e.attachCmp(mover);
                e.attachCmp(render);
                truck.push(e);
        }
        return truck;
    }
    
    //public function createTrain(pos :Vec2, dir : Int, count : Int) : Array<Entity>
    //{
        //var ents = new Array<Entity>();
        //var e = state.createEnt();
        //var cm = new CmpMoverTrainEngine(pos);
        //var ren = new CmpRenderTrainLocomotive(cm);
        //var cm2 = new CmpMoverTrainCar(pos.add(Vec2.weak(-(GameConfig.trainCarDim.w+GameConfig.trainMargin*2), 0)));
        //var ren2 = new CmpRenderTrainCar(cm2); // WEIRD
        //cm.addCar(cm2);
        //ents.push(e);
        //
        //var prev : CmpMoverTrainCar = cm2;
        //for (i in 0...count) {
            //var cmt = new CmpMoverTrainCar(pos.add(Vec2.weak(-(GameConfig.trainCarDim.w+GameConfig.trainMargin*2 )* i, 0)));
            //var rtc = new CmpRenderTrainCar(cmt);
            //var ee = state.createEnt();
            //ee.attachCmp(cmt);
            //ee.attachCmp(rtc);
            //prev.addCar(cmt);
            //prev = cmt;
            //ents.push(ee);
        //}
//
        //e.attachCmp(cm);
        //e.attachCmp(cm2);
        //e.attachCmp(ren);
        //e.attachCmp(ren2);
        //
        //return ents;
    //}
    
    public function createSpawn(spawnType : SpawnType, pos : Vec2, dir : Int, period : Float, count : Int) : Entity
    {
        var spawnIcon = new Body(BodyType.KINEMATIC, pos);
        spawnIcon.shapes.add(new Polygon(Polygon.regular(20, 20, 3, 0.0), null, new InteractionFilter(GameConfig.cgSpawn, GameConfig.cmEditable)));
        if (dir == -1) {
            spawnIcon.rotation = Math.PI;
        }
        var spawn = state.createEnt();
        var trans = new CmpTransform();
        spawn.attachCmp(trans);
        var cmpSpawn = new CmpSpawn(trans, spawnType, pos, dir, spawnIcon, count, period);

        spawn.attachCmp(cmpSpawn);
        spawnIcon.userData.entity = spawn;
        
        return spawn;
    }
    
    public function createAnchor(pos : Vec2, tdim : {w : Float, h : Float}, fluid : Bool, ase : AnchorStartEnd, taperEnd : Bool=false) : Entity
    {
        var gridMultiple = Util.roundNearest(Std.int(pos.y - tdim.h * 0.5), GameConfig.gridCellWidth);
        
        pos.y = gridMultiple + tdim.h * 0.5 +(GameConfig.gridCellWidth - GameConfig.matSteel.height) * 0.5;
        //pos.addeq(Vec2.get(0, -(GameConfig.gridCellWidth - GameConfig.matDeck.height) * 0.5));

        var anc = new Body(BodyType.STATIC);
        var filter = null;
        if (fluid) {
            filter = new InteractionFilter(GameConfig.cgNull, 0, GameConfig.cgNull, 0, GameConfig.cgAnchor, -1);
        } else {
            filter = new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor);
        }
        var box = new Polygon(Polygon.box(tdim.w, tdim.h), GameConfig.matSteel.material, filter);
        if (fluid) {
            box.fluidEnabled = fluid;
            box.fluidProperties.viscosity = 7;
            box.fluidProperties.density = 1;
        }
        
        if (ase == AnchorStartEnd.END || taperEnd) {
            var localVerts = box.localVerts;
            var tv = localVerts.at(0).copy();
            tv.y += 10;
            localVerts.at(0).x += 10;
            box.localVerts.unshift(tv);
        }

        anc.shapes.add(box);
        
        anc.position = pos;
        var ent = state.createEnt();
        var trans = new CmpTransform();
        var cmpanc = new CmpAnchor(trans, anc, ase);
        cmpanc.fluid = fluid;
        var cmprender = new CmpRenderAnchor(cmpanc);
        cmprender.tintColour(212, 23, 80, 255);
        
        var temp = new CmpRenderSprite();
        
        ent.attachCmp(trans);
        ent.attachCmp(cmpanc);
        ent.attachCmp(cmprender);
        ent.attachCmp(temp);
        
        anc.userData.entity = ent;
        return ent;
    }
    
    
}
