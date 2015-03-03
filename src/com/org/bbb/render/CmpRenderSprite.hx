package com.org.bbb.render;
import com.org.bbb.physics.CmpTransform;
import nape.geom.Vec2;
import openfl.Assets;
import openfl.display.Bitmap;

/**
 * ...
 * @author ...
 */
@editor
class CmpRenderSprite extends CmpRender
{
    @editor
    public var src(default, set) : String;

    @editor
    public var offset(default, default) : Vec2 = new Vec2();
        
    @editor
    public var offsetRot(default, default) : Float = 0;
    
    @editor 
    public var scale(default, set) : Float = 1.0;
    
    @editor
    public var width(default, default) : Float = 50;
    
    @editor
    public var height(default, default) : Float = 50;
    
    public var bitmap : Bitmap;
    
    public function new() 
    {
        super(true);
        bitmap = new Bitmap();
        sprite.addChild(bitmap);
    }
    
    override public function render(dt : Float) : Void
    {
        var trans = entity.getCmp(CmpTransform);
        sprite.x = trans.x + offset.x;
        sprite.y = trans.y + offset.y;
    }
    function set_src(path : String) : String    
    {
        if (Assets.exists(path, AssetType.IMAGE)) {
            bitmap.bitmapData = Assets.getBitmapData(path);
            sendMsg(Msgs.DIMCHANGE, this, { w : width, h : height } );
        }
        this.src = path;
        return path;
    } 
    
    function set_scale(s : Float) : Float    
    {
        this.scale = s;
        sprite.scaleX = sprite.scaleY = s;
        return s;
    }    
}