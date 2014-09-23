package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.System;
import haxe.ds.IntMap;

/**
 * ...
 * @author 
 */
/* This class keeps track of all the bridge structures created by the player, cars and entities spawned
 * and produces statistics about these data */ 
class SysRuntimeOverlord extends System
{
    @:isVar public var level(default, set_level) : CmpLevel;
    public var currentSpending : Float;
    var beamMap : IntMap<Entity>;
    
    public function new() 
    {
        
    }
    
    override public function isValidEnt(e : Entity) : Bool
    {
        if ( e.getCmpsHavingAncestor(CmpBeam).length > 0 ) {
            return true; 
        } else if (e.getCmpsHavingAncestor(CmpCable).length > 0) {
            return true;
        } else if (e.getCmpsHavingAncestor(CmpMoverCar).length > 0) {
            return true;
        } 
        return false;
    }
    
    override public function inserted(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpRender);
        for (c in res) {
            cmpsToRender.push(c);
            if (c.inCamera) {
                c.addToScene(camera.sprite);
            } else {
                c.addToScene(mainSprite);
            }
        }
    }
    
    override public function removed(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpRender);
        for (c in res) {
            cmpsToRender.push(c);
            if (c.inCamera) {
                c.removeFromScene(camera.sprite);
            } else {
                c.removeFromScene(mainSprite);
            }
        }
    }
    
    public function registerBeam(e : Entity)
    {
        if (e.hasCmp(CmpBeam)) {
            
        } else if (e.hasCmp(CmpCable)) {
            
        }
    }
    
    public function unregisterBeam(e : Entity)
    {
        if (e.hasCmp(CmpBeam)) {
            
        } else if (e.hasCmp(CmpCable)) {
            
        }
    }
    
    function set_level(l : CmpLevel) : CmpLevel
    {
        return l;
    }
}