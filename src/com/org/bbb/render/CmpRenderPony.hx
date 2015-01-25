package com.org.bbb.render ;
import openfl._v2.display.Sprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.filters.ColorMatrixFilter;

/**
 * ...
 * @author ...
 */
class CmpRenderPony extends CmpRender
{
    var bitmap : Bitmap = new Bitmap(null);
    var spriteFrame : Sprite = new Sprite();
    public function new() 
    {
        super(true);
        sprite.addChild(bitmap);
        bitmap.bitmapData = Assets.getBitmapData('img/pony.png');
    }
    
    var sourceBD = new BitmapData(1280, 480);
    //override public function render(dt  :  Float)  :  Void
    //{
        //var numSamples = 5;
        //sourceBD.draw(spriteFrame);
        //var colorMat = [1, 0, 0, 0, 0               // R
                       //,0, 1, 0, 0, 0               // G
                       //,0, 0, 1, 0, 0              // B
                       //,0, 0, 0, (1 / numSamples), 0]; // A
        //var filt : ColorMatrixFilter = new ColorMatrixFilter(colorMat);
        //sourceBD.applyFilter(sourceBD, sourceBD.rect, new Point(), filt);
        //
        //var canvas = new BitmapData(displayWidth, displayHeight, true, 0);
        //for (i in 0...numSamples) {
            //canvas.copyPixels(sourceBD, sourceBD.rect, new Point(0, i * 10), null, null, true);
        //}
        //bitmap.bitmapData = canvas;
                       //
    //}
    
}