package com.org.bbb;
import com.org.bbb.Config.JointType;
import com.org.mes.Entity;
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
    public static var inst : EntFactory; // Forgive me..
    public var top : Top;

    
    public function new(top : Top) 
    {
        if (inst != null) {
            throw "Only one...... QQ";
        }
        inst = this;
        this.top = top;
    }
    
    public function createJointEnt(pos : Vec2, body1 : Body, body2 : Body, type : JointType
                                 , compound : Compound = null, name : String = "") : Entity
    {
        var e = top.createEnt(name);
        var joint : PivotJoint = Config.pivotJoint(type);
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
    
    public function createBeamEnt(pos : Vec2, body : Body, name : String = "") : Entity
    {
        var e = top.createEnt(name);
        var cmpbeam = new CmpBeam(body);
        var cmptrans = new CmpTransform(pos);
        
        if (pos != null) {
            body.position = pos;
        }
        
        e.attachCmp(cmpbeam);
        e.attachCmp(cmptrans);
        
        return e;
    }    
    
    public function createMultiBeamEnt(pos : Vec2, compound : Compound, name : String = "") : Entity
    {
        var e = top.createEnt(name);
        var cmpbeam = new CmpMultiBeam(compound);
        
        e.attachCmp(cmpbeam);
        
        return e;
    }
    
    public function createSharedJoint(pos : Vec2, bodies : Array<Body>, name : String = "") : Entity
    {
        var e = top.createEnt(name);
        var sj = new CmpSharedJoint(pos, bodies);
        
        e.attachCmp(sj);
        
        return e;
    }
    
    public function createDoubleJoint(pos1 : Vec2, pos2 : Vec2, body1 : Body, body2 : Body,
                                      compound : Compound, name : String = "") : Entity
    {
        var e = top.createEnt(name);
        var joint : PivotJoint = Config.pivotJoint(JointType.MULTISTIFF);
        joint.body1 = body1;
        joint.body2 = body2;
        joint.anchor1 = body1.worldPointToLocal(pos1);
        joint.anchor2 = body2.worldPointToLocal(pos1);
        joint.compound = compound;
        
        var joint2 : PivotJoint = Config.pivotJoint(JointType.MULTIELASTIC);
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
    
    public function createGridEnt(cellsz : Int, cellCount : Array<Int>) : Entity
    {
        var e = top.createEnt("grid");
        var cmpGrid = new CmpGrid(cellsz, cellCount);
        var cmpRenderGrid = new CmpRenderGrid(Lib.current.stage, cmpGrid);
        
        e.attachCmp(cmpGrid);
        e.attachCmp(cmpRenderGrid);
        
        return e;
    }
    
    public function createCar(pos :Vec2) : Entity
    {
        var e = top.createEnt();
        var b = new Body(null, pos);
        var s = new Polygon(Polygon.box(50, 20, true) );
        s.material = new Material(0.0, 0.0, 0.1, 20);
        s.filter.collisionGroup = Config.cgLoad;
        b.shapes.add(s);
        
        var cm = new CmpMover(b);
        var cc = new CmpControlMoverCar(cm);
        
        e.attachCmp(cm);
        e.attachCmp(cc);
        
        return e;
    }
    
}