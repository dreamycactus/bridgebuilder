package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import nape.phys.Body;

/**
 * ...
 * @author 
 */
class CmpBeam implements Cmp
{
    public var body : Body;
    public var jointOffsets : Array<Vec2>;
    
    public function new(body : Body, jointOffsets : Array<Vec2>) 
    {
        this.body = body;
        this.jointOffsets = jointOffsets;
    }
    
    public function getWorldOffset(index : Int) : Vec2
    {
        if (jointOffsets != null && body != null && index > -1 && index < jointOffsets.length) {
            return body.localPointToWorld(jointOffsets[index]);
        }
        return Vec2.get();
    }
    
}