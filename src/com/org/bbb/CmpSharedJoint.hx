package com.org.bbb;
import com.org.bbb.GameConfig.JointType;
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
    @:isVar public var bodies(default, default) : Array<Body>;
    
    public function new(pos : Vec2, startingBodies : Array<Body> = null) 
    {
        super();
        body = new Body();
        body.shapes.add(GameConfig.sharedJointShape());
        body.position = pos;
        //body.allowRotation = false;
        body.userData.sharedJoint = this;
        this.bodies = new Array();
        this.joints = new Array();
        if (startingBodies != null) {
            for (b in startingBodies) {
                if (b != null) {
                    addBody(b);
                    if (b.userData.entity != null) {
                        ents.push(b.userData.entity);
                    }   
                }
            }
        } else {
            startingBodies = new Array();
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
        if (!bodies.has(b) && b != body && b != null) {
            bodies.push(b);
            var j = GameConfig.pivotJoint(JointType.SHARED);
            j.body1 = b;
            j.body2 = body;
            /* Center of shared joint to world, then get the local coordinate of that point for the attached beam */
            j.anchor1 = b.worldPointToLocal(body.localPointToWorld(Vec2.weak(), true), true);
            j.anchor2 = Vec2.get();
            j.space = body.space;
            joints.push(j);
            
            if (b.userData.entity != null) {
                ents.push(b.userData.entity);
            }
        } else {
            trace("fail shared joint");
        }
    }
    
    public function removeBody(b : Body)
    {
        if (bodies.remove(b)) {
            b.constraints.foreach(function(c) {
                if (body.constraints.has(c)) {
                    c.space = null;
                }
            });
        }
    }
    
    override public function update()
    {
        
    }

    var ents : Array<Entity> = new Array();
    var joints : Array<Constraint>;

    override function get_space() : Space { return body.space; }
    override function set_space(s : Space) : Space 
    { 
        body.space = s;
        for (j in joints) {
            j.space = s;
        }
        return body.space; 
    }
    
    
}