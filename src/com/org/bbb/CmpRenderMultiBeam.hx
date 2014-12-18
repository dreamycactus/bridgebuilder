package com.org.bbb;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;

/**
 * ...
 * @author 
 */
typedef BodyBitmap = { body : Body, bitmap : Bitmap };

class CmpRenderMultiBeam extends CmpRender
{
    public var pairs : Array<BodyBitmap>;
    public var offset : Vec2;
    
    public function new(pairs : Array<BodyBitmap>, offset : Vec2=null) 
    {
        super();
        displayLayer = GameConfig.zBeam;
        this.pairs = pairs;
        if (offset == null) {
            offset = Vec2.get();
        }
        this.offset = offset;
        for (b in pairs) {
            sprite.addChild(b.bitmap);
        }
        render(0);
    }
    
    // More like update...
    override public function render(dt : Float) : Void 
    {
        for (p in pairs) {
            Util.rotateSprite(p.bitmap, Vec2.get(p.bitmap.x + p.bitmap.width, p.bitmap.y + p.bitmap.height), p.body.rotation);
            var w = p.body.userData.width;
            var h = p.body.userData.height;
            var pos = p.body.localPointToWorld( offset.add(Vec2.weak( -w * 0.5, -h * 0.5),true) );
            p.bitmap.x = pos.x;
            p.bitmap.y = pos.y;
        }
    }
}