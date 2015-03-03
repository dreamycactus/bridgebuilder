package com.org.bbb.render ;

/**
 * ...
 * @author 
 */
import com.org.bbb.systems.SysRender;
import com.org.mes.Cmp;
import flash.display.Stage;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.geom.ColorTransform;

@editor
class CmpRender extends Cmp
{
    public var sprite : Sprite;
    @editor
    public var inCamera(default, set) : Bool;
    @editor
    public var displayLayer(default, set) : Int;
    
    public function new(inCamera : Bool=true)
    {
        super();
        sprite = new Sprite();

        this.inCamera = inCamera;
    }
    public function render(dt : Float) : Void {}
    
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
    
    function refresh() 
    {
        if (entity != null) {
            var sys = entity.state.getSystem(SysRender);
            sys.removed(entity);
            sys.inserted(entity);
        }
    }
    
    function set_displayLayer(value:Int):Int 
    {
        displayLayer = value;
        //refresh();
        return value;
    }
    
    function set_inCamera(value:Bool):Bool 
    {
        if (value != inCamera) {
            //refresh();
        }
        return inCamera = value;
    }

}