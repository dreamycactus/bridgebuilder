package com.org.mes;

/**
 * ...
 * @author 
 */
class Top
{
    var ents : List<Entity>;
    var sys : List<System>;
    var entIndex : Int;
    
    public var prevTime : Int;
    public var dt : Float;
    
    public function new() 
    {
        ents = new List();
        sys = new List();
        entIndex = 0;
    }
    
    public function init()
    {
        for (s in sys) {
            s.init();
        }
    }
    
    public function createEnt(name : String = "") : Entity
    {
        var e = new Entity(this);
        e.id = entIndex++;
        e.name = name;
        return e;
    }
    
    public function insertEnt(e : Entity)
    {
        ents.add(e);
        for (s in sys) {
            s.onEntChanged(e);
        }
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
    
    public function insertSystem(s : System)
    {
        if ( sys != null ) {
            sys.add(s);
        } else {
            trace("Null system cannot be added to top");
        }
    }
    
    public function getSystem<T>(t:Class<T>) : T
    {
        for (s in sys) {
            if (Type.getClassName(Type.getClass(s) ) == Type.getClassName(t) ) {
                return cast(s);
                break;
            }
        }
        return null;
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