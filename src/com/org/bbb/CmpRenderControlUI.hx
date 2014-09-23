package com.org.bbb;
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
    
    public function new(buildControl : CmpControlBuild, width : Float, height : Float ) 
    {
        super(false);
        this.buildControl = buildControl;

        if (uiBuild == null) {
            UIBuilder.regClass('CmpControlBuild');
            UIBuilder.regClass('GameConfig');
            uiBuild = UIBuilder.buildFn('data/ui/uiControlBuild.xml');
            uiInstance = uiBuild({
                controlBuild : buildControl
            });
        }

        sprite.addChild(uiInstance);
        var rw = UIBuilder.get('rootWidget');
        rw.resize(width, height);
    }
    
}