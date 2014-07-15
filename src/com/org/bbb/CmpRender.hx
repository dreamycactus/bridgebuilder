package com.org.bbb;

/**
 * ...
 * @author 
 */
import com.org.mes.Cmp;
import flash.display.Stage;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

class CmpRender extends Cmp
{
    public var stage : Stage;
    public var sprite : Sprite;
    
    public function new(stage : Stage)
    {
        super();
        this.stage = stage;
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
}