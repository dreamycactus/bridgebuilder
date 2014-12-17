package com.org.bbb;

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
        sprite.z = GameConfig.zAnchor;
        var g = sprite.graphics;
        g.beginFill(0x333333, 1.0);
        g.drawRect(cmpAnchor.pos.x, cmpAnchor.pos.y, cmpAnchor.width, cmpAnchor.height);
        g.endFill();
        
    }
    
    override public function render(dt : Float) : Void
    {
    }
    
}