package com.org.bbb.states ;
import com.org.mes.MESState;
import com.org.mes.Top;
import com.org.mes.Transition;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.Lib;

/**
 * ...
 * @author 
 */
class StateTransPan extends Transition
{
    public var bos : BBBState;
    public var bns : BBBState;
    
    public function new(top : Top, os : BBBState, ns : BBBState)
    {
        super(top, cast(os), cast(ns));
        this.bos = os;
        this.bns = ns;
        enter();
    }
        
    override public function enter() : Void
    {
        super.enter();
        bos.disableControl();
        bns.disableControl();
        
        var nsSprite : Sprite = bns.mainSprite;
        nsSprite.scrollRect = new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
        nsSprite.x -= Lib.current.stage.stageWidth;
        
        Actuate.tween(nsSprite, 1, { x : 0 } ).onComplete(leave);
        Actuate.tween(bos.mainSprite,
                      1,
                      { x : Lib.current.stage.stageWidth, alpha : 0 } );
    }
    
    override public function update() : Void
    {
        oldState.update();
        newState.update();
    }
    
    override public function leave() : Void
    {
        //super.leave();
        isTransitioning = false;
        isDone = true;
        bns.mainSprite.mask = null;
        
        bos.deinit();
        bns.enableControl();
        top.changeState(newState);
    }
    
}