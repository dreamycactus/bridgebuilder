package com.org.bbb;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import haxe.ds.IntMap;
import nape.geom.Vec2;
import openfl.Lib;

class CmpGrid extends Cmp
{
    public var cellSize : Int;
    public var cellCounts : Array<Int>;
    var ents : IntMap<Entity>;
    
    public var columns = 30;
    public var rows = 20;
    
    public function new(cellSize : Int, cellCounts : Array<Int>=null ) 
    {
        super();
        this.cellSize = cellSize;
        this.cellCounts = cellCounts;
        this.ents = new IntMap();
        
        columns = Std.int(Lib.current.stage.stageWidth / cellSize) + 1;
        rows = Std.int(Lib.current.stage.stageHeight / cellSize) + 1;
        trace("hel" + columns + rows);
    }
    
    public function insertAt(x : Int, y : Int, e : Entity)
    {
        if (ents.exists(x * rows + y) ) {
            trace("Overwriting grid entity at: " + x + ", " + y );
        }
        ents.set(x*columns + y, e);
    }
    
    public function removeFrom(x : Int, y : Int)
    {
        if ( !ents.remove(x * columns + y) ) {
            trace("No entity to remove from grid: " + x + ", " + y);
        }
    }
    
    public function getEntityAt(x : Int, y : Int) : Entity
    {
        return ents.get(x * rows + y);
    }

    public function getClosestCell(v : Vec2) : { x : Int, y : Int }
    {
        return {  x : Std.int(Util.roundDown(Std.int(v.x), Std.int(cellSize)) / cellSize)
                , y : Std.int(Util.roundDown(Std.int(v.y), Std.int(cellSize)) / cellSize) };
    }
    
    public function getCellPos(x : Int, y : Int) : Vec2
    {
        return Vec2.get(x, y).mul(cellSize).add( Vec2.weak(cellSize * 0.5, cellSize * 0.5) );
    }
    
}