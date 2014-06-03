package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.Top;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Compound;

/**
 * ...
 * @author 
 */
class EntFactory
{
    public static var inst : EntFactory; // Forgive me..
    
    public function new(top : Top) 
    {
        if (inst != null) {
            throw "Only one...... QQ";
        }
        inst = this;
        this.top = top;
    }
    
    public function createJointEnt(pos : Vec2, body1 : Body, body2 : Body, name : String = "") : Entity
    {
        var e = top.createEnt(name);
        var cmpmj = new CmpMultiJoint(joints);
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
        var cmptrans = new CmpTransform(pos);
        
        e.attachCmp(cmpbeam);
        e.attachCmp(cmptrans);
        
        return e;
    }
    
    public function createGridEnt(cellsz : Int, cellCount : Array<Int>) : Entity
    {
        var e = top.createEnt("grid");
        var cmpGrid = new CmpGrid(cellsz, cellCount);
        var cmpRenderGrid = new CmpRenderGrid(cmpGrid);
        
        e.attachCmp(cmpGrid);
        e.attachCmp(cmpRenderGrid);
        
        return e;
    }
    
    var top : Top;
}