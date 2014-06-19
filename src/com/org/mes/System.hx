package com.org.mes;
using Lambda;
/**
 * ...
 * @author 
 */
class System
{
    public var top : Top;
    
    public function new(top : Top) 
    {
        this.top = top;
        ents = new List();
    }
    
    public function init() : Void
    {
        
    }
    
    public function update()
    {
        for (e in ents) {
            e.update();
        }
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
 
    var ents : List<Entity>;
}