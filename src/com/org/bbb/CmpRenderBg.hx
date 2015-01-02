package com.org.bbb;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import openfl.display.Sprite;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;
import spritesheet.Spritesheet;
import spritesheet.AnimatedSprite;

class CmpRenderBg extends CmpRender
{
    public var parallaxK : Float;
    public var width : Float;
    public var height : Float;
    public var depth : Float;
    public var numLayers : Float;
    public var pos : Vec2;
    public var animated: AnimatedSprite;

    var camPos : Vec2;

    public function new(bmpDat, pos : Vec2, w : Int, h : Int, parallaxK : Float) {
        super(true);
        this.pos = pos;
        this.parallaxK = parallaxK;
        this.width = w;
        this.height = h;
        subscriptions = [Msgs.CAMERAMOVE];
        displayLayer = GameConfig.zBG;

        camPos = Vec2.get();

        var bgSpritesheet = BitmapImporter.create(bmpDat, 1, 1, w, h);
        bgSpritesheet.addBehavior(new BehaviorData("idle", [0], true, 1, 0, 0));
        animated = new AnimatedSprite(bgSpritesheet, true); // FIXME this _probably_ doesn't need to be a an animatedsprite???
        animated.x = pos.x;
        animated.y = pos.y;
        animated.showBehavior("idle");

        sprite.addChild(animated);
    }

    override public function render(dt : Float) : Void
    {
        animated.update(Math.round(dt));
    }

    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        camPos = options.camPos;
        sprite.x = camPos.x * (parallaxK - 1);
        sprite.y = camPos.y * (parallaxK - 1);
    }
}
