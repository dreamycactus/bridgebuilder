package com.org.bbb;
import com.org.mes.Cmp;
import flash.display.Stage;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import ru.stablex.ui.UIBuilder;

/**
 * ...
 * @author 
 */
class CmpRenderBuildControl extends CmpRender
{
    var buildControl : CmpControlBuild;
    var scene:DisplayObjectContainer;
    
    public function new(stage : Stage, buildControl : CmpControlBuild) 
    {
        super(stage);
        this.buildControl = buildControl;
        this.sprite = new Sprite();
        
                UIBuilder.regClass('CmpControlBuild');
        UIBuilder.regClass('Config');
        
        stage.addChild(UIBuilder.buildFn('data/test.xml')( {
            controlBuild : buildControl
        }) );
    }
    
    
    override public function render(dt : Float) : Void
    {
        var g = sprite.graphics;
            
        g.clear();
        if (buildControl.isDrawing) {

            g.lineStyle(1, 0xFF0088, 0.6);
            g.beginFill(0xFFFFFF, 1.0);
        
            g.moveTo(buildControl.spawn1.x, buildControl.spawn1.y);
            g.lineTo(stage.mouseX, stage.mouseY);    
            g.endFill();
        }
    }
    
    override public function addToScene(scene : DisplayObjectContainer) : Void 
    {
        super.addToScene(scene);
    }
    
    override public function removeFromScene(scene : DisplayObjectContainer) : Void 
    {
        super.removeFromScene(scene);
        
    }
}