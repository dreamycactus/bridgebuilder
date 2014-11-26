package com.org.bbb;
import com.org.mes.Entity;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

/**
 * ...
 * @author 
 */
enum AnchorStartEnd
{
    START;
    END;
    NONE;
}
 
class CmpAnchor extends CmpPhys implements BridgeNode
{
    public var body : Body;
    public var startEnd : AnchorStartEnd;
    public var tapered : Bool;
    public var fluid : Bool;
    @:isVar public var sharedJoints(default, default) : Array<CmpSharedJoint> = new Array();
    public function new(body : Body, ase : AnchorStartEnd, tapered : Bool=false) 
    {
        super();
        this.body = body;
        this.startEnd = ase;
        this.tapered = tapered;
    }
    
    public function findAdjacentBodies() : Array<Body>
    {
        var res = new Array<Body>();
        for (sj in sharedJoints) {
            for (b in sj.bodies) {
                //var e : Entity = b.userData.entity;
                //if (e == null) continue;
                //var beam = e.getCmpHavingAncestor(CmpBeamBase);
                //if (beam != null) {
                    //res.push(beam.get_body());
                    //continue;
                //}
                //var anc = e.getCmpHavingAncestor(CmpAnchor);
                //if (anc != null) {
                    //res.push(anc.body);
                    //continue;
                //}
                 if (!Lambda.has(res, b)) {
                    res.push(b);
                }
            }
        }
        return res;
    }
    
    function noDeadEntity(sj : CmpSharedJoint) : Bool
    {
        return sj.entity == null || sj.entity.state == null;
    }
    
    public function refreshSharedJoints() : Void
    {
        sharedJoints = sharedJoints.filter(noDeadEntity);
        
    }
    
    override function get_space() : Space { return body.space;  }
    override function set_space(space : Space) : Space { body.space = space; return space;  }
    
    function get_sharedJoints() : Array<CmpSharedJoint>
    {
        return sharedJoints;
    }
    
}