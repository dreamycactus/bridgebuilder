package com.org.mes;
using Lambda;
/**
 * ...
 * @author 
 */
class System
{
    public var state : MESState;
    public var active(default, set_active) : Bool = false;
    
    public function new(state : MESState) 
    {
        this.state = state;
        ents = new List();
    }
    
    public function init() : Void
    {
        
    }
    
    public function deinit() : Void { }
    
    public function update()
    {
    }
    
    public function inserted(e : Entity) : Void { }
    public function removed(e : Entity) : Void { }

    
    public function onInserted(e : Entity)
    {
        if (isValidEnt(e) ) {
            inserted(e);
            ents.add(e);
        }
    }
    
    
    public function onRemoved(e : Entity)
    {
        removed(e);
    }
    
    public function onEntChanged(e : Entity)
    {
        
    }
    
    public function isValidEnt(e : Entity) : Bool
    {
        return false;
    }
    
    function set_active(a : Bool) : Bool
    {
        active = a;
        return a;
    }
 
    var ents : List<Entity>;
}