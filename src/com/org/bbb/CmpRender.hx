package com.org.bbb;

/**
 * ...
 * @author 
 */
import com.org.mes.Cmp;
import flash.display.Stage;
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
    
    public function addToScene() : Void 
    {
        if (sprite == null) { return; }
        stage.addChild(sprite);
    }
    public function removeFromScene() : Void 
    {
        if (sprite == null) { return; }
        stage.removeChild(sprite);
    }
}