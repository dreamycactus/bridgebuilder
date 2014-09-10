package com.org.mes;

class MESState
{
    public var renderSys : System;
    public var sys : Array<System>;
    public var ents : List<Entity>;
    public var top : Top;
    
    public function new(top : Top) 
    {
        this.top = top;
        this.sys = new Array();
        this.ents = new List();
    }
    
    public function init()
    {
    }
    
    public function deinit()
    {
        // Cleanup old
        for (e in ents) {
            deleteEnt(e);
        }
        ents = null;
        for (s in sys) {
            s.active = false;
            s.deinit();
        }
        sys = null;
    }
    
    public function update() : Void 
    {
        for (s in sys) {
            s.update();
        }
        
        for (e in ents) {
            e.update();
        }
    }
    
    public function createEnt(name : String = "") : Entity
    {
        var e = new Entity(this);
        e.name = name;
        return e;
    }
    
    public function insertEnt(e : Entity)
    {
        ents.add(e);
        for (s in sys) {
            s.onInserted(e);
        }
    }
    
    public function deleteEnt(e : Entity)
    {
        for (s in sys) {
            s.onRemoved(e);
        }
        //TODO assign indicies to entities that are reusable like artemis to allow fast access and removal
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
        if (sys != null) {
            sys.push(s);
            s.init();
            s.active = true;
        } else {
            throw "System is " + s + "... cannot add to top";
        }
    }
    
    public function removeSystem(s : System)
    {
        sys.remove(s);
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

}