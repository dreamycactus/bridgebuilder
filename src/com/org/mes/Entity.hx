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
    public var state : MESState;
    //public var cmpSig : de.polygonal.ds.BitVector;
    
    public function new(state : MESState, id : Int) 
    {
        this.cmps = new StringMap<Cmp>();
        this.state = state;
        this.id = id;
        //cmpSig = BitFields.zero;
    }
    
    inline public function delete()
    {
        if (state != null) {
            state.deleteEnt(this);
        }
    }

    public function getCmp<T:Cmp>(t:Class<T>) : T
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
    
    public function hasCmp<T:Cmp>(t:Class<T>) : Bool
    {
        return cmps.exists( Type.getClassName(t) );
    }
    
    @:generic public function getCmpsHavingAncestor<T:Cmp>(ancestor:Class<T>) : Array<T>
    {
        var at = Cmp.cmpManager.getCmp(cast(ancestor));
        if (at == null) {
            trace("No such cmp ancestor " + ancestor);
            return new Array();
        }
        var res = new Array<T>();
        for (c in cmps) {
            if (Cmp.cmpManager.getCmp( Type.getClass(c) ).isDecendantOf(at) ) {
                res.push(cast(c));
            }
        }
        return res;
    }
    
    public function update() 
    {
        for (c in cmps) {
            c.update();
        }
    }
    
}