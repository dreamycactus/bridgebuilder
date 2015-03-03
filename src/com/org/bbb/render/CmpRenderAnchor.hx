package com.org.bbb.render ;
import com.org.bbb.physics.CmpAnchor;
import com.org.mes.Cmp;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;
import openfl.geom.Rectangle;

/**
 * ...
 * @author ...
 */
@editor
class CmpRenderAnchor extends CmpRender
{
    var cmpAnchor : CmpAnchor;
    @editor
    public var color(default, default) = 0xFFFFFF;
    public function new(cmpAnchor : CmpAnchor) 
    {
        super(true);
        subscriptions = [Msgs.ENTMOVE];
        this.cmpAnchor = cmpAnchor;
        this.displayLayer = GameConfig.zAnchor;
        if (cmpAnchor.fluid) {
            color = 0x91c2c1;
        }
        refresh();
        //sprite.cacheAsBitmap = true;
        
    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void 
    {
        switch (msgType) {
        case Msgs.ENTMOVE:
            refreshanchor();
        }
    }

    function refreshanchor()
    {
        var g = sprite.graphics;
        //sprite.filters = [];
        //sprite.cacheAsBitmap = false;
        g.clear();
        g.beginFill(color);
        g.drawRect(cmpAnchor.x, cmpAnchor.y, cmpAnchor.width, cmpAnchor.height);
        g.endFill();
    }
    
    
    
}