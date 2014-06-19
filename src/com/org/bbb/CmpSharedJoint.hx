package com.org.bbb;
import com.org.bbb.Config.JointType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

using Lambda;

/**
 * ...
 * @author 
 */
class CmpSharedJoint extends CmpPhys
{   
    public var body : Body;
    
    public function new(pos : Vec2, startingBodies : Array<Body> = null) 
    {
        super();
        body = new Body();
        body.shapes.add(Config.sharedJointShape());
        body.position = pos;
        //body.allowRotation = false;
        body.userData.sharedJoint = this;
        this.bodies = new Array();
        this.joints = new Array();
        if (startingBodies != null) {
            for (b in startingBodies) {
                if (b != null) {
                    addBody(b);
                }
            }
        }

    }
    
    public function breakAll()
    {
        body.constraints.foreach(function(c) {
            c.space = null;
        });
        body.space = null;
    }
    
    public function addBody(b : Body) 
    {
        if (!bodies.has(b) && b != body) {
            bodies.push(b);
            var j = Config.pivotJoint(JointType.SHARED);
            j.body1 = b;
            j.body2 = body;
            j.anchor1 = b.worldPointToLocal(body.localPointToWorld(Vec2.weak(), true), true);
            j.anchor2 = Vec2.get();
            joints.push(j);
            j.space = body.space;
        }
    }
    
    public function removeBody(b : Body)
    {
        if (bodies.remove(b)) {
            b.constraints.foreach(function(c) {
                c.space = null;
            });
        }
        if (bodies.length == 0) {
            entity.top.deleteEnt(entity);
        }
    }
    
    override public function update()
    {
        
    }

    var bodies(default, default) : Array<Body>;
    var joints : Array<Constraint>;

    override function get_space() : Space { return body.space; }
    override function set_space(s : Space) : Space 
    { 
        body.space = s;
        for (b in bodies) {
            if (b.compound == null) {
                b.space = s;
            }
        }
        for (j in joints) {
            j.space = s;
        }
        return body.space; 
    }
    
    
}