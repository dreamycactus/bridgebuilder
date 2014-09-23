package com.org.bbb;
import haxe.ds.HashMap;
import haxe.ds.IntMap;
import nape.geom.Vec2;

using Lambda;

typedef BeamLine =
{
    slope : Float,
    yint : Float,
    p1 : Vec2,
    p2 : Vec2,
    length : Float
}
class LineChecker
{
    var lines : Array<BeamLine> = new Array();
    public function new() 
    {
    }
    
    public function addLine(p1 : Vec2, p2 : Vec2) : Bool
    {
        var line =  Util.getLineFormula(p1, p2);
        var beamline : BeamLine = { slope : line.m, yint : line.b, p1 : p1, p2 : p2, length : p2.sub(p1).length };
        var res = binaryFindColinear(beamline);
        var colinear = res.a;
        
        for (l in colinear) {
            var left1 : Float;
            var right1 : Float;
            var left2 : Float;
            var right2 : Float;
            if (Math.isNaN(beamline.slope)) {
                if (p1.y < p2.y) {
                    left1 = p1.y;
                    right1 = p2.y;
                } else {
                    left1 = p2.y;
                    right1 = p1.y;
                }
                if (l.p1.y < l.p2.y) {
                    left2 = l.p1.y;
                    right2 = l.p2.y;
                } else {
                    left2 = l.p2.y;
                    right2 = l.p1.y;
                }
            } else {
                if (p1.x < p2.x) {
                    left1 = p1.x;
                    right1 = p2.x;
                } else {
                    left1 = p2.x;
                    right1 = p1.x;
                }
                if (l.p1.x < l.p2.x) {
                    left2 = l.p1.x;
                    right2 = l.p2.x;
                } else {
                    left2 = l.p2.x;
                    right2 = l.p1.x;
                }
            }

            if (Util.floatGrEqual(left2, right1) || Util.floatGrEqual(left1, right2)) {
                continue;
            } else {
                return false;
            }
        }
        var ins = false;
        for (i in 0...lines.length) {
            if ((lines[i].slope > beamline.slope || (equalSlopes(lines[i].slope, beamline.slope) && lines[i].yint > beamline.yint))
            || (Math.isNaN(lines[i].slope) && !Math.isNaN(beamline.slope))) {
                lines.insert(i, beamline);
                ins = true;
                break;
            }
        }
        if (!ins) {
            lines.push(beamline);
            if (beamline.slope == -1) {
                trace('uh');
            }
        }
            
        return true;
    }
    
    public function removeLine(p1 : Vec2, p2 : Vec2)
    {
        
    }
    inline function bothNan(v : Float, v2 : Float) : Bool
    {
        return (Math.isNaN(v) && Math.isNaN(v2));
    }
    inline function equalSlopes(s1 : Float, s2 : Float) : Bool
    {
        return Util.floatEqual(s1, s2) || bothNan(s1, s2);
    }
    
    function binaryFindColinear(beamLine : BeamLine) : { a : Array<BeamLine>, index : Int }
    {
        var ret = new Array<BeamLine>();
        var imax = lines.length - 1;
        var imin = 0;
        var index = -1;
        
        while (imax >= imin) {
            var mid = Std.int((imax + imin) * 0.5);
            if (equalSlopes(lines[mid].slope, beamLine.slope)
            && Util.floatEqual(lines[mid].yint, beamLine.yint)) {
                index = mid;
                ret.push(lines[mid]);
                break;
            } else if (lines[mid].slope < beamLine.slope 
                || (equalSlopes(lines[mid].slope, beamLine.slope)
                    && lines[mid].yint <= beamLine.yint)) {
                imin = mid + 1;
            } else {
                imax = mid - 1;
            }
        }
        if (index == -1) { return { a :ret, index : -1 }; }
        
        var i = index-1;
        while (i >= 0 && (equalSlopes(lines[i].slope, beamLine.slope)
                        && Util.floatEqual(lines[i].yint, beamLine.yint))) {
            ret.push(lines[i]);
            i--;
        }
        i = index+1;
        while (i < lines.length && (equalSlopes(lines[i].slope, beamLine.slope) 
                                  && Util.floatEqual(lines[i].yint, beamLine.yint))) {
            ret.push(lines[i]);
            i++;
        }
        return { a : ret, index : index };
    }
    
}