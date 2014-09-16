package com.org.bbb;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.geom.Vec3;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.Compound;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Point;

using Lambda;

class Util
{
    public static var space : Space;
    
    public static function init(sp : Space)
    {
        space = sp;
    }
    
    public static function randomf(min : Float, max : Float) : Float
    {
        return Math.random() * (max - min) + min;
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
    
    public static function clampf(v : Float, min : Float, max : Float) : Float
    {
        if (min > max) {
            return clampf(v, max, min);
        }
        if (v < min) {
            v = min;
        } else if (v > max) {
            v = max;
        }
        return v;
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
    
    public static function closestBodyToPoint(space : Space, point : Vec2
                                            , interactionFilter : InteractionFilter = null
                                            , fastExit : Bool = true
                                            , minSearchWidth : Float = -1
                                            , maxSearchWidth : Float = 40) : BodyList
    {
        var blist : BodyList = minSearchWidth > 0 ? new BodyList() :  space.bodiesUnderPoint(point, interactionFilter);
        var i = 1;
        var iterations = 10;
        var stepWidth = (maxSearchWidth - minSearchWidth) / iterations;
        
        while (blist.length == 0 || !fastExit) {
            if (i++ >= iterations) {
                break;
            }
            var dd = minSearchWidth + i * stepWidth;
            var r = new AABB(point.x - dd, point.y - dd, 2 * dd, 2 * dd);
            blist = (space.bodiesInAABB(r, false, true, interactionFilter) );
        }
        return blist;
    }
    
    public static function add(v : Vec3, v2 : Vec3) {
        return Vec3.get(v.x + v2.x, v.y + v2.y, v.z + v2.z);
    }
    
    public static function mul(v : Vec3, scale : Float) {
        return Vec3.get(v.x * scale, v.y * scale, v.z * scale);
    }
    
    public static function calculateBeamStress(body : Body) : Vec3
    {
        var totalStressAtCenter : Vec3 = Vec3.get();
        
        if (body == null) {
            trace("Calculate stress... body null!" + body.id);
        }
        var count : Int = 0;

        body.constraints.foreach(function(cons) {
            var pj : PivotJoint = cast(cons);
            var anchor : Vec2 = null;
            if (pj.body1 == body) {
                anchor = pj.anchor1;
            } else if (pj.body2 == body) {
                anchor = pj.anchor2;
            }
            if (anchor != null && anchor.x >= 0) {
                var imp = pj.bodyImpulse(body);
                totalStressAtCenter = add(totalStressAtCenter, imp );
                ++count;
            }
            
        });
        
        var loc = body.worldVectorToLocal(totalStressAtCenter.xy());
        if (body.worldVectorToLocal(Vec2.weak(0, 1)).y < 0) {
            loc.y *= -1;
        }
        return Vec3.get(loc.x, loc.y, totalStressAtCenter.z);
    }
    
    public static function zoomInAtPoint(sprite : Sprite, x : Float, y : Float , scale : Float)
    {
        var mat = new Matrix();
        mat.translate(-x,-y);
        mat.scale(scale,scale);
        mat.translate(x,y);
        sprite.transform.matrix=mat;
        
    }
    // Bubble sort.. Insert sort would be better, prolly... maybe... not sure.
    public static function sortZ (dParent : DisplayObjectContainer) : Void {
        for (i in dParent.numChildren - 1...0) {
            
            var bFlipped = false;
            for (o in 0...i) {
                if (dParent.getChildAt(o).z > dParent.getChildAt(o+1).z) {
                    dParent.swapChildrenAt(o,o+1);
                    bFlipped = true;
                }
            }
            if (!bFlipped)
                return;
        }
    }
    
    public static function rotateSprite(sp : DisplayObject, point : Vec2, angle : Float)
    {
        var mat = sp.transform.matrix;
        mat.tx -= point.x;
        mat.ty -= point.y;
        mat.rotate(angle);
        mat.tx += point.x;
        mat.ty += point.y;
        sp.transform.matrix = mat;
    }
}