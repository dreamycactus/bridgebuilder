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
    
    public function new(buildControl : CmpControlBuild) 
    {
        super(false);
        this.buildControl = buildControl;

        if (uiBuild == null) {
            UIBuilder.regClass('CmpControlBuild');
            UIBuilder.regClass('Config');
            uiBuild = UIBuilder.buildFn('data/ui/uiControlBuild.xml');
            uiInstance = uiBuild({
                controlBuild : buildControl
            });
        }

        sprite.addChild(uiInstance);
    }
    
}