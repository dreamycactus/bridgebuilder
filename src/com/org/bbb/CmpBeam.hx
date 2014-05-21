package com.org.bbb;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.geom.Vec2;
import nape.phys.Body;

/**
 * ...
 * @author 
 */
class CmpBeam implements Cmp
{
    public var body : Body;
    public var entity : Entity;
    public var jointOffsets : Array<Vec2>;
    
    public function new(body : Body, jointOffsets : Array<Vec2>=null) 
    {
        this.body = body;
        this.jointOffsets = jointOffsets == null ? new Array() : jointOffsets;
    }
    
    public function getWorldOffset(index : Int) : Vec2
    {
        if (jointOffsets != null && body != null && index > -1 && index < jointOffsets.length) {
            return body.localPointToWorld(jointOffsets[index]);
        }
        return Vec2.get();
    }
    
    public function update()
    {
        var t : CmpTransform = entity.getCmp(CmpTransform);
        t.pos = body.position;
    }
    
}