package com.org.bbb;

/**
 * ...
 * @author 
 */
import com.org.mes.Cmp;
import flash.display.Stage;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.geom.ColorTransform;

class CmpRender extends Cmp
{
    public var sprite : Sprite;
    public var inCamera : Bool;
    public var z(get_z, set_z) : Float;
    
    public function new(inCamera : Bool=true)
    {
        super();
        this.inCamera = inCamera;
        sprite = new Sprite();
    }
    public function render(dt : Float) : Void
    {
        
    }
    
    public function addToScene(scene : DisplayObjectContainer) : Void 
    {
        if (sprite == null) { return; }
        scene.addChild(sprite);
    }
    public function removeFromScene(scene : DisplayObjectContainer) : Void 
    {
        if (sprite == null) { return; }
        scene.removeChild(sprite);
    }
    
    public function tintColour(mr : Float, mg : Float, mb : Float, ma : Float) : Void
    {
        if (sprite != null) {
            var col = new ColorTransform(mr, mg, mb, ma);
            sprite.transform.colorTransform = col;
        }
    }
    
    function get_z() : Float
    {
        return sprite.z;
    }
    function set_z(z : Float) : Float
    {
        this.sprite.z = z;
        return z;
    }
}