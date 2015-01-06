package com.org.utils;

/**
 * ...
 * @author ...
 */
class ArrayHelper
{
    // not pure of course
    public static function foreach<A>(it:Iterable<A>, f:A -> Void) : Void
    {
        for (item in it) {
            f(item);
        }
    }
    
    public static function insertInPlace<A>(a:Array<A>, item : A, f:A -> A -> Bool) : Int 
    {
        for (i in 0...a.length) {
            if (f(item, a[i])) {
                a.insert(i, item);
                return i;
            }
        }
        a.push(item);
        return a.length - 1;
    }
    
    public static function ffilter<A>(it:Iterable<A>, f:A -> Bool) : List<A>
    {
        var res = new List<A>();
        for (item in it) {
            if (f(item)) {
                res.push(item);
            }
        }
        return res;
    }
    
    @:access(List)
    public static function popLast<T>(list : List<T>) : List<T>
    {
        var cur = list.h;
        var prev = null;
        while (cur != null) {
            if (cur[1] == null) {
                if (prev == null) {
                    list.h = null;
                } else {
                    prev[1] = null;
                }
                list.length--;
            }
            prev = cur;
            cur = cur[1];
        }
        return list;
    }
    
}