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
    public var isUnlocked : Bool = false;
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
        //pos.x = sprite.transform.matrix.tx;
        //pos.y = sprite.transform.matrix.ty;
        sprite.x = pos.x;
        sprite.y = pos.y;
        clampPos();
        //sprite.x = pos.x;
        //sprite.y = pos.y;
        
        //sprite.transform.matrix.tx = pos.x;
        //sprite.transform.matrix.ty = pos.y;
    }
    
    public function dragCamera(delta : Vec2)
    {
        if (delta.length > 20) {
            delta = delta.normalise().mul(20);
        }
        pos.addeq(delta);
        clampPos();
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
        if (dragBounds != null && !isUnlocked) {
            zoom = Util.clampf(z, Math.max(GameConfig.stageWidth / dragBounds.width, GameConfig.stageHeight / dragBounds.height)
                                , Math.min(GameConfig.stageWidth/200, GameConfig.stageHeight/200));
        }
        if (sprite != null) {
            sprite.zoomInAtPoint(pos.x, pos.y, zoom);
        }
        return z;
    }
    
    public function set_dragBounds(db : Bounds ) : Bounds
    {
        this.dragBounds = db;
        zoom = zoom;
        return db;
    }
    
    function clampPos()
    {
        if (dragBounds != null && !isUnlocked) {
            var elasticBorder = 0; // GameConfig.cameraElasticEdge * dragBounds.width;
            pos.x = Util.clampf(pos.x, -Math.abs(dragBounds.width*zoom - GameConfig.stageWidth),0);
            pos.y = Util.clampf(pos.y, -Math.abs(dragBounds.height*zoom - GameConfig.stageHeight), 0);
        }
    }
    
}