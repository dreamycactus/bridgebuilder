package com.org.bbb;
import com.org.bbb.CmpAnchor.AnchorStartEnd;
import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.CmpRenderMultiBeam.BodyBitmap;
import com.org.bbb.CmpSpawn.SpawnType;
import com.org.bbb.GameConfig.JointType;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.Top;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.phys.Material;
import nape.shape.Polygon;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.Lib;
import com.org.bbb.CmpMoverTrainEngine;

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
        var cmpbeam = new CmpBeam(p1, p2, body, width, material);
        var cmptrans = new CmpTransform(pos);
        
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
        
        if (body.rotation > Math.PI/2 && body.rotation < Math.PI*1.5) {
            body.rotation += Math.PI;
        } else if (body.rotation < -Math.PI/2 && body.rotation > -Math.PI*1.5) {
            body.rotation -= Math.PI;
        }
        
        e.attachCmp(cmpbeam);
        e.attachCmp(cmptrans);
        e.attachCmp(cmprend);
        
        return e;
    }    
    
    public function createCable(p1 : Vec2, p2 : Vec2, material : BuildMat) : Entity
    {
        var cab = state.createEnt("cc");
        var cmp = new CmpCable(p1, p2, material);
        var bitmap = new Bitmap(Assets.getBitmapData('img/cable.png'));
        var rcmp = new CmpRenderCable(cmp, bitmap);
        cab.attachCmp(cmp);
        cab.attachCmp(rcmp);
        return cab;
    }
    
    public function createMultiBeamEnt(pos : Vec2, entity : Entity, splitType : SplitType, name : String = "") : Entity
    {
        var e = state.createEnt(name);
        var oldCmpBeam = entity.getCmp(CmpBeam);
        var cmpbeam = CmpMultiBeam.createFromBeam(oldCmpBeam, splitType, null);
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
        var sj = new CmpSharedJoint(pos, bodies);
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
        
        var cmpbeam = new CmpMultiBeam(pos1, pos2, compound);
        var cmptrans = new CmpTransform(pos1);
        
        e.attachCmp(cmpbeam);
        e.attachCmp(cmptrans);
        
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
    
    public function createCar(pos :Vec2, dir : Int) : Entity
    {
        var e = state.createEnt();
        
        var cm = new CmpMoverCar(pos);
        var cc = new CmpControlCar(cm);
        var cr = new CmpRenderCar(cm);
        
        cc.speed = GameConfig.carSpeed * dir;
        
        e.attachCmp(cm);
        e.attachCmp(cc);
        e.attachCmp(cr);
        
        return e;
    }

    public function createTruck(pos : Vec2, dir : Int, type : TruckType) : Array<Entity>
    {
        var truck = new Array<Entity>();
        switch(type) {
            case TRACTOR_ONLY:
                var e = state.createEnt();
                var tractor = new CmpMoverTruckTractor(pos);
                e.attachCmp(tractor);
                truck.push(e);
            case HEAVY_COMBINATION:
                var e1 = state.createEnt();
                var tractor = new CmpMoverTruckTractor(pos);
                e1.attachCmp(tractor);
                var e2 = state.createEnt();
                var trailer = new CmpMoverTruckTrailer(pos.add(Vec2.weak(-GameConfig.truckTractorCabDim.w*0.5-10, 0 )));
                e2.attachCmp(trailer);
                tractor.addTrailer(trailer);
                truck.push(e1);
                truck.push(e2);
            case RIGID:
                var e = state.createEnt();
                var tractor = new CmpMoverTruckRigid(pos);
                e.attachCmp(tractor);
                truck.push(e);
        }
        return truck;
    }
    
    public function createTrain(pos :Vec2, dir : Int, count : Int) : Array<Entity>
    {
        var ents = new Array<Entity>();
        var e = state.createEnt();
        var cm = new CmpMoverTrainEngine(pos);
        var cm2 = new CmpMoverTrainCar(pos.add(Vec2.weak(-(GameConfig.trainCarDim.w+GameConfig.trainMargin*2), 0)));
        cm.addCar(cm2);
        ents.push(e);
        
        var prev : CmpMoverTrainCar = cm2;
        for (i in 0...count) {
            var cmt = new CmpMoverTrainCar(pos.add(Vec2.weak(-(GameConfig.trainCarDim.w+GameConfig.trainMargin*2 )* i, 0)));
            var ee = state.createEnt();
            ee.attachCmp(cmt);
            prev.addCar(cmt);
            prev = cmt;
            ents.push(ee);
        }
        //var cc = new CmpControlCar(cm);
        
        //cc.speed = GameConfig.carSpeed * dir;
        
        e.attachCmp(cm);
        e.attachCmp(cm2);
        //e.attachCmp(cc);
        
        return ents;
    }
    
    public function createSpawn(spawnType : SpawnType, pos : Vec2, dir : Int, period : Float, count : Int) : Entity
    {
        var spawnIcon = new Body(BodyType.KINEMATIC, pos);
        spawnIcon.shapes.add(new Polygon(Polygon.regular(20, 20, 3, 0.0), null, new InteractionFilter(GameConfig.cgSpawn, GameConfig.cmEditable)));
        if (dir == -1) {
            spawnIcon.rotation = Math.PI;
        }
        var spawn = state.createEnt();
        var cmpSpawn = new CmpSpawn(spawnType, pos, dir, spawnIcon, count, period);
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
        var cmpanc = new CmpAnchor(anc, ase);
        cmpanc.fluid = fluid;
        var cmprender = new CmpRenderAnchor(cmpanc);
        cmprender.tintColour(212, 23, 80, 255);
        
        ent.attachCmp(cmpanc);
        ent.attachCmp(cmprender);
        
        anc.userData.entity = ent;
        return ent;
    }
    
    
}
