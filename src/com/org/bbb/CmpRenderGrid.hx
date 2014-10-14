package com.org.bbb;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import flash.display.Stage;
import nape.geom.Vec2;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author 
 */
class CmpRenderGrid extends CmpRender
{
    public function new(cmpGrid : CmpGrid) 
    {
        super();
        this.cmpGrid = cmpGrid;
    }

    override public function render(dt : Float) : Void
    {
        var g = sprite.graphics;
        g.clear();
        var cellsz = cmpGrid.cellSize;
        var w = cmpGrid.width;
        var h = cmpGrid.height;
        var ox = cmpGrid.offset.x;
        var oy = cmpGrid.offset.y;

        g.clear();
        g.lineStyle(lineThickness, lineColour, lineAlpha);
        g.beginFill(0xFFFFFF, 1.0);
        for (x in 0...cmpGrid.columns) {
            g.moveTo(x * cellsz+ox, oy);
            g.lineTo(x * cellsz+ox, h+oy);      
        }
        
        for (y in 0...cmpGrid.rows) {
            g.moveTo(ox, y * cellsz+oy);
            g.lineTo(w+ox, y * cellsz+oy);
        }
        g.endFill();
    }
    
    var cmpGrid : CmpGrid;
    var lineColour : Int = 0xFFFFFF;
    var lineAlpha : Float = 0.3;
    var lineThickness : Float = 0.5;

}