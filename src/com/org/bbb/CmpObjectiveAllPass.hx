package com.org.bbb;
import nape.callbacks.BodyCallback;
import nape.callbacks.BodyListener;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.space.Space;

class CmpObjectiveAllPass extends CmpObjective
{
    var carArrive : InteractionListener;
    var totalArrivedCount : Int;
    var currentArrivedCount : Int;
    public function new(level : CmpLevel) 
    {
        carArrive = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR
                                  , [GameConfig.cbCar, GameConfig.cbTruck], [GameConfig.cbEnd], carReachedEnd);

        super("allpass", true, true, level);
    }
    
    override public function met()
    {
        var res = currentArrivedCount == totalArrivedCount;
        if (res) {
            toTerminate = true;
        }
        return res;
    }
    
    override public function onActivate() : Void
    {
        currentArrivedCount = 0;
    }
    
    override public function onDeactivate() : Void
    {
    }
    
    function carReachedEnd(bc : InteractionCallback) : Void
    {
        currentArrivedCount++;
        
    }
    
    override function set_level(l : CmpLevel) : CmpLevel
    {
        level = l;
        carArrive.space = null;
        if (l != null) {
            carArrive.space = l.space;
            totalArrivedCount = 0;
            currentArrivedCount = 0;
            for (s in level.spawns) {
                if (s.totalCount != -1) {
                    totalArrivedCount += s.totalCount;
                }
            }
        }
        return l;
    }
    
}