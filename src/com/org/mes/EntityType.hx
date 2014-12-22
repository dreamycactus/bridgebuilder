package com.org.mes;

/**
 * ...
 * @author ...
 */
class EntityType
{
    static var totalIndex : Int = 0;
    
    @:isVar public var index(default, null) : Int;
    public var name : String;
    var allset : Array<Class<Dynamic>> = new Array();
    var oneset : Array<Class<Dynamic>> = new Array();
    var exclusionset : Array<Class<Dynamic>> = new Array();
    
    public function new(name : String, all : Array<Class<Dynamic>>, one : Array<Class<Dynamic>>, exlusion : Array<Class<Dynamic>>) 
    {
        this.name = name;
        allset = all;
        oneset = one;
        exlusion = exclusionset;
        index = totalIndex++;
    }
    
    public function matches(e : Entity) : Bool
    {
        var ismatching = true;
        for (c in allset) {
            if (!e.hasCmp(c)) {
                return false;
            }
        }
        ismatching = (oneset == null || oneset.length == 0) ? true : false;
        for (c in oneset) {
            if (e.hasCmp(c)) {
                ismatching = true;
                break;
            }
        }
        for (c in exclusionset) {
            if (e.hasCmp(c)) {
                return false;
            }
        }
        return ismatching;
    }
    
}