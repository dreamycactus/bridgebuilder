package com.org.mes;
import haxe.ds.StringMap;

/**
 * ...
 * @author 
 */
class CmpManager
{
    public function new() 
    {
        cmpsByName = new StringMap<CmpType>();
    }
    
    public function registerCmp(cmpClass : Class<Cmp>) : CmpType
    {
        //var type = Type.getClass(cmp);
        var typename = Type.getClassName(cmpClass);
        var ct : CmpType;
        
        if (!cmpsByName.exists(typename) ) {
            ct = new CmpType(cmpClass);
            cmpsByName.set(typename, ct);
        } else {
            ct = cmpsByName.get(typename);
        }
        
        return ct;
    }
    
    public function getCmp(cmpClass : Class<Cmp>) : CmpType
    {
        return cmpsByName.get(Type.getClassName(cmpClass) );
    }
    
    public function makeParentChild(parent : Class<Cmp>, children : Array<Class<Cmp>>)
    {
        for (child in children) {
            var pt = registerCmp(parent);
            var ct = registerCmp(child);
            
            pt.addChild(ct);
        }
    }
        
    public function printAll() : String
    {
        var s = "";
        
        for (k in cmpsByName.keys()) {
            s += "(" + k + ", " + cmpsByName.get(k) + "), " ;
        }
        return s;
    }
    
    
    var cmpsByName : StringMap<CmpType>;

}