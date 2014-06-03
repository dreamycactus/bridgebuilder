package com.org.bbb;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.geom.Vec3;
import nape.phys.Body;
import nape.phys.Compound;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class Util
{
    public static var space : Space;
    
    public static function init(sp : Space)
    {
        space = sp;
    }
    
    public static function clampI(v : Int, min : Int, max : Int) : Int
    {
        var res : Int = v;
        if (v > max) {
            res = max;
        } else if (v < min) {
            res = min;
        }
        return res;
    }
    public static function Vec3ToIntString(v : Vec3) : String
    {
        return cast(v.x, Int) + ", " + cast(v.y, Int) + ", " + cast(v.z, Int);
    }
    
    public static function absI(v : Int)
    {
        if ( v < 0 )
            return -v;
        
        return v;
    }
    
    public static function roundDown(num : Int, multiple : Int) : Int
    { 
        if (multiple == 0) 
            return num; 

        var remainder : Int = absI(num) % multiple;
        if (remainder == 0) {
            return num;
        }
        
        return num - remainder;
    }
    
    public static function roundNearest(num : Int, multiple : Int) : Int
    { 
        if (multiple == 0) 
            return num; 

        var remainder : Int = absI(num) % multiple;
        if (remainder == 0) {
            return num;
        }
        
        if (remainder < multiple * 0.5) {
            return num - remainder;
        } else {
            return num + multiple - remainder;
        }
    }
    
    
}