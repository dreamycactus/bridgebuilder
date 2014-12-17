package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

using com.org.bbb.Util;

class CmpRenderCable extends CmpRender
{
    var sprites : Array<Sprite> = new Array();
    var cmpCable : CmpCable;
    var bitmap  :Bitmap;
    public function new(cmpCable : CmpCable, bitmap : Bitmap)
    {
        super(true);
        this.cmpCable = cmpCable;
        this.bitmap = bitmap;
        subscriptions = [Msgs.CABLEUPDATE, Msgs.CABLECREATE];
        
    }
    
    public function cableCreate() : Void
    {
        for (seg in cmpCable.compound.bodies) {
            var s = new Sprite();
            var tbit = new Bitmap(bitmap.bitmapData);
            s.addChild(tbit);
            sprite.addChild(s);
        }
    }
    
    public function updateGraphics() : Void
    {
        for (i in 0...cmpCable.compound.bodies.length) {
            var seg = cmpCable.compound.bodies.at(i);
            var s = cast(sprite.getChildAt(i), Sprite);
            var area = seg.shapes.at(0).castPolygon.area;
            var w = area / cmpCable.material.height;
            var h = cmpCable.material.height;
            
            var halfDim = Vec2.get(w * 0.5, h * 0.5);
            var topLeft = seg.position.sub(halfDim);
            var tbit = cast(s.getChildAt(0), Bitmap);
            tbit.scrollRect = new Rectangle(0, 0, halfDim.x * 2, halfDim.y * 2);
            //tbit.width = halfDim.x * 2;
            //tbit.height = halfDim.y * 2;
            tbit.x = topLeft.x;
            tbit.y = topLeft.y;
            
            //var g = s.graphics;
            //g.beginFill(0xFFFFFF);
            //g.drawRect(topLeft.x, topLeft.y, w, h);
            //g.endFill();
            s.rotateSprite(topLeft.add(halfDim), seg.rotation);
            halfDim.dispose();
        }
    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        switch(msgType) {
        case Msgs.CABLECREATE:
            cableCreate();
        case Msgs.CABLEUPDATE:
            updateGraphics();
        }
    }
    
}