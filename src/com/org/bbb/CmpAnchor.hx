package com.org.bbb;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpAnchor extends CmpPhys
{
    public var body : Body;
    public function new(body : Body) 
    {
        super();
        this.body = body;
    }
    
    override function get_space() : Space { return body.space;  }
    override function set_space(space : Space) : Space { body.space = space; return space;  }
    
}