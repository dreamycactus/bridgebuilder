package com.org.bbb;
import com.org.mes.Top;
import openfl.utils.Float32Array;

/**
 * ...
 * @author 
 */
class CmpObjectiveTimerUp extends CmpObjective
{
    public var totalTime : Float;
    var elapsedTime : Float = 0;
    public function new(totalTime : Float) 
    {
        super("timeup",true, true, null);
        this.totalTime = totalTime;
    }
    
    override public function update() : Void
    {
        if (!active) { return; }
        
        var dt = Top.dt;
        
        elapsedTime += dt;
        
    }
    
    override public function met()
    {
        if (elapsedTime >= totalTime) {
            toTerminate = true;
            return true;
        }
        return false;
    }
    
    override public function onActivate() : Void
    {
        elapsedTime - 0;
    }
    
    override public function onDeactivate() : Void
    {
        
    }
    
}