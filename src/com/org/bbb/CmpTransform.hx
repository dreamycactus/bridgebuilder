package com.org.bbb;
import nape.geom.Vec2;

/**
 * ...
 * @author 
 */
class CmpTransform
{
    public var pos(default,default) : Vec2;
    
    public function new(pos : Vec2 = null) 
    {
        this.pos = pos;
    }
    
}