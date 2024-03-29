package com.org.bbb.render ;
import com.org.bbb.systems.SysRender;
import nape.geom.Vec2;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
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
    public var sysRender : SysRender;
    var rect = new Rectangle(0, 0, 1024,576 );
    public function new(sysRender : SysRender) 
    {
        this.sysRender = sysRender;
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
        sprite.sortZ();
        var spos = pos.mul(1/zoom);
        //sprite.scrollRect = new Rectangle( -pos.x, -pos.y, 1024, 576);
        //sprite.scrollRect.x += -pos.x;
        //sprite.scrollRect.y += -pos.y;
        
        sprite.x = pos.x;
        sprite.y = pos.y;
        clampPos();
        
        spos.dispose();
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
        var oldPos = pos.copy();
        pos.addeq(delta);
        clampPos();
        sysRender.sendMsg(Msgs.CAMERAMOVE, null, { camPos:pos.mul(1/zoom) } );
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