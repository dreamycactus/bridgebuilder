package com.org.mes;

/**
 * ...
 * @author 
 */
class Top
{
    var state : MESState;
    var ents : List<Entity>;
    var sys : List<System>;
    var entIndex : Int;
    
    var cmpManager : CmpManager;
    
    public var prevTime : Int;
    public var dt : Float;
    public var entCount(get_entCount, null) : Int;
    
    public var transitioning : Bool = false;
    public var transition : Transition;
    
    public function new() 
    {
        ents = new List();
        sys = new List();
        entIndex = 0;
        
        cmpManager = new CmpManager();
        Cmp.cmpManager = cmpManager;
    }
        
    public function changeState(newState : MESState, trans : Transition=null)
    {
        transitioning = true;
        this.transition = trans;
        
        if (trans == null) {
            transitioning = false;
            if (state != null) {
                state.deinit();
            }
            state = newState;
        }
        
        newState.init();
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
            s.onInserted(e);
        }
    }
    
    public function deleteEnt(e : Entity)
    {
        for (s in sys) {
            s.onRemoved(e);
        }
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
    
    public function update(dt : Float)
    {
        this.dt = dt;
        
        for (s in sys) {
            s.update();
        }
        
        for (e in ents) {
            e.update();
        }
        
        if (transitioning && transition != null) {
            transition.update(dt);
            if (transition.isDone) {
                transitioning = false;
                transition = null;
                transition.oldState.deinit();
                state = transition.newState;
            }
        }
    }
    
    public function get_entCount() { return ents.length; }

}