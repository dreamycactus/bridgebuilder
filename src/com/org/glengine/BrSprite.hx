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
    
    public var x : Float;
    public var y : Float;
    public var originX : Float = 0;
    public var originY : Float = 0;
    public var rotation : Float = 0;
    public var scaleX : Float = 1;
    public var scaleY : Float = 1;
    public var vertices(get, default) : Float32Array = new Float32Array(SPRITE_SIZE);

    
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
    
}