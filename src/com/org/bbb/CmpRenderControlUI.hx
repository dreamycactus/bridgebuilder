package com.org.bbb;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author 
 */
class CmpRenderControlUI extends CmpRender
{
    public var uiBuild : Dynamic -> Widget;
    var buildControl : CmpControlBuild;
    public var uiInstance : Sprite;
    var width : Float;
    var height : Float;
    var level : CmpLevel;
    
    public function new(buildControl : CmpControlBuild, level : CmpLevel, width : Float, height : Float ) 
    {
        super(false);
        this.buildControl = buildControl;
        this.level = level;
        this.width = width;
        this.height = height;
    }
    
    override public function addToScene(scene : DisplayObjectContainer) : Void 
    {
        super.addToScene(scene);
        var rw = UIBuilder.get('rootWidget');
        
        if (rw != null) {
            rw.free(true);
        }
        uiBuild = UIBuilder.buildFn('data/ui/uiControlBuild.xml');
        uiInstance = uiBuild({
            controlBuild : buildControl
        });
        sprite.addChild(uiInstance);
        var rw = UIBuilder.get('rootWidget');
        rw.resize(width, height, true);
        
        var cb = cast(UIBuilder.get('controlbar'), WControlBar);
        cb.addMaterialButtons(level.materialsAllowed);

    }
    
    override public function removeFromScene(scene : DisplayObjectContainer) : Void 
    {
        super.addToScene(scene);
        if (uiInstance.parent == sprite) {
            sprite.removeChild(uiInstance);
            var rw = UIBuilder.get('rootWidget');
            if (rw != null) {
                rw.free(true);
            }
        }
    }
}