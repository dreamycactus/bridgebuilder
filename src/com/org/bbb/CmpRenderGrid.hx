package com.org.bbb;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import flash.display.Stage;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author 
 */
class CmpRenderGrid extends CmpRender
{

    public function new(stage : Stage, cmpGrid : CmpGrid) 
    {
        super(stage);
        this.cmpGrid = cmpGrid;
        this.sprite = new Sprite();
    }

    override public function render(dt : Float) : Void
    {
        var g = sprite.graphics;
        var cellsz = cmpGrid.cellSize;
        var w = Lib.current.stage.stageWidth;
        var h = Lib.current.stage.stageHeight;
        
        g.clear();
        g.lineStyle(lineThickness, lineColour, lineAlpha);
        g.beginFill(0xFFFFFF, 1.0);
        for (x in 0...cmpGrid.columns) {
            g.moveTo(x * cellsz, 0);
            g.lineTo(x * cellsz, h);      
        }
        
        for (y in 0...cmpGrid.rows) {
            g.moveTo(0, y * cellsz);
            g.lineTo(w, y * cellsz);
        }
        g.endFill();
    }
    
    var cmpGrid : CmpGrid;
    var lineColour : Int = 0xFFFFFF;
    var lineAlpha : Float = 0.3;
    var lineThickness : Float = 0.5;
    

}