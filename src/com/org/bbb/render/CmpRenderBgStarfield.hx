package com.org.bbb.render ;
import com.org.mes.Cmp;
import nape.geom.Vec2;
import openfl.filters.GlowFilter;

/**
 * ...
 * @author 
 */
typedef Star = 
{
    pos : Vec2,
    size : Float
};

class CmpRenderBgStarfield extends CmpRender
{
    var stars : List<Star> = new List();
    public var width : Float;
    public var height : Float;
    public function new(count : Int, w : Float, h : Float) 
    {
        super(true);
        width = w;
        height = h;
        subscriptions = [Msgs.CAMERAMOVE];
        displayLayer = GameConfig.zStars;
        for (i in 0...count) {
            stars.add( { pos : Vec2.get(Util.randomf(0, w), Util.randomf(0, h)), size : Util.randomf(0.1, 2) } );
        }
        sprite.filters = [new GlowFilter(0xFFFFFF, 0.8, 6, 6, 2, 1)];
        var g = sprite.graphics;
        g.clear();
        for (s in stars) {
            g.beginFill(0xFFFFFF);
            g.drawCircle(s.pos.x, s.pos.y, s.size);
            g.endFill();
        }
    }
    
    override public function render(dt : Float) : Void
    {

    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void
    {
        var camPos : Vec2 = options.camPos;
        sprite.x = (1 - 1) * camPos.x;
        sprite.y = (1 - 1) * camPos.y;
    }
}