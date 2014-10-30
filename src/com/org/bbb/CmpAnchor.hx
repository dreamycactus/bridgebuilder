package com.org.bbb;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;

/**
 * ...
 * @author 
 */
enum AnchorStartEnd
{
    START;
    END;
    NONE;
}
 
class CmpAnchor extends CmpPhys
{
    public var body : Body;
    public var startEnd : AnchorStartEnd;
    public function new(body : Body, ase : AnchorStartEnd) 
    {
        super();
        this.body = body;
        this.startEnd = ase;
    }
    
    override function get_space() : Space { return body.space;  }
    override function set_space(space : Space) : Space { body.space = space; return space;  }
    
}