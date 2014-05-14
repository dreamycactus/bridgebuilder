package com.org.bbb;
import com.org.mes.Cmp;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Body;

/**
 * ...
 * @author 
 */
class CmpMultiJoint implements Cmp
{   
    public function new(startingJoints : Array<Constraint> = null) 
    {
        super();
        this.joints = startingJoints;
    }
    
    public function breakAll()
    {
        for (j in joints) {
            j.space = null;
        }
        joints = new Array();
    }
    
    public function addJoint(j : Constraint) 
    {
        joints.push(j);
    }
    
    public function removeJointByBody(bodies : Array<Body>)
    {
        var toRemove : Array<Constraint> = new Array();
        var bodyExists : Bool;
        
        for (body in bodies) {
            for (j in joints) {
                bodyExists = false;
                j.visitBodies(function(i) {
                    if (i == body) {
                        bodyExists = true;
                    }
                });
                if (bodyExists) {
                    toRemove.push(j);
                }
            }
        }

        for (j in toRemove) {
            j.space = null;
            joints.remove(j);
        }
                  
    }
    
    var joints(default,default) : Array<Constraint>;
}