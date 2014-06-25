package com.org.bbb;
import com.org.mes.Cmp;
import flash.display.Stage;
import openfl.display.Sprite;

/**
 * ...
 * @author 
 */
class CmpRenderBuildControl extends CmpRender
{
    var buildControl : CmpBuildControl;
    
    public function new(stage : Stage, buildControl : CmpBuildControl) 
    {
        super(stage);
        this.buildControl = buildControl;
        this.sprite = new Sprite();
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
}