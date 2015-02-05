package com.org.bbb.physics;
import com.org.mes.Cmp;
import nape.geom.AABB;

/**
 * ...
 * @author ...
 */
class CmpTransform extends Cmp
{
    public var x(default, set) : Float;
    public var y(default, set) : Float;
    public var rotation(default, set) : Float;
    public var bbox : AABB;
    
    public function new(x : Float=0, y : Float=0, rotation : Float=0) 
    {
        super();
        this.x = x;
        this.y = y;
        this.rotation = rotation;
    }
    
    function set_x(x) : Float
    {
        sendMsg(Msgs.XTRANSCHANGE, this, { prevX : this.x } );
        this.x = x;
        return x;
    }
    function set_y(y) : Float
    {
        sendMsg(Msgs.YTRANSCHANGE, this, { prevY : this.y } );
        this.y = y;
        return y;
    }
    function set_rotation(r) : Float
    {
        //sendMsg(Msgs.YTRANSCHANGE, this, { prevY : this.y } );
        //this.y = y;
        return r;
    }
}