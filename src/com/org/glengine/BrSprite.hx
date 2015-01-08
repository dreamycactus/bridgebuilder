package com.org.glengine;
import openfl.utils.Float32Array;

/**
 * ...
 * @author ...
 */
class BrSprite extends TextureRegion implements BrBatchDrawable
{
    static var VERTEX_SIZE = 2 + 2 + 1;
    static var SPRITE_SIZE = 4 * VERTEX_SIZE;

    public var color(default, set) : Int;
    public var x(default, set) : Float = 0;
    public var y(default, set) : Float = 0;
    public var originX(default, set) : Float = 0;
    public var originY(default, set) : Float = 0;
    public var rotation(default, set) : Float = 0;
    public var scaleX(default, set) : Float = 1;
    public var scaleY(default, set) : Float = 1;
    public var vertices(get, never) : Float32Array;
    private var mvertices : Float32Array = new Float32Array(SPRITE_SIZE);

    var dirty : Bool = true;
    
    public var drawLayer : Int = 1;
    
    
    public function new()
    {
        super();
        color = 0xFFFFFF;
    }
    //TODO inline
    public function drawBatched(batch : BrSpriteBatch)
    {
        batch.drawBatched(texture, vertices, 0, vertices.length);
    }
    
    override public function setRegion(u : Float, v : Float, u2 : Float, v2 : Float)
    {
        super.setRegion(u, v, u2, v2);
        mvertices[U1] = u;
        mvertices[V1] = v2;
        
        mvertices[U2] = u;
        mvertices[V2] = v;
        
        mvertices[U3] = u2;
        mvertices[V3] = v;
        
        mvertices[U4] = u2;
        mvertices[V4] = v2;
    }
    
    inline function get_vertices() : Float32Array
    {
        if (dirty) {
            dirty = false;
            var mvertices = this.mvertices;
            var localX = -originX;
            var localY = -originY;
            var localX2 = localX + regionWidth;
            var localY2 = localY + regionHeight;
            var worldOriginX = this.x - localX;
            var worldOriginY = this.y - localY;
            if (scaleX != 1 || scaleY != 1) {
                localX *= scaleX;
                localY *= scaleY;
                localX2 *= scaleX;
                localY2 *= scaleY;
            }
            if (rotation != 0) {
                var cos = Math.cos(rotation);
                var sin = Math.sin(rotation);
                var localXCos = localX * cos;
                var localXSin = localX * sin;
                var localYCos = localY * cos;
                var localYSin = localY * sin;
                var localX2Cos = localX2 * cos;
                var localX2Sin = localX2 * sin;
                var localY2Cos = localY2 * cos;
                var localY2Sin = localY2 * sin;
                
                var x1 = localXCos - localYSin + worldOriginX;
                var y1 = localYCos + localXSin + worldOriginY;
                mvertices[X1] = x1;
                mvertices[Y1] = y1;
                
                var x2 = localX2Cos - localY2Sin + worldOriginX;
                var y2 = localY2Cos + localX2Sin + worldOriginY;
                mvertices[X2] = x2;
                mvertices[Y2] = y2;
                
                var x3 = localX2Cos - localY2Sin + worldOriginX;
                var y3 = localY2Cos + localX2Sin + worldOriginY;
                mvertices[X3] = x3;
                mvertices[Y3] = y3;
                
                mvertices[X4] = x1 + (x3-x2);
                mvertices[Y4] = y3 + (y2-y1);
            } else {
                var x1 = localX + worldOriginX;
                var y1 = localY + worldOriginX;
                var x2 = localX2 + worldOriginX;
                var y2 = localY2 + worldOriginX;
                
                mvertices[X1] = x1;
                mvertices[Y1] = y2;

                mvertices[X2] = x1;
                mvertices[Y2] = y1;

                mvertices[X3] = x2;
                mvertices[Y3] = y1;

                mvertices[X4] = x2;
                mvertices[Y4] = y2;
            }
        }
        return mvertices;
    }
    
    inline function set_color(c : Int) : Int
    {
        this.color = c;
        var col = c;
        mvertices[C1] = col;
        mvertices[C2] = col;
        mvertices[C3] = col;
        mvertices[C4] = col;
        return c;
    }
    
    inline function set_x(x : Float) : Float
    {
        translateX(x - this.x);
        return x;
    }
    inline function set_y(y : Float) : Float
    {
        translateY(y - this.y);
        return y;
    }
    function translateX(dx : Float) {
        x += dx;
        if (dirty) return;
        
        var mvertices = this.mvertices; // there's some error with += operator
        mvertices[X1] = mvertices[X1] + dx;
        mvertices[X2] = mvertices[X2] + dx;
        mvertices[X3] = mvertices[X3] + dx;
        mvertices[X4] = mvertices[X4] + dx;
    }
    inline function translateY(dy : Float) {
        y += dy;
        if (dirty) return;
        
        var mvertices = this.mvertices;
        mvertices[Y1] = mvertices[Y1] + dy;
        mvertices[Y2] = mvertices[Y2] + dy;
        mvertices[Y3] = mvertices[Y3] + dy;
        mvertices[Y4] = mvertices[Y4] + dy;
    }
    inline function set_rotation(r : Float) : Float
    {
        dirty = true;
        this.rotation = r;
        return r;
    }
    inline function set_originX(ox : Float) : Float
    {
        dirty = true;
        this.originX = ox;
        return ox;
    }
    inline function set_originY(oy : Float) : Float
    {
        dirty = true;
        this.originY = oy;
        return oy;
    }
    inline function set_scaleX(sx : Float) : Float
    {
        dirty = true;
        this.scaleX = sx;
        return sx;
    }
    inline function set_scaleY(sy : Float) : Float
    {
        dirty = true;
        this.scaleY = sy;
        return sy;
    }
    
    inline static var X1 : Int = 0;
    inline static var Y1 : Int = 1;
    inline static var U1 : Int = 2;
    inline static var V1 : Int = 3;
    inline static var C1 : Int = 4;
    inline static var X2 : Int = 5;
    inline static var Y2 : Int = 6;
    inline static var U2 : Int = 7;
    inline static var V2 : Int = 8;
    inline static var C2 : Int = 9;
    inline static var X3 : Int = 10;
    inline static var Y3 : Int = 11;
    inline static var U3 : Int = 12;
    inline static var V3 : Int = 13;
    inline static var C3 : Int = 14;
    inline static var X4 : Int = 15;
    inline static var Y4 : Int = 16;
    inline static var U4 : Int = 17;
    inline static var V4 : Int = 18;
    inline static var C4 : Int = 19;
    
}