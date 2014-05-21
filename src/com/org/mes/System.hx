package com.org.mes;

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
    
    public function update()
    {
        
    }
    
    public function onEntChanged(e : Entity)
    {
        if (isValidEnt(e) ) {
            ents.add(e);
        }
    }
    
    public function isValidEnt(e : Entity) : Bool
    {
        return false;
    }
 
    var ents : List<Entity>;
}