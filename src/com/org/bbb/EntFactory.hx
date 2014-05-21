package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.Top;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.Body;

/**
 * ...
 * @author 
 */
class EntFactory
{
    public function new(top : Top) 
    {
        this.top = top;
    }
    
    public function createJointEnt(pos : Vec2, joints : Array<Constraint>, name : String = "") : Entity
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
        
        e.attachCmp(cmpbeam);
        e.attachCmp(cmptrans);
        
        return e;
    }
    
    var top : Top;
}