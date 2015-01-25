package com.org.bbb.render ;

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
    public var displayLayer : Int;
    
    public function new(inCamera : Bool=true)
    {
        super();
        this.inCamera = inCamera;
        sprite = new Sprite();
    }
    public function render(dt : Float) : Void
    {
        
    }
    
    public function addToScene(scene : DisplayObjectContainer, index : Int) : Void 
    {
        if (sprite == null) { return; }
        scene.addChildAt(sprite, index);
    }
    public function removeFromScene(scene : DisplayObjectContainer) : Void 
    {
        if (sprite == null) { return; }
        scene.removeChild(sprite);
    }
    
    public function tintColour(mr : Float, mg : Float, mb : Float, ma : Float) : Void
    {
        if (sprite != null) {
            var col = new ColorTransform(mr/255, mg/255, mb/255, ma/255);
            sprite.transform.colorTransform = col;
        }
    }
}