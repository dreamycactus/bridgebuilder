package com.org.mes;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

/**
 * ...
 * @author 
 */
class Entity
{
    public var cmps : StringMap<Cmp>;
    var toDelete : Bool = false;
        
    public var id(default, null) : Int;
    public var name : String;
    public var state(default, set_state) : MESState;
    //public var cmpSig : de.polygonal.ds.BitVector;
    
    public function new(id : Int) 
    {
        this.cmps = new StringMap<Cmp>();
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
    
    @:generic public function getCmpHavingAncestor<T:Cmp>(ancestor:Class<T>) : T
    {
        var res = getCmpsHavingAncestor(ancestor);
        if (res.length == 0) {
            return null;
        }
        return res[0];
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
    
    public function toString() : String
    {
        var str = 'Entity id: ${id}. Cmps: ';
        for (c in cmps) {
            str += '${Type.getClassName(Type.getClass(c))}, ';
        }
        return str;
    }
    
    function registerSubscriptions()
    {
        for (c in cmps.iterator()) {
            for (s in c.subscriptions) {
                state.registerSubscriber(s, c);
            }
        }
    }
    
    function set_state(s : MESState) : MESState
    {
        if (s != null && s != state) {
            state = s;
            registerSubscriptions();
            return s;
        }
        state = s;
        return s;
    }
}