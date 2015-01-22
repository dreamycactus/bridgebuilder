package com.org.bbb;
import com.org.mes.Cmp;
import nape.dynamics.InteractionFilter;
import nape.geom.AABB;
import nape.geom.IsoFunction;
import nape.geom.MarchingSquares;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.display.BitmapData;

/**
 * ...
 * @author ...
 */
class CmpTerrain extends Cmp #if flash implements IsoFunction #end
{
    public var bitmapData : BitmapData;
    public var cellSize : Float;
    public var subSize : Float;
    public var width : Int;
    public var height : Int;
    public var cells : Array<Body>;
    public var isoBounds : AABB;
    public var isoGranularity : Vec2;
    public var isoQuality : Int = 4;
    
    public function new(bitmapData : BitmapData, cellSize : Float, subSize : Float) 
    {
        super();
        this.bitmapData = bitmapData;
        this.cellSize = cellSize;
        this.subSize = subSize;
        
        cells = [];
        width = Math.ceil(bitmapData.width / cellSize);
        height = Math.ceil(bitmapData.height / cellSize);
        for (i in 0...width * height) cells.push(null);
        
        isoBounds = new AABB(0, 0, cellSize, cellSize);
        isoGranularity = Vec2.get(subSize, subSize);
    }
    
    public function invalidate(region:AABB, space:Space, offset : Vec2) 
    {
        // compute effected cells.
        var x0 = Std.int(region.min.x/cellSize); if(x0<0) x0 = 0;
        var y0 = Std.int(region.min.y/cellSize); if(y0<0) y0 = 0;
        var x1 = Std.int(region.max.x/cellSize); if(x1>= width) x1 = width-1;
        var y1 = Std.int(region.max.y/cellSize); if(y1>=height) y1 = height-1;
 
        for (y in y0...(y1+1)) {
        for (x in x0...(x1+1)) {
            var b = cells[y*width + x];
            if (b != null) {
                // If body exists, we'll simply re-use it.
                b.space = null;
                b.shapes.clear();
            }
 
            isoBounds.x = x*cellSize;
            isoBounds.y = y*cellSize;
            var polys = MarchingSquares.run(
                #if flash 
                    this,
                #else 
                    this.iso,
                #end
                isoBounds,
                isoGranularity,
                isoQuality
            );
            if (polys.empty()) continue;
 
            if (b == null) {
                cells[y*width + x] = b = new Body(BodyType.STATIC);
            }
 
            for (p in polys) {
                var qolys = p.convexDecomposition(true);
                for (q in qolys) {
                    b.shapes.add(new Polygon(q));
 
                    // Recycle GeomPoly and its vertices
                    q.dispose();
                }
 
                // Recycle list nodes
                qolys.clear();
 
                // Recycle GeomPoly and its vertices
                p.dispose();
            }
 
            // Recycle list nodes
            polys.clear();
 
            b.space = space;
            b.setShapeFilters(new InteractionFilter(GameConfig.cgAnchor, GameConfig.cmAnchor));
            b.cbTypes.add(GameConfig.cbGround);
            b.position.addeq(offset);
        }}
    }
    
    public function iso(x:Float, y:Float):Float 
    {
        var ix = Std.int(x); if(ix<0) ix = 0; else if(ix>=bitmapData.width)  ix = bitmapData.width -1;
        var iy = Std.int(y); if(iy<0) iy = 0; else if(iy>=bitmapData.height) iy = bitmapData.height-1;
        var fx = x - ix; if(fx<0) fx = 0; else if(fx>1) fx = 1;
        var fy = y - iy; if(fy<0) fy = 0; else if(fy>1) fy = 1;
        var gx = 1-fx;
        var gy = 1-fy;
 
        var a00 = bitmapData.getPixel32(ix,iy)>>>24;
        var a01 = bitmapData.getPixel32(ix,iy+1)>>>24;
        var a10 = bitmapData.getPixel32(ix+1,iy)>>>24;
        var a11 = bitmapData.getPixel32(ix+1,iy+1)>>>24;
 
        var ret = gx*gy*a00 + fx*gy*a10 + gx*fy*a01 + fx*fy*a11;
        return 0x80-ret;
    }
    
}