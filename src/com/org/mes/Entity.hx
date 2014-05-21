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
    //public var cmpSig : de.polygonal.ds.BitVector;
    
    public function new() 
    {
        cmps = new StringMap<Cmp>();
        //cmpSig = BitFields.zero;
    }
    
    @:generic public function getCmp<T:Cmp>(t:Class<T>) : T
    {
        return cast( cmps.get( Type.getClassName( t ) ) );
    }
    
    public function attachCmp(c: Cmp) 
    {
        c.entity = this;
        cmps.set(Type.getClassName(Type.getClass(c) ), c);  
    }
    
    public function detachCmp(cmpType : Class<Dynamic>) 
    {
        var key = Type.getClassName(cmpType);
        cmps.get(key).entity = null;
        cmps.remove(key);
    }
    
    @:generic public function hasCmp<T:Cmp>(t:Class<T>) : Bool
    {
        return cmps.exists( Type.getClassName(t) );
    }
    
    public function update() 
    {
        for (c in cmps) {
            c.update();
        }
    }
    
}