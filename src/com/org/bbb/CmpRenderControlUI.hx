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
    public static var uiBuild : Dynamic -> Widget;
    var buildControl : CmpControlBuild;
    public static var uiInstance : Sprite;
    var width : Float;
    var height : Float;
    
    public function new(buildControl : CmpControlBuild, width : Float, height : Float ) 
    {
        super(false);
        this.buildControl = buildControl;
        this.width = width;
        this.height = height;
    }
    
    override public function addToScene(scene : DisplayObjectContainer) : Void 
    {
        super.addToScene(scene);
        uiBuild = UIBuilder.buildFn('data/ui/uiControlBuild.xml');
            uiInstance = uiBuild({
                controlBuild : buildControl
            });
        sprite.addChild(uiInstance);
        var rw = UIBuilder.get('rootWidget');
        rw.resize(width, height);

    }
    
    override public function removeFromScene(scene : DisplayObjectContainer) : Void 
    {
        super.addToScene(scene);
        sprite.removeChild(uiInstance);
        UIBuilder.get('rootWidget').free(true);
    }
    
}