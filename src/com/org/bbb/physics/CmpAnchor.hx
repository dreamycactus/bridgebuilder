package com.org.bbb.physics ;
import com.org.bbb.control.BridgeNode;
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

@author("Harry")
@editor
class CmpAnchor extends CmpPhys implements BridgeNode
{
    public var body(default, set) : Body;
    public var startEnd : AnchorStartEnd;
    public var tapered : Bool;
    public var fluid : Bool;
    
    @editor
    public var width(default, set) : Float;
    @editor
    public var height(default, set) : Float;
    
    @editor
    public var x(get, set) : Float;
    @editor
    public var y(get, set) : Float;
    
    @:isVar public var sharedJoints(default, default) : Array<CmpSharedJoint> = new Array();
    public function new(trans : CmpTransform, body : Body, ase : AnchorStartEnd, tapered : Bool=false) 
    {
        super(trans);
        this.body = body;
        this.startEnd = ase;
        this.tapered = tapered;
        var bounds = body.bounds;
        this.width = bounds.width;
        this.height = bounds.height;
        if (body != null) {
            x = body.position.x;
            y = body.position.y;
        }
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
    
    function get_x() : Float { return body.position.x-width*0.5; }
    function get_y() : Float { return body.position.y - height * 0.5; }
    function set_body(b) : Body
    {
        this.body = b;
        if (b != null) {
            transform.bbox = this.body.bounds;
        }
        return b;
    }
    
    function set_x(x) : Float 
    { 
        var space = body.space; 
        body.space = null; 
        body.position.x = x; 
        body.space = space; 
        transform.x = body.position.x - width * 0.5;
        sendMsg(Msgs.ENTMOVE, this, null);
        return x; 
    }
    function set_y(y) : Float 
    { 
        var space = body.space; 
        body.space = null; 
        body.position.y = y; 
        body.space = space; 
        transform.y = body.position.y - height * 0.5;
        sendMsg(Msgs.ENTMOVE, this, null);
        return y; 
    }
    function set_width(w) : Float
    {
        this.width = w;
        return w;
    }
    function set_height(h) : Float
    {
        this.height = h;
        return h;
    }
    
}