package com.org.glengine;
import openfl.utils.Float32Array;

/**
 * ...
 * @author ...
 */
class BrSprite extends TextureRegion implements BrDrawable
{
    static var VERTEX_SIZE = 2 + 2 + 1;
    static var SPRITE_SIZE = 4 * VERTEX_SIZE;
    
    public var x(default, set) : Float;
    public var y(default, set) : Float;
    public var originX(default, set) : Float = 0;
    public var originY(default, set) : Float = 0;
    public var rotation(default, set) : Float = 0;
    public var scaleX(default, set) : Float = 1;
    public var scaleY(default, set) : Float = 1;
    public var vertices(get, null) : Float32Array = new Float32Array(SPRITE_SIZE);

    
    var dirty : Bool = false;
    
    public var drawLayer : Int = 1;
    public var color : Int;
    
    
    public function new()
    {
        super();
    }
    
    public function drawBatched(batch : BrSpriteBatch)
    {
        
    }
    
    override public function setRegion(u : Float, v : Float, u2 : Float, v2 : Float)
    {
        super.setRegion();

    }
    
    function get_vertices() : Float32Array
    {
        if (dirty) {
            dirty = false;
        }
        return vertices;
    }
    
    function set_x(x : Float) : Float
    {
        dirty = true;
        this.x = x;
        return x;
    }
    function set_y(y : Float) : Float
    {
        dirty = true;
        this.y = y;
        return y;
    }
    function set_rotation(r : Float) : Float
    {
        dirty = true;
        this.rotation = r;
        return r;
    }
    function set_originX(ox : Float) : Float
    {
        dirty = true;
        this.originX = ox;
        return ox;
    }
    function set_originY(oy : Float) : Float
    {
        dirty = true;
        this.originY = oy;
        return oy;
    }
    function set_scaleX(sx : Float) : Float
    {
        dirty = true;
        this.scaleX = sx;
        return sx;
    }
    function set_scaleY(sy : Float) : Float
    {
        dirty = true;
        this.scaleY = sy;
        return sy;
    }
    
}