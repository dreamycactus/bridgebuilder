package com.org.bbb.physics ;
import com.org.bbb.control.BridgeNode;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
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

@editor
@:access(com.org.bbb.physics.CmpTransform)
class CmpAnchor extends CmpPhys implements BridgeNode
{
    public var body(default, set) : Body;
    @editor
    public var data : Dynamic;
    public var startEnd : AnchorStartEnd;
    //@editor
    public var tapered : Bool;
    //@editor
    public var fluid : Bool;
    
    @editor
    public var width(default, set) : Float = 0;
    @editor
    public var height(default, set) : Float = 0;
    
    @editor
    @:isVar public var x(get, set) : Float;
    @editor
    @:isVar public var y(get, set) : Float;
    
    @:isVar public var sharedJoints(default, default) : Array<CmpSharedJoint> = new Array();
    public function new(trans : CmpTransform, body : Body, ase : AnchorStartEnd, tapered : Bool=false) 
    {
        super(trans);
        subscriptions = [Msgs.TRANSCHANGE];
        this.startEnd = ase;
        this.tapered = tapered;
        this.body = body;
        var bounds = body.bounds;
        rebuild();
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
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void 
    {
        switch(msgType) {
        case Msgs.TRANSCHANGE:
            body.position.x = transform.x + width * 0.5;
            body.position.y = transform.y + height * 0.5;
            internalSendMsg(Msgs.ENTMOVE, this, { x : transform.x, y : transform.y } );
        }
    }

    function get_sharedJoints() : Array<CmpSharedJoint>
    {
        return sharedJoints;
    }
    
    function get_x() : Float { return transform.x; }
    function get_y() : Float { return transform.y; }
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
        body.position.x = x + width * 0.5; 
        transform._x = body.position.x - width * 0.5;
        internalSendMsg(Msgs.ENTMOVE, this, {x:x, y:y});
        return this.x=x; 
    }
    function set_y(y) : Float 
    { 
        body.position.y = y; 
        transform._y = body.position.y - height * 0.5;
        internalSendMsg(Msgs.ENTMOVE, this, {x:x, y:y});
        return this.y=y; 
    }
    function set_width(w) : Float
    {
        this.width = w;
        rebuild();
        internalSendMsg(Msgs.ENTMOVE, this, null);
        
        return w;
    }
    function set_height(h) : Float
    {
        this.height = h;
        rebuild();
        return h;
    }
    function rebuild() : Void
    {
        body.shapes.clear();
        x = transform.x;
        y = transform.y;

        if (width != 0 && height != 0) {
            var filter = null;
            if (fluid) {
                filter = new InteractionFilter(GameConfig.cgNull, 0, GameConfig.cgNull, 0, GameConfig.cgAnchor, -1);
            } else {
                filter = new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor);
            }
            body.shapes.push(new Polygon(Polygon.box(width, height), GameConfig.matSteel.material, filter));
            internalSendMsg(Msgs.REFRESH, this, null);
        }

    }
}