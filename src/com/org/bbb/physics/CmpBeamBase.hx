package com.org.bbb.physics ;
import com.org.bbb.control.BridgeNode;
import com.org.mes.Entity;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;

/**
 * ...
 * @author 
 */

using Lambda;
@editor
class CmpBeamBase extends CmpPhys implements BridgeNode
{
    public var sharedJoints : Array<CmpSharedJoint> = new Array();
    @editor
    public var material : BuildMat;
    public var broken : Bool = false;
    @editor
    public var p1(default, set) : Vec2;
    @editor
    public var p2(default, set) : Vec2;
    public var slope(get_slope, null) : Float;
    @editor
    public var isRoad(get_isRoad, null) : Bool;
    public var length(get_length, null) : Float;
    public var unitLength(get_unitLength, null) : Int;
    
    @:isVar public var sj1 (default, set_sj1): CmpSharedJoint;
    @:isVar public var sj2 (default, set_sj2): CmpSharedJoint;
    
    public function new(trans : CmpTransform, p1 : Vec2, p2 : Vec2) 
    {
        super(trans);
        this.p1 = p1;
        this.p2 = p2;
    }
    
    public function notifySharedJoints(): Void
    {
        for (s in sharedJoints) {
            s.deleteNull();
        }
    }
    
    public function changeFilter(f : InteractionFilter) : Void
    {
    }
    
    public function getFilter() : InteractionFilter
    {
        return null;
    }
    
    //function sameBody(b2 : Body) : Bool
    //{
        //return b.id == b2.id;
    //}
    
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
                if (!res.has(b)) {
                    res.push(b);
                }
            }
        }
        return res;
    }

    
    function set_sj1(sj : CmpSharedJoint) : CmpSharedJoint
    {
        this.sj1 = sj;
        return sj;
    }
    
    function set_sj2(sj : CmpSharedJoint) : CmpSharedJoint
    {
        this.sj2 = sj;
        return sj;
    }
    
    function get_slope() : Float
    {
        return (p2.y - p1.y) / (p2.x - p1.x);
    }
    
    function get_isRoad() : Bool
    {
        return false;
    }
    
    function get_length() : Float
    {
        var p = p1.sub(p2);
        var l = p.length;
        p.dispose();
        return l;
    }

    function get_body() : Body
    {
        return null;
    }
    function get_unitLength() : Int
    {
        return Std.int(length / GameConfig.gridCellWidth);
    }
    
    function boltBeam(anchorWorldPos : Vec2, sharedJointIndex : Int) 
    {
        if (space != null) {
            var bb  = space.bodiesUnderPoint(anchorWorldPos, new InteractionFilter(GameConfig.cgSensor, GameConfig.cgAnchor | GameConfig.cgSharedJoint | GameConfig.cgBeam));
            var sharedJoint : Body = null;
            var anchor : Body = null;
            var thisbody : Body = null;
            for (b in bb) {
                if (b.shapes.at(0).filter.collisionGroup & GameConfig.cgSharedJoint != 0) {
                    sharedJoint = b;
                    break;
                } else if (b.shapes.at(0).filter.collisionGroup & GameConfig.cgAnchor != 0) {
                    anchor = b;
                } else if (b.shapes.at(0).filter.collisionGroup & (GameConfig.cgBeam|GameConfig.cgCable) != 0) {
                    thisbody = b;
                }
            }
            if (sharedJoint == null) {
                var sj = EntFactory.inst.createSharedJoint(anchorWorldPos, [thisbody, anchor]);
                if (sharedJointIndex == 1) {
                    sj1 = sj.getCmp(CmpSharedJoint);
                } else if (sharedJointIndex ==2) {
                    sj2 = sj.getCmp(CmpSharedJoint);
                }
            }
            
        }
    }
    
    function set_p1(v : Vec2) : Vec2
    {
        boltBeam(v, 1);
        return p1 = v;
    }
    
    function set_p2(v : Vec2) : Vec2
    {
        boltBeam(v, 2);
        return p2 = v;
    }

}