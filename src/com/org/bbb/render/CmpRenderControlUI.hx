package com.org.bbb.render ;
import com.org.bbb.control.CmpControlBuild;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.widgets.WControlBar;
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
        this.displayLayer = GameConfig.zRenderControlUI;
        this.buildControl = buildControl;
        this.level = level;
        this.width = width;
        this.height = height;
    }
    
    override public function addToScene(scene : DisplayObjectContainer, index : Int) : Void 
    {
        super.addToScene(scene, index);
        var rw = UIBuilder.get('rootWidget');
        
        if (rw != null) {
            rw.free(true);
        }
        UIBuilder.regClass('com.org.bbb.widgets.WControlBar');
        UIBuilder.regClass('CmpControlBuild');
        UIBuilder.regClass('GameConfig');
        UIBuilder.regClass('com.org.bbb.widgets.WBottomBar');
        UIBuilder.regClass('com.org.bbb.widgets.WSideBar');
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
        super.removeFromScene(scene);
        if (uiInstance.parent == sprite) {
            sprite.removeChild(uiInstance);
            var rw = UIBuilder.get('rootWidget');
            if (rw != null) {
                rw.free(true);
            }
        }
    }
}