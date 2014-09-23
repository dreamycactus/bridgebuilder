package com.org.bbb;
import com.org.bbb.CmpMultiBeam.SplitType;
import com.org.bbb.CmpRenderMultiBeam.BodyBitmap;
import com.org.bbb.GameConfig.BuildMat;
import com.org.bbb.GameConfig.JointType;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.Top;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Compound;
import nape.phys.Material;
import nape.shape.Polygon;
import openfl.Lib;

/**
 * ...
 * @author 
 */
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
    
    public function createJointEnt(pos : Vec2, body1 : Body, body2 : Body, type : JointType
                                 , compound : Compound = null, name : String = "") : Entity
    {
        var e = state.createEnt(name);
        var joint : PivotJoint = GameConfig.pivotJoint(type);
        joint.body1 = body1;
        joint.body2 = body2;
        joint.anchor1 = body1.worldPointToLocal(pos);
        joint.anchor2 = body2.worldPointToLocal(pos);
        joint.compound = compound;
        
        var cmpmj = new CmpJoint(joint, type);
        var cmptrans = new CmpTransform(pos);
        
        e.attachCmp(cmpmj);
        e.attachCmp(cmptrans);
        
        return e;
    }
    
    public function createBeamEnt(pos : Vec2, body : Body, width : Float, material : BuildMat, name : String = "") : Entity
    {
        var e = state.createEnt("be");
        var cmpbeam = new CmpBeam(body, width, material);
        var cmptrans = new CmpTransform(pos);
        
        //var length = body.shapes.at(0).bounds.width;
        var assetPath : String = "";
        var offset = Vec2.get();
        switch(material.name) {
            case "steelbeam":
                assetPath = "img/beam.png";
            case "steeldeck":
                assetPath = "img/deck.png";
                offset.y = -20;
        }
        var cmprend = new CmpRenderMultiBeam([{bitmap : GfxFactory.inst.createBeamBitmap(assetPath, width), body : body} ], offset);
        
        if (pos != null) {
            body.position = pos;
        }
        body.userData.entity = e;
        body.userData.width = width;
        body.userData.height = material.height;
        
        e.attachCmp(cmpbeam);
        e.attachCmp(cmptrans);
        e.attachCmp(cmprend);
        
        return e;
    }    
    
    public function createMultiBeamEnt(pos : Vec2, entity : Entity, splitType : SplitType, name : String = "") : Entity
    {
        var e = state.createEnt(name);
        var compound = CmpMultiBeam.createFromBeam(entity.getCmp(CmpBeam).body, splitType, null);
        var cmpbeam = new CmpMultiBeam(compound);
        var pairs : Array<BodyBitmap> = new Array();
        
        var oldrender = entity.getCmp(CmpRenderMultiBeam);
        var cmprender = new CmpRenderMultiBeam(
            GfxFactory.inst.breakBeamBitmap(compound
                                          , oldrender.pairs[0].bitmap), oldrender.offset);
        
        e.attachCmp(cmpbeam);
        e.attachCmp(cmprender);
        
        return e;
    }
    
    public function createSharedJoint(pos : Vec2, bodies : Array<Body>=null, name : String = "") : Entity
    {
        var e = state.createEnt("sj");
        var sj = new CmpSharedJoint(pos, bodies);
        
        e.attachCmp(sj);
        
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
        
        var cmpbeam = new CmpMultiBeam(compound);
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
        
        cc.speed = GameConfig.carSpeed * dir;
        
        e.attachCmp(cm);
        e.attachCmp(cc);
        
        return e;
    }
    
    
}