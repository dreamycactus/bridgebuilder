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
    public var visible : Bool = true;
    public function new(cmpGrid : CmpGrid) 
    {
        super(true);
        this.cmpGrid = cmpGrid;
        displayLayer = GameConfig.zGrid;
        var g = sprite.graphics;
        g.clear();
        if (!visible) { return; }
        var cellsz = cmpGrid.cellSize;
        var w = cmpGrid.width;
        var h = cmpGrid.height;
        var ox = cmpGrid.offset.x - GameConfig.gridCellWidth*0.5;
        var oy = cmpGrid.offset.y - GameConfig.gridCellWidth*0.5;

        g.clear();
        g.beginFill(0xFFFFFF, 1.0);
        for (x in 0...cmpGrid.columns) {
            g.moveTo(x * cellsz + ox, oy);
            g.lineStyle(lineThickness, lineColour, lineAlpha);
            if (x % (cmpGrid.cellCounts[0] - 1) == 0) {
                //continue;
                g.lineStyle(lineThickness * 6, lineColour, lineAlpha);
            }
            g.lineTo(x * cellsz+ox, h+oy);      
        }
        
        for (y in 0...cmpGrid.rows) {
            g.moveTo(ox, y * cellsz + oy);
            g.lineStyle(lineThickness, lineColour, lineAlpha);
            if (y % (cmpGrid.cellCounts[0] - 1) == 0) {
                g.lineStyle(lineThickness * 6, lineColour, lineAlpha);
            }
            g.lineTo(w+ox, y * cellsz+oy);
        }
        g.endFill();
    }

    override public function render(dt : Float) : Void
    {
        
    }
    
    var cmpGrid : CmpGrid;
    var lineColour : Int = 0xFFFFFF;
    var lineAlpha : Float = 0.3;
    var lineThickness : Float = 0.5;

}