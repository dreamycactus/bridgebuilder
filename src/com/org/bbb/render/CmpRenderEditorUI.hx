package com.org.bbb.render ;
import com.org.bbb.control.CmpControlBuild;
import com.org.bbb.editor.CmpControlEditor;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.widgets.MyInputText;
import com.org.bbb.widgets.WControlBar;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author 
 */
class CmpRenderEditorUI extends CmpRender
{
    public var uiBuild : Dynamic -> Widget;
    public var uiInstance : Sprite;
    public var editor : CmpControlEditor;
    var width : Float;
    var height : Float;
    var level : CmpLevel;
    
    public function new(editor : CmpControlEditor, level : CmpLevel, width : Float, height : Float ) 
    {
        super(false);
        this.displayLayer = GameConfig.zRenderControlUI;
        this.level = level;
        this.editor = editor;
        this.width = width;
        this.height = height;
        this.editor = editor;

    }
    
    override public function addToScene(scene : DisplayObjectContainer, index : Int) : Void 
    {
        super.addToScene(scene, index);
        UIBuilder.saveCodeTo('.');
        uiBuild = UIBuilder.buildFn('data/ui/uiLevelEditor.xml');
        uiInstance = uiBuild( {
            editor : editor
        });
        sprite.addChild(uiInstance);
        
        var rw = UIBuilder.get('rootWidget');
        rw.resize(width, height, true);
        

        
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