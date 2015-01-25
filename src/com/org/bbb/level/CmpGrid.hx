package com.org.bbb.level ;
import com.org.mes.Cmp;
import com.org.mes.Entity;
import haxe.ds.IntMap;
import nape.geom.Vec2;
import openfl.Lib;

class CmpGrid extends Cmp
{
    public var cellSize : Int;
    public var cellCounts : Array<Int>;
    public var width : Float;
    public var height : Float;
    public var offset : Vec2;
    var ents : IntMap<Entity>;
    
    public var columns(get_columns, null) : Int;
    public var rows(get_rows, null) : Int;
    
    public function new(w : Float, h : Float, cellSize : Int, cellCounts : Array<Int>=null ) 
    {
        super();
        this.cellSize = cellSize;
        this.cellCounts = cellCounts;
        this.ents = new IntMap();
        this.width = w;
        this.height = h;
        this.offset = Vec2.get();
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
    
    public function lengthOfCells(numCells) : Float
    {
        return numCells * cellSize;
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
    
    public function getClosestCellPos(v : Vec2) : Vec2
    {
        var res = getClosestCell(v);
        return getCellPos(res.x, res.y);
    }
    
    public function getCellPos(x : Int, y : Int) : Vec2
    {
        return Vec2.get(x, y).mul(cellSize).add( Vec2.weak(cellSize * 0.5, cellSize * 0.5) );
    }
    
    function get_columns() { return cast(width / cellSize + 1, Int); }
    function get_rows() { return cast(height / cellSize + 1, Int); }
}