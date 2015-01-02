package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;

// NOTE: this just renders ONE LAYER
class CmpRenderBg extends CmpRender
{
    public var parallaxK : Float;
    public var width : Float;
    public var height : Float;
    public var depth : Float;
    public var numLayers : Float;

    var camPos : Vec2;
    var bmp : Bitmap;
    var scrollPos : Vec2;

    public function new(bmpDat, pos : Vec2, w : Int, h : Int, parallaxK : Float) {
        super(true);
        this.parallaxK = parallaxK;
        this.width = w;
        this.height = h;
        subscriptions = [Msgs.CAMERAMOVE];
        displayLayer = GameConfig.zBG;

        camPos = Vec2.get();
        bmp = new Bitmap(bmpDat, PixelSnapping.ALWAYS);

        bmp.x = pos.x;
        bmp.y = pos.y;

        sprite.addChild(bmp);
    }

    override public function render(dt : Float) : Void
    {
    }

    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        camPos = options.camPos;
        sprite.x = camPos.x * (parallaxK - 1);
        sprite.y = camPos.y * (parallaxK - 1);
    }
}
