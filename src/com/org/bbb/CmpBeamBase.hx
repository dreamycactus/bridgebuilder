package com.org.bbb;
import com.org.mes.Entity;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;

/**
 * ...
 * @author 
 */
class CmpBeamBase extends CmpPhys
{
    public var sharedJoints : Array<CmpSharedJoint> = new Array();
    public var material : BuildMat;
    public var broken : Bool = false;
    public var p1 : Vec2;
    public var p2 : Vec2;
    
    @:isVar public var sj1 (default, set_sj1): CmpSharedJoint;
    @:isVar public var sj2 (default, set_sj2): CmpSharedJoint;
    
    public function new(p1 : Vec2, p2 : Vec2) 
    {
        super();
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

}