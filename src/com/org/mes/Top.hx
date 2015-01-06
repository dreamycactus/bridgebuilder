package com.org.mes;

/**
 * ...
 * @author 
 */
class Top
{
    public static var dt : Float = 0;
    public static var elapsed : Float = 0;
    
    public var state : MESState;
    var ents : List<Entity>;
    var sys : List<System>;
    var entIndex : Int;
    
    var cmpManager : CmpManager;
    
    public var prevTime : Int;
    //public var entCount(get_entCount, null) : Int;
    
    public var transitioning(get_transitioning, null) : Bool = false;
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
        if (state == null || !state.isTransitioning) {
            state = newState;
            state.init();
        }
    }
    
    public function update(dt : Float)
    {
        Top.dt = dt;
        Top.elapsed += dt;
        
        state.update();
    }
    
    //public function get_entCount() { return ents.length; }
    function get_transitioning() : Bool
    {
        if (state == null) { return false; }
        if (state.isTransitioning) { return true; }
        return false;
    }
}