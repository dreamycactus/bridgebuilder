package com.org.bbb;
import com.org.bbb.GameConfig.BuildMat;
import com.org.mes.Entity;
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
    
    public function new(p1 : Vec2, p2 : Vec2) 
    {
        super();
        this.p1 = p1;
        this.p2 = p2;
    }
    
    public function notifySharedJoints()
    {
        for (s in sharedJoints) {
            s.deleteNull();
        }
    }

}