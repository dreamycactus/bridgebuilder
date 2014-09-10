package com.org.bbb;
import openfl.Lib;

/**
 * ...
 * @author 
 */
class CmpControlCar extends CmpControl
{
    var mover : CmpMoverCar;
    @:isVar public var speed(default, set_speed) : Float;
    
    public function new(mover : CmpMoverCar) 
    {
        super();
        this.mover = mover;
    }
    
    override public function update() : Void
    {
        if (mover.body.position.y > Lib.current.stage.stageHeight + 100) {
            entity.delete();
        }
    }
    
    function set_speed(s : Float) : Float
    {
        mover.motorFront.rate = s;
        mover.motorBack.rate = s;
        return s;
    }
}