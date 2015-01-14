package com.org.bbb;
import com.org.mes.MESState;
import com.org.mes.Top;
import openfl.display.Stage;
import openfl.events.MouseEvent;

class CmpControlCarPlayer extends CmpControl
{
    var stage : Stage;
    var top : Top;
    var state : MESState;
    var mover(default, set) : CmpMover;
    
    public function new(stage : Stage, mover : CmpMover) 
    {
        super();
        this.stage = stage;
        this.mover = mover;
        
    }
    
    override public function init()
    {
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, startDrive);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, stopDrive);
        sendMsg(Msgs.NEWPLAYER, this, { cmpMover : mover } );
    }
    
    override public function update() : Void
    {
        
    }
    
    override public function deinit()
    {
        stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, startDrive);
        stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, stopDrive);
    }
    
    function startDrive(e)
    {
        mover.moveHor(1);
    }
    
    function stopDrive(e)
    {
        //mover.moverNeutral();
        mover.moveHor(0);
    }
    
    function set_mover(m : CmpMover) : CmpMover
    {
        if(mover != null) {
            mover.body.userData.isPlayer = false;
        }
        mover = m;
        if (mover != null) {
            mover.body.userData.isPlayer = true;
        }
        return m;
    }
    
}