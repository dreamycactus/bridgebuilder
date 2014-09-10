package com.org.mes;

/**
 * @author 
 */

class Transition extends MESState
{
    public var isDone : Bool;
    public var oldState : MESState;
    public var newState : MESState;
    public var progress : Float = 0;

    public function new(top : Top, os : MESState, ns : MESState)
    {
        super(top);
        oldState = os;
        newState = ns;
    }
    public function enter() : Void
    {
    }
    
    override public function update() : Void
    {
        
    }
    
    public function leave() : Void
    {
        oldState.deinit();
        top.changeState(newState);
    }
}