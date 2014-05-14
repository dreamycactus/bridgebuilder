package com.org.mes;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

/**
 * ...
 * @author 
 */
class Entity
{
    var cmps : StringMap<Cmp>;
        
    public var id : Int;
    public var name : String;
    
    public function new() 
    {
        cmps = new StringMap<Cmp>();
    }
    
    public function getCmp(cmpType : Class<Dynamic>) 
    {
        return cmps.get( Type.getClassName(cmpType) );
    }
    
    public function addCmp(c: Cmp) 
    {
        c.entity = this;
        cmps.set(Type.getClassName(Type.getClass(c) ), c);  
    }
    
    public function removeCmp(cmpType : Class<Dynamic>) 
    {
        var key = Type.getClassName(cmpType);
        cmps.get(key).entity = null;
        cmps.remove(key);
    }
    
    public function update() 
    {
        for (c in cmps) {
            c.update();
        }
    }
    
}