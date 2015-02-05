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
    public static var EPSILON : Float = 1e-4;
    
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
    
    
    public static function bodySameId(b1 : Body, b2 : Body) : Bool { return b1.id == b2.id; }
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
    
    public static function addeq(v : Vec3, v2 : Vec3) {
        v.x += v2.x;
        v.y += v2.y;
        v.z += v2.z;
        return v;
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
        body.constraints.foreach(addForceOnLeft.bind(body, totalStressAtCenter));
        
        var loc = body.worldVectorToLocal(totalStressAtCenter.xy());
        if (body.worldVectorToLocal(Vec2.weak(0, 1)).y < 0) {
            loc.y *= -1;
        }
        return Vec3.get(loc.x, loc.y, totalStressAtCenter.z);
    }
    
    static function addForceOnLeft(body: Body, totalStressAtCenter : Vec3, cons:Constraint) 
    {
        var pj : PivotJoint = cast(cons);
        var anchor : Vec2 = null;
        if (pj.body1 == body) {
            anchor = pj.anchor1;
        } else if (pj.body2 == body) {
            anchor = pj.anchor2;
        }
        if (anchor != null && anchor.x >= 0) {
            var imp = pj.bodyImpulse(body);
            var bounds = body.bounds;
            addeq(totalStressAtCenter, imp );
        }
        
    }
    
    public static function zoomInAtPoint(sprite : Sprite, x : Float, y : Float , scale : Float)
    {
        var mat = new Matrix();
        mat.translate(-x,-y);
        mat.scale(scale,scale);
        mat.translate(x,y);
        sprite.transform.matrix = mat;
    }
    // Bubble sort.. Insert sort would be better, prolly... maybe... not sure.
    public static function sortZ (dParent : DisplayObjectContainer) : Void {
        //for (t in 0...dParent.numChildren) {
            //var i = dParent.numChildren - t - 1;
            //var bFlipped = false;
            //for (o in 0...i) {
                //if (dParent.getChildAt(o).z < dParent.getChildAt(o+1).z) {
                    //dParent.swapChildrenAt(o,o+1);
                    //bFlipped = true;
                //}
            //}
            //if (!bFlipped)
                //return;
        //}
    }
    
    public static function rotateSprite(sp : DisplayObject, point : Vec2, angle : Float)
    {
        var mat = new Matrix();
        mat.tx -= point.x;
        mat.ty -= point.y;
        mat.rotate(angle);
        mat.tx += point.x;
        mat.ty += point.y;
        sp.transform.matrix = mat;
    }
    
    public static function getDigit(num : Int, digit : Int) : Int
    {
        var str = Std.string(num);
        if (digit < 1) { throw "Invalid digit $digit."; } 
        if (digit > str.length) { throw "Digit > number length"; }
        return Std.parseInt(str.charAt(str.length - digit));
    }
    
    public static function getLineFormula(p1 : Vec2, p2 : Vec2) : { m : Float, b : Float }
    {
        if (p1.x == p2.x) { return { m : Math.NaN, b : p1.x }; }
        var m = (p2.y - p1.y) / (p2.x - p1.x);
        var b = p2.y - m * p2.x;
        return { m : m, b : b };
    }
    
    public static function floatEqual(f1 : Float, f2 : Float) {
        return Math.abs(f1 - f2) < EPSILON;
    }
    public static function floatGrEqual(f1 : Float, f2 : Float) {
        return (Math.abs(f1 - f2) < EPSILON) || (f1 > f2);
    }
    public static function similar(v : Vec2, v2 : Vec2) : Bool {
        return floatEqual(v.x, v2.x) && floatEqual(v.y, v2.y);
    }
    
    
    public static function fdec(v : Float, dec : Int) : Float
    {
        var pw = Math.pow(10, dec);
        return Std.int(v * pw) / pw;
    }
    
    
    // x = at + b, y = ct + d.
    public static function parametricEqn(p1 : Vec2, p2 : Vec2) : { a : Float, b : Float, c : Float, d : Float } 
    {
        var a = p2.x - p1.x;
        var b = p1.x;
        var c = p2.y - p1.y;
        var d = p1.y;
        return { a : a, b : b, c : c, d : d };
    }
    
    public static function sign(v : Float) : Int {
        if (v < 0) {
            return -1;
        } else {
            return 1;
        }
    }
    
    public static function insertSort(list : BodyList, sorter : Body->Body->Bool) 
    {
        if (list.length == 0) { return list; }
        var array = new Array<Body>();
        array.push(list.at(0));
        for (k in 1...list.length) {
            var b = list.at(k);
            var index = array.length;
            for (i in 0...array.length) {
                if (sorter(b, array[i])) {
                    index = i;
                }
            }
            array.insert(index, b);
        }
        var blist = new BodyList();
        for (b in array) {
            blist.push(b);
        }
        return blist;
    }
    
    public static function pointInRect(p : Vec2, rect : AABB) : Bool 
    {
        return (p.x > rect.x && p.x < rect.x + rect.width) && (p.y > rect.y && p.y < rect.y + rect.height);
    }

    

}