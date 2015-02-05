package com.org.bbb.physics ;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpPhys extends Cmp
{
    @:isVar public var space(get, set) : Space;
    public var transform : CmpTransform; // each CmpPhys should update this
    public function new(transform : CmpTransform)
    {
        super();
        this.transform = transform;
    }
    
    function get_space() : Space { return null;  }
    function set_space(space : Space) : Space { this.space = space;  return null;  }
}