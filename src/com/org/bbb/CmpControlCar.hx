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
        subscriptions = [Msgs.BEAMBREAK];
    }
    
    override public function update() : Void
    {
        if (mover.body.position.y > Lib.current.stage.stageHeight + 1000) {
            entity.delete();
        }
        
        //if (mover.body.rotation < Math.PI / 3) {
            //mover.motorFront.active = true;
            //mover.motorBack.active = false;
        //} else {
            //mover.motorFront.active = false;
            //mover.motorBack.active = true;
        //}
    }
    
    function set_speed(s : Float) : Float
    {
        mover.motorFront.rate = s;
        mover.motorBack.rate = s;
        return s;
    }
}