package com.org.bbb;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.geom.Vec2;

/**
 * ...
 * @author 
 */
class CmpTransform implements Cmp
{
    public var entity : Entity;
    public var pos(default,default) : Vec2;
    
    public function new(pos : Vec2 = null) 
    {
        this.pos = pos;
    }
    
    public function update()
    {
        
    }
}