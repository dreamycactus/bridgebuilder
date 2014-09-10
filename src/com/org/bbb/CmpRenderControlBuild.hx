package com.org.bbb;
import com.org.mes.Cmp;
import flash.display.Stage;
import haxe.macro.Expr;
import nape.geom.Vec2;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author 
 */
class CmpRenderControlBuild extends CmpRender
{
    var buildControl : CmpControlBuild;
    var scene:DisplayObjectContainer;
    
    var stage : Stage;
    
    public function new(stage : Stage, buildControl : CmpControlBuild) 
    {
        super();
        this.buildControl = buildControl;
        this.stage = stage;
    }
    
    
    override public function render(dt : Float) : Void
    {
        var g = sprite.graphics;
            
        g.clear();
        if (buildControl.isDrawing && !buildControl.editMode) {

            g.lineStyle(1, 0xFF0088, 0.6);
            g.beginFill(0xFFFFFF, 1.0);
            
            g.moveTo(buildControl.spawn1.x, buildControl.spawn1.y);
            var spawn2 = buildControl.calculateBeamEnd();
            g.lineTo(spawn2.x, spawn2.y);    
            g.endFill();
        }
    }
}