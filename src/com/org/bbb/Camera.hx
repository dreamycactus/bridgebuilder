package com.org.bbb;
import nape.geom.Vec2;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
using com.org.bbb.Util;
/**
 * ...
 * @author 
 */

typedef Bounds = { x : Float, y : Float, width : Float, height : Float };
class Camera
{
    public var sprite : Sprite;
    public var targetZoom : Float;
    @:isVar public var zoom(default, set_zoom) : Float;
    public var pos : Vec2;
    public var vel : Vec2;
    @:isVar public var dragBounds(default, set_dragBounds) : Bounds;

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
        
        //sprite.transform.matrix.tx = pos.x;
        //sprite.transform.matrix.ty = pos.y;
    }
    
    public function dragCamera(delta : Vec2)
    {
        if (delta.length > 20) {
            delta = delta.normalise().mul(20);
        }
        pos.addeq(delta);
        if (dragBounds != null) {
            var elasticBorder = GameConfig.cameraElasticEdge * dragBounds.width;
            pos.x = Util.clampf(pos.x, Math.min(-dragBounds.width / zoom + GameConfig.stageWidth, 0),0);
            pos.y = Util.clampf(pos.y, Math.min(-dragBounds.height / zoom + GameConfig.stageHeight, 0),0);
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
        if (dragBounds != null) {
            zoom = Util.clampf(z, Math.max(GameConfig.stageWidth/dragBounds.width, GameConfig.stageHeight/dragBounds.height), Math.min(GameConfig.stageWidth/500, GameConfig.stageHeight/500));
        }
        return z;
    }
    
    public function set_dragBounds(db : Bounds ) : Bounds
    {
        this.dragBounds = db;
        zoom = zoom;
        return db;
    }
    
}