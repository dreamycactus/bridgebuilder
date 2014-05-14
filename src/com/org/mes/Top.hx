package com.org.mes;

/**
 * ...
 * @author 
 */
class Top
{
    var ents : List<Entity>();
    var sys : List<System>();
    var entIndex : Int;
    
    public var dt : Float;
    
    public function new() 
    {
        ents = new List();
        sys = new List();
        entIndex = 0;
    }
    
    public function createEnt(name : String = "") : Entity
    {
        var e = new Entity();
        e.id = entIndex++;
        e.name = name;
        return e;
    }
    
    public function insertEnt(e : Entity)
    {
        ents.add(e);
    }
    
    public function deleteEnt(e : Entity)
    {
        ents.remove(e);
    }
    
    public function onEntChanged(e : Entity)
    {
        for (s in sys) {
            s.onEntChanged(e);
        }
    }
    
    public function update(dt : Float)
    {
        this.dt = dt;
        
        for (s in sys) {
            s.update();
        }
        
        for (e in ents) {
            e.update();
        }
    }
    
}