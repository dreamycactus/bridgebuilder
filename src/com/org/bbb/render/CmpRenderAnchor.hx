package com.org.bbb.render ;
import com.org.bbb.physics.CmpAnchor;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;
import openfl.geom.Rectangle;

/**
 * ...
 * @author ...
 */
class CmpRenderAnchor extends CmpRender
{
    var cmpAnchor : CmpAnchor;
    var color = 0xFFFFFF;
    public function new(cmpAnchor : CmpAnchor) 
    {
        super(true);
        this.cmpAnchor = cmpAnchor;
        this.displayLayer = GameConfig.zAnchor;
        if (cmpAnchor.fluid) {
            color = 0x91c2c1;
        }
        var g = sprite.graphics;
        //sprite.filters = [];
        //sprite.cacheAsBitmap = false;
        g.clear();
        g.beginFill(color);
        g.drawRect(cmpAnchor.x, cmpAnchor.y, cmpAnchor.width, cmpAnchor.height);
        g.endFill();
        
        //sprite.cacheAsBitmap = true;
        
    }
    
    override public function render(dt : Float) : Void
    {
    }
    
}