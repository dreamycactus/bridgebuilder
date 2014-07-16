package com.org.bbb;

/**
 * ...
 * @author 
 */
class CmpControlCar extends CmpControl
{
    var mover : CmpMover;
    
    public function new(mover : CmpMover) 
    {
        super();
        this.mover = mover;
    }
    
    override public function update() : Void
    {
        //if (mover.body.velocity.x < 100)
        //mover.moveHor(2.0);
    }
    
}