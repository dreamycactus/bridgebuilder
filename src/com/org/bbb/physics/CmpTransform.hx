package com.org.bbb.physics;
import com.org.mes.Cmp;
import nape.geom.AABB;

/**
 * ...
 * @author ...
 */
@editor
@:access(com.org.mes.Cmp)
class CmpTransform extends Cmp
{
    @editor
    public var x(get, set) : Float;
    var _x : Float;
    @editor
    public var y(get, set) : Float;
    var _y : Float;
    @editor
    public var rotation(default, set) : Float;
    public var bbox : AABB;
    
    public function new(x : Float=0, y : Float=0, rotation : Float=0) 
    {
        super();
        this.x = x;
        this.y = y;
        this.rotation = rotation;
    }
    function get_x() { return _x; }
    function get_y() { return _y; }
    function set_x(x) : Float
    {
        this._x = x;
        internalSendMsg(Msgs.TRANSCHANGE, this, { x : _x, y : _y } );
        return x;
    }
    function set_y(y) : Float
    {
        this._y = y;
        internalSendMsg(Msgs.TRANSCHANGE, this, { x : _x, y : _y } );
        return y;
    }
    function set_rotation(r) : Float
    {
        //sendMsg(Msgs.YTRANSCHANGE, this, { prevY : this.y } );
        //this.y = y;
        return r;
    }
}