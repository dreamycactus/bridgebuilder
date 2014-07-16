package com.org.mes;

/**
 * @author 
 */

interface Transition 
{
    public var isDone : Bool;
    public var oldState : MESState;
    public var newState : MESState;
    
    public function enter() : Void;
    public function update(dt : Float) : Void;
    public function leave() : Void;
}