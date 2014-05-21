package com.org.bbb;
import com.org.mes.Entity;
import goodies.Func;
import haxe.ds.IntMap;
import nape.geom.Vec2;

class Grid
{
    var cellSize : Int;
    var cellCounts : Array<Int>;
    var ents : IntMap<Entity>;
    
    public var columns = 100;
    public var rows = 100;
    
    public function new(cellSize : Int, cellCounts : Array<Int>=null ) 
    {
        this.cellSize = cellSize;
        this.cellCounts = cellCounts;
        this.ents = new IntMap();
    }
    
    public function insertFromPos(v : Vec2) 
    {
        insertAt(Std.int(v.x / cellSize), Std.int(v.y / cellSize) );
    }
    
    public function insertAt(x : Int, y : Int)
    {
        if (ents.exists(x * rows + y) ) {
            trace("Overwriting grid entity at: " + x + ", " + y );
        }
        ents.set(x*columns + y);
    }
    
    public function removeFromPos(v : Vec2)
    {
        removeFrom(Std.int(v.x / cellSize), Std.int(v.y / cellSize) );
    }
    
    public function removeFrom(x : Int, y : Int)
    {
        if ( !ents.remove(x * columns + y) ) {
            trace("No entity to remove from grid: " + x +", " y;
        }
    }
    
    public function getEntityAt(x : Int, y : Int)
    {
        return ents.get(x * rows + y);
    }
    
    public function getEntityFromPos(v : Vec2)
    {
        //return getEntityAt(Std.int(v.x / cellSize), Std.int(v.y / cellSize) );
    }
    
}