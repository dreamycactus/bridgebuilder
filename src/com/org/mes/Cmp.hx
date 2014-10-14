package com.org.mes;

/**
 * @author 
 */

class Cmp
{
    public static var cmpManager : CmpManager;
    public var entity(default, set_entity) : Entity;
    public var type : CmpType;
    
    public function new()
    {
        type = cmpManager.registerCmp(Type.getClass(this) );
    }
    
    public function update() : Void
    {
        
    }
    
    function set_entity(e : Entity) : Entity { entity = e; return e; };
}