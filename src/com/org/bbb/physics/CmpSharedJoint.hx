package com.org.bbb.physics ;
import com.org.bbb.GameConfig.JointType;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.constraint.Constraint;
import nape.constraint.DistanceJoint;
import nape.constraint.LineJoint;
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
@editor
class CmpSharedJoint extends CmpPhys
{   
    public var body : Body;
    @:isVar public var bodies(default, default) : Array<Body>;
    public var isAnchored = false;
    @editor
    @:isVar public var isRolling(default, set) : Bool = false;
    
    var joints : Array<Constraint>;
    
    public function new(trans : CmpTransform, pos : Vec2, startingBodies : Array<Body> = null) 
    {
        super(trans);
        body = new Body();
        body.shapes.add(GameConfig.sharedJointShape());
        body.position = pos;
        body.userData.sharedJoint = this;
        this.bodies = new Array();
        this.joints = new Array();
        if (startingBodies != null) {
            for (b in startingBodies) {
                if (b != null) {
                    addBody(b);
                }
            }
        } else {
            startingBodies = new Array();
        }
    }
    
    public function deleteNull()
    {
        bodies = bodies.filter(function (b) { return b.space != null || (b.compound != null && b.compound.space != null); } );
        joints = joints.filter(deleteJointIfNull);
        // isAnchored check not exactly correct..  
        // cause the anchored body may be removed... prolly not though
        if (bodies.length == 0 || joints.length == 0) {
            entity.delete();
        }
    }
    
    function deleteJointIfNull(j : Constraint)
    {
        var shouldDelete = false;
        if (Std.is(j, PivotJoint)) {
            var pj = cast(j, PivotJoint);
            shouldDelete = pj.body1.space == null || pj.body2.space == null;
            if (shouldDelete) {
                pj.space = null;
            }
        } else if (Std.is(j, LineJoint)) {
            var lj = cast(j, LineJoint); 
            shouldDelete = lj.body1.space == null || lj.body2.space == null;
            if (shouldDelete) {
                lj.space = null;
            }
        }
        return !shouldDelete;
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
        var isAnchorBody = b.shapes.at(0).filter.collisionGroup == GameConfig.cgAnchor;
        if (!bodies.has(b) && b != body && b != null) {
            if (!isAnchored && isAnchorBody) {
                isAnchored = true;
            }
            bodies.push(b);
            var beamEnt : Entity = b.userData.entity;
            
            if (beamEnt != null) {
                var beam = beamEnt.getCmpHavingAncestor(CmpBeamBase);
                if (beam != null) {
                    beam.sharedJoints.push(this);
                }
                var anc = beamEnt.getCmpHavingAncestor(CmpAnchor);
                if (anc != null) {
                    anc.sharedJoints.push(this);
                }
                var cable = beamEnt.getCmp(CmpCable);
                if (cable != null) {
                    if (cable.sj1 == null) {
                        cable.sj1 = this;
                    } else {
                        cable.sj2 = this;
                    }
                }
            }
            
            var j = GameConfig.pivotJoint(JointType.SHARED);
            j.body1 = b;
            j.body2 = body;
            /* Center of shared joint to world, then get the local coordinate of that point for the attached beam */
            j.anchor1 = b.worldPointToLocal(body.localPointToWorld(Vec2.weak(), true));
            j.anchor2 = Vec2.weak();
            j.space = body.space;
            joints.push(j);
            
        }
    }
    
    public function getAnchor() : Body
    {
        if (!isAnchored) return null;
        for (b in bodies) {
            if (b.shapes.at(0).filter.collisionGroup == GameConfig.cgAnchor) {
                return b;
            }
        }
        return null;
    }
    
    public function removeBody(b : Body)
    {
        if (bodies.remove(b)) {
            if (b.userData.attachedSJ != null) {
                b.userData.attachedSJ.remove(this);
            }
            for (j in joints) {
                var remove = false;
                j.visitBodies(function (body) { 
                    if (b == body)
                        remove = true;
                }); 
                
                if (remove) {
                    j.space = null;
                    joints.remove(j);
                }
                
            }
            var beamEnt : Entity = b.userData.entity;
            var beams = beamEnt.getCmpsHavingAncestor(CmpBeamBase);
            for (beam in beams) {
                beam.sharedJoints.remove(this);
            }
            var anc = beamEnt.getCmpHavingAncestor(CmpAnchor);
            if (anc != null) {
                anc.sharedJoints.remove(this);
            }
            for (c in b.constraints) {
                if (body.constraints.has(c)) {
                    c.space = null;
                }
            }
            // Check if this is still anchor shared joint
            if (bodies.length > 0 && isAnchored
             && b.shapes.at(0).filter.collisionGroup == GameConfig.cgAnchor) {
                isAnchored = false;
                bodies.foreach(function (bb) { 
                    if (bb.shapes.at(0).filter.collisionGroup == GameConfig.cgAnchor) 
                        isAnchored = true; 
                    return true; 
                });
            }
        }
    }
    
    override public function update()
    {
        deleteNull();

    }


    override function get_space() : Space { return body.space; }
    override function set_space(s : Space) : Space 
    { 
        body.space = s;
        body.constraints.foreach(function(cc) {
            cc.space = s;
        });
        for (j in joints) {
            j.space = s;
        }
        return body.space; 
    }
    
    function set_isRolling(b : Bool) : Bool {
        if (b == isRolling) return b;
        
        for (cc in body.constraints) {
           cc.visitBodies(function(bb) {
                var ent = bb.userData.entity;
                if (ent != null && ent.hasCmp(CmpAnchor)) {
                    if (isRolling) {
                        var lj = cast(cc, LineJoint);
                        var pj = GameConfig.pivotJoint(JointType.SHARED);
                        pj.body1 = lj.body1;
                        pj.body2 = lj.body2;
                        pj.anchor1 = lj.anchor1;
                        pj.anchor2 = lj.anchor2;
                        pj.userData.sharedJoint = this;
                        pj.space = lj.space;
                        joints.remove(lj);
                        joints.push(pj);
                        lj.space = null;
                    } else {
                        var pj = cast(cc, PivotJoint);
                        var lj = new LineJoint(pj.body1, pj.body2, pj.anchor1, pj.anchor2, Vec2.weak(1.0, 0), GameConfig.distanceJointMin, GameConfig.distanceJointMax);
                        lj.frequency = 15;
                        lj.space = pj.space;
                        lj.userData.sharedJoint = this;
                        
                        pj.space = null;
                        joints.remove(pj);
                        joints.push(lj);
                    }
                }
            });
        }
        isRolling = b;
        return b; 
    }
    
    override function set_entity(e: Entity) : Entity
    {
        this.entity = e;
        body.userData.entity = e;
        return e;
    }
    
}