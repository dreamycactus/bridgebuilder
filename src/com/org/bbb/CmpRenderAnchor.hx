package com.org.bbb;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;

/**
 * ...
 * @author ...
 */
class CmpRenderAnchor extends CmpRender
{
    var cmpAnchor : CmpAnchor;
    public function new(cmpAnchor : CmpAnchor) 
    {
        super(true);
        this.cmpAnchor = cmpAnchor;
        this.displayLayer = GameConfig.zAnchor;
        var g = sprite.graphics;
        //sprite.filters = [];
        //sprite.cacheAsBitmap = false;
        g.clear();
        g.beginFill(0xFFFFFF);
        g.drawRect(cmpAnchor.pos.x, cmpAnchor.pos.y, cmpAnchor.width, cmpAnchor.height);
        g.endFill();
        
    }
    
    override public function render(dt : Float) : Void
    {
    }
    
}