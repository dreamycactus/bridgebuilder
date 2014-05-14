package com.org.bbb;
import nape.geom.Vec2;
import nape.geom.Vec3;

/**
 * ...
 * @author 
 */
class Util
{
    public static function Vec3ToIntString(v : Vec3) : String
    {
        return cast(v.x, Int) + ", " + cast(v.y, Int) + ", " + cast(v.z, Int);
    }
}