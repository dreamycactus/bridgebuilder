package com.org.bbb;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import flash.display.Sprite;

/**
 * ...
 * @author 
 */
class CmpRenderGrid implements Cmp implements CmpRender
{
    public var entity : Entity;
    public var gridSprite : Sprite;

    public function new(cmpGrid : CmpGrid) 
    {
        this.gridSprite = new Sprite();
        this.cmpGrid = cmpGrid;
    }
   
    public function update() : Void
    {
    }
    public function render(dt : Float) : Void
    {
        var g = gridSprite.graphics;
        var cellsz = cmpGrid.cellSize;
        
        g.clear();
        g.lineStyle(lineThickness, lineColour, lineAlpha);
        g.beginFill(0xFFFFFF, 1.0);
        
        for (x in 0...cmpGrid.columns) {
            g.moveTo(x * cellsz, 0);
            g.lineTo(x * cellsz, 600);      
        }
        
        for (y in 0...cmpGrid.rows) {
            g.moveTo(0, y * cellsz);
            g.lineTo(800, y * cellsz);
        }
        g.endFill();
    }
    
    var cmpGrid : CmpGrid;
    var lineColour : Int = 0xFFFFFF;
    var lineAlpha : Float = 0.3;
    var lineThickness : Float = 0.5;
    
}