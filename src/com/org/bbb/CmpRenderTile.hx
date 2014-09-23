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

    public function new(bitmap : Bitmap)
    {
        super();
       
        sprite.addChild(bitmap);
    }
    
    override public function render(dt : Float) : Void 
    {
        var ct = entity.getCmp(CmpTransform);

        Util.rotateSprite(sprite, Vec2.get(sprite.x+sprite.width, sprite.y+sprite.height), ct.rot );
        sprite.x = ct.pos.x;
        sprite.y = ct.pos.y;
    }
}