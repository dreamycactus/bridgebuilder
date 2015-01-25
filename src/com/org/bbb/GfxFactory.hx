package com.org.bbb;
import com.org.bbb.render.CmpRenderMultiBeam.BodyBitmap;
import nape.geom.Vec2;
import nape.phys.Compound;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import spritesheet.importers.BitmapImporter;

/**
 * ...
 * @author 
 */
class GfxFactory
{
    public static var inst(get_inst, null) : GfxFactory; // Forgive me..
    static var instance : GfxFactory;
    
    public static function get_inst() 
    {
        if (instance == null) {
            instance = new GfxFactory();
        }
        return inst;
    }
    
    public function new() 
    {
        if (instance != null) {
            throw "Only one...... QQ";
        }
        inst = this;
    }
    
    public function createBeamBitmap(assetPath : String, length : Float) : Bitmap
    {
        var bd = Assets.getBitmapData(assetPath);
        var ss = BitmapImporter.create(bd, 1, 1, 50, 20);
        var srcbd = ss.getFrame(0).bitmapData;
        var bd = new BitmapData(Std.int(length), srcbd.height);
        var count : Int = Std.int(length / srcbd.width) + 1;
        for (i in 0...count) {
            bd.copyPixels(srcbd, new Rectangle(0, 0, srcbd.width, srcbd.height), new Point(i * srcbd.width, 0));
        }
        var bitmap = new Bitmap(bd, PixelSnapping.ALWAYS, true);
        return bitmap;
    }
    
    public function breakBeamBitmap(compound : Compound, srcBit : Bitmap) : Array<BodyBitmap>
    {
        var ret : Array<BodyBitmap> = new Array();
        if (compound == null || compound.bodies.length == 0) { return ret; }
        
        var pointx = 0.0;
        compound.bodies.foreach(function (b) {
            var bitmap = new Bitmap(srcBit.bitmapData, PixelSnapping.ALWAYS, true);
            bitmap.scrollRect = new Rectangle(pointx, 0, b.userData.width, b.userData.height);
            pointx += b.userData.width;
            ret.push({body : b, bitmap : bitmap});
        });
        return ret;
        
    }
    
    
    
}