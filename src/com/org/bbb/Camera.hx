package com.org.bbb;
import nape.geom.Vec2;
import openfl.display.Sprite;
using com.org.bbb.Util;
/**
 * ...
 * @author 
 */
class Camera
{
    public var mainSprite : Sprite;
    public var targetZoom : Float;
    public var zoom : Float;
    public var pos : Vec2;
    public var vel : Vec2;

    public function new() 
    {
        pos = Vec2.get();
        vel = Vec2.get();
        zoom = 1.0;
        targetZoom = 1.0;
        this.mainSprite = new Sprite();
    }
    
    public function update()
    {
        mainSprite.zoomInAtPoint(pos.x , pos.y, zoom);
        mainSprite.x = pos.x;
        mainSprite.y = pos.y;
        
        //mainSprite.transform.matrix.tx = pos.x;
        //mainSprite.transform.matrix.ty = pos.y;
    }
    
    public function screenToWorld(v : Vec2) : Vec2
    {
        return v.mul(1.0 / zoom, true).sub(pos);
    }
    
    public function worldToScreen(v : Vec2) : Vec2
    {
        return v.mul(zoom).add(pos);
    }
    
    
}