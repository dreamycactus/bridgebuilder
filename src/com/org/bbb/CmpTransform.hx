package com.org.bbb;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.geom.Vec2;

/**
 * ...todo:delete
 * @author 
 */
class CmpTransform extends Cmp
{
    public var pos(default, default) : Vec2;
    public var rot : Float;
    
    public function new(pos : Vec2 = null, rot : Float = 0) 
    {
        super();
        this.pos = pos;
        this.rot = rot;
    }

}