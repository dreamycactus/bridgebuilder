package com.org.mes;

/**
 * ...
 * @author 
 */
class Top
{
    public var state : MESState;
    var ents : List<Entity>;
    var sys : List<System>;
    var entIndex : Int;
    
    var cmpManager : CmpManager;
    
    public var prevTime : Int;
    public var dt : Float;
    //public var entCount(get_entCount, null) : Int;
    
    public var transitioning : Bool = false;
    public var transition : Transition;
    
    public function new() 
    {
        ents = new List();
        sys = new List();
        entIndex = 0;
    }
        
    public function changeState(newState : MESState, isTransition : Bool=true)
    {
        if (!isTransition && state != null) {
            state.deinit();
        }
        state = newState;
        state.init();
    }
    
    public function update(dt : Float)
    {
        this.dt = dt;
        
        state.update();
    }
    
    //public function get_entCount() { return ents.length; }

}