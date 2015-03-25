package com.org.bbb.render ;
import com.org.bbb.control.CmpBridgeBuild;
import com.org.bbb.control.CmpControlBuild;
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
    var bridgebuild : CmpBridgeBuild;
    var scene:DisplayObjectContainer;
    
    var stage : Stage;
    
    public function new(stage : Stage, bridgebuild : CmpBridgeBuild) 
    {
        super();
        this.bridgebuild = bridgebuild;
        this.displayLayer = GameConfig.zControlUI;
        this.stage = stage;
    }
    
    
    override public function render(dt : Float) : Void
    {
        var g = sprite.graphics;
            
        g.clear();
        if (bridgebuild.isDrawing && !bridgebuild.beamDeleteMode) {
            g.lineStyle(1, 0xFF0088, 0.6);
            g.beginFill(0xFFFFFF, 1.0);
            
            g.moveTo(bridgebuild.spawn1.x, bridgebuild.spawn1.y);
            var spawn2 = bridgebuild.calculateBeamEnd();
            g.lineTo(spawn2.x, spawn2.y);    
            g.endFill();
        }
    }
}