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
    
    public function onEntChanged(e : Entity)
    {
        if (isValidEnt(e) ) {
            ents.add(e);
        } else if (ents.has(e) ) {
            ents.remove(e);
        }
    }
    
    public function isValidEnt(e : Entity) : Bool
    {
        return false;
    }
 
    var ents : List<Entity>;
}