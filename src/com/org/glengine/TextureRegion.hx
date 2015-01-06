package com.org.glengine;

/**
 * ...
 * @author ...
 */
class TextureRegion
{
    public var texture : Texture2D;
    public var u(default, null) : Float;
    public var v(default, null) : Float;
    public var u2(default, null) : Float;
    public var v2(default, null) : Float;
    public var regionWidth : Int;
    public var regionHeight : Int;
    
    public function new() 
    {
    }
    
    public function initDim(texture : Texture2D, x : Int, y : Int, width : Float, height : Float)
    {
        this.texture = texture;
        var invTexWidth = 1.0 / texture.width;
        var invTexHeight = 1.0 / texture.height;
        setRegion(x * invTexWidth, y * invTexWidth, (x + width) * invTexWidth, (y + height) * invTexHeight);
    }
    
    public function initUV(texture : Texture2D, u : Float, v : Float, u2 : Float, v2 : Float)
    {
        this.texture = texture;
        setRegion(u, v, u2, v2);
    }
    
    public function setRegion(u : Float, v : Float, u2 : Float, v2 : Float)
    {
        this.u = u;
        this.v = v;
        this.u2 = u2;
        this.v2 = v2;
        
        regionWidth = Std.int(Math.abs(u2 - u) * texture.width);
        regionHeight = Std.int(Math.abs(v2 - v) * texture.height);
    }
    
    public function dispose()
    {
        if (texture != null) { texture.dispose(); }
    }
}