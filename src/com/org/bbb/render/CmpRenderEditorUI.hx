package com.org.bbb.render ;
import com.org.bbb.control.CmpControlBuild;
import com.org.bbb.editor.CmpControlEditor;
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
    
    public function new(editor : CmpControlEditor, width : Float, height : Float ) 
    {
        super(false);
        this.displayLayer = GameConfig.zRenderControlUI;
        this.editor = editor;
        this.width = width;
        this.height = height;
        this.editor = editor;

    }
    
    override public function addToScene(scene : DisplayObjectContainer, index : Int) : Void 
    {
        super.addToScene(scene, index);
        uiBuild = UIBuilder.buildFn('data/ui/uiLevelEditor.xml');
        if (uiInstance == null) {
            uiInstance = uiBuild( {
                editor : editor
            });
        }
        sprite.addChild(uiInstance);
        
        var rw = UIBuilder.get('rootEdWidget');
        rw.resize(width, height, true);
        

        
    }
    
    override public function removeFromScene(scene : DisplayObjectContainer) : Void 
    {
        super.removeFromScene(scene);
        if (uiInstance.parent == sprite) {
            sprite.removeChild(uiInstance);
            var rw = UIBuilder.get('rootEdWidget');
            if (rw != null) {
                rw.free(true);
            }
        }
    }
}