package com.org.mes;

/**
 * ...
 * @author 
 */
class System
{
    public function new() 
    {
        ents = new List();
    }
    
    public function update(dt : Float)
    {
        
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