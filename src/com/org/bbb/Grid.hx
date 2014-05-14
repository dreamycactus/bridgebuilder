package com.org.bbb;

/**
 * ...
 * @author 
 */
class Grid
{
    var cellSize : Int;
    var cellCounts : Array<Int>;
    public function new(cellSize : Int, cellCounts : Array<Int>=null ) 
    {
        this.cellSize = cellSize;
        this.cellCounts = cellCounts;
    }
    
}