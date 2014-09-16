package com.org.bbb;
import nape.geom.Vec2;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
using com.org.bbb.Util;
/**
 * ...
 * @author 
 */
class Camera
{
    public var sprite : Sprite;
    public var targetZoom : Float;
    @:isVar public var zoom(default, set_zoom) : Float;
    public var pos : Vec2;
    public var vel : Vec2;
    public var dragBounds : { x : Float, y : Float, width : Float, height : Float };

    public function new() 
    {
        pos = Vec2.get();
        vel = Vec2.get();
        zoom = 1.0;
        targetZoom = 1.0;
        this.sprite = new Sprite();
    }
    
    public function update()
    {
        sprite.zoomInAtPoint(sprite.width/2, sprite.height/2, zoom);

        sprite.x = pos.x;
        sprite.y = pos.y;
        
        Util.sortZ(sprite);

        
        //sprite.transform.matrix.tx = pos.x;
        //sprite.transform.matrix.ty = pos.y;
    }
    
    public function dragCamera(delta : Vec2)
    {
        pos.addeq(delta);
        if (dragBounds != null) {
            pos.x = Util.clampf(pos.x, -dragBounds.width*zoom + Config.stageWidth, 0);
            pos.y = Util.clampf(pos.y, -dragBounds.height*zoom + Config.stageHeight, 0);
        }
    }
    
    public function screenToWorld(v : Vec2) : Vec2
    {
        return v.sub(pos).mul(1.0 / zoom);
    }
    
    public function worldToScreen(v : Vec2) : Vec2
    {
        return v.mul(zoom).add(pos);
    }
    
    public function set_zoom(z : Float) : Float
    {
        zoom = z;
        //if (dragBounds != null) {
            //zoom = Util.clampf(z, 1.0, dragBounds.width / Config.stageWidth);
        //}
        return z;
    }
    
}