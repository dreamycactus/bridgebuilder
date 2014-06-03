package com.org.bbb;
import com.org.bbb.Config.BeamMat;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.constraint.Constraint;
import nape.phys.Body;
import nape.phys.Compound;

/**
 * ...
 * @author 
 */
class CmpMultiBeam implements Cmp
{
    public var compound : Compound;
    public var material : BeamMat;
    public var entity : Entity;
    public var consDecayRate : Float = 1e5;
    
    public function new(compound : Compound, material : BeamMat=null) 
    {
        this.compound = compound;
        this.material = material;
        this.constraints = new List();
        
        compound.constraints.foreach(function(c) {
           constraints.add(c); 
        });
    }
    
    public function update()
    {   
        if (compound == null) {
            return;
        }
        var dt = entity.top.dt;
        
        for (c in constraints) {
            if (c.maxForce > consDecayRate * dt) {
                c.maxForce -= consDecayRate * dt;
            }

        }
    }
    var constraints : List<Constraint>;
}