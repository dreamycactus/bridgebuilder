package com.org.bbb;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpMover extends CmpPhys
{
    public var body : Body;
    
    public function new(body : Body) 
    {
        super();
        this.body = body;
    }
    
    public function moveHor(extent : Float) : Void
    {
        var dir = body.worldVectorToLocal(Vec2.weak(extent, 0) );
        body.applyImpulse(dir);
    }
    
    public function moverNeutral() : Void
    {
    }
    
    override function set_space(space : Space) : Space
    {
        body.space = space;
        return space;
    }
    
    override function get_space() : Space
    {
        return body.space;
    }
    
}