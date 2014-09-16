package com.org.bbb;
import nape.geom.Vec2;
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

class CmpRenderTile extends CmpRender
{

    public function new(assetPath : String, length : Float) 
    {
        super();
        var bd = Assets.getBitmapData(assetPath);
        var ss = BitmapImporter.create(bd, 1, 1, 50, 20);
        var srcbd = ss.getFrame(0).bitmapData;
        var bd = new BitmapData(Std.int(length), srcbd.height);
        var count : Int = Std.int(length / srcbd.width) + 1;
        for (i in 0...count) {
            bd.copyPixels(srcbd, new Rectangle(0, 0, srcbd.width, srcbd.height), new Point(i * srcbd.width, 0));
        }
        var bitmap = new Bitmap(bd,PixelSnapping.ALWAYS,true);
        sprite.addChild(bitmap);
    }
    
    override public function render(dt : Float) : Void 
    {
        var ct = entity.getCmp(CmpTransform);

        Util.rotateSprite(sprite, Vec2.get(sprite.x+sprite.width, sprite.y+sprite.height), ct.rot - lastRot);
        sprite.x = ct.pos.x;
        sprite.y = ct.pos.y;
        lastRot = ct.rot;
    }
    
    var lastRot : Float = 0;
}