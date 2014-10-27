package com.org.bbb;
import com.org.mes.Cmp;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpPhys extends Cmp
{
    @:isVar public var space(get_space, set_space) : Space;
    public function new()
    {
        super();
    }
    
    function get_space() : Space { return null;  }
    function set_space(space : Space) : Space { this.space = space;  return null;  }
}