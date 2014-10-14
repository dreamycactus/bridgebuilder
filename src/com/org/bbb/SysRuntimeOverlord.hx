package com.org.bbb;
import com.org.bbb.GameConfig.MatType;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.System;
import haxe.ds.IntMap;
import nape.callbacks.CbEvent;
import nape.callbacks.ConstraintCallback;
import nape.callbacks.ConstraintListener;
import nape.constraint.PivotJoint;

/* This class keeps track of all the bridge structures created by the player, cars and entities spawned
 * and produces statistics about these data */ 
class SysRuntimeOverlord extends System
{
    @:isVar public var level(default, set_level) : CmpLevel;
    public var currentSpending : Float;
    var beamMap : IntMap<Entity>;
    
    var listenCableBreak : ConstraintListener;
    
    public var beamBreak : IntMap<Int> = new IntMap();
    var movers : Array<Entity>;
    
    public function new(state : MESState) 
    {
        super(state);
        beamBreak.set(Type.enumIndex(MatType.BEAM), 0);
        beamBreak.set(Type.enumIndex(MatType.DECK), 0);
        beamBreak.set(Type.enumIndex(MatType.WOOD), 0);
        beamBreak.set(Type.enumIndex(MatType.CABLE), 0);
        beamBreak.set(Type.enumIndex(MatType.CONCRETE), 0);
        
        listenCableBreak = new ConstraintListener(CbEvent.BREAK, [GameConfig.cbCable], function(cc: ConstraintCallback) {
            incrBeamBreak(MatType.CABLE);
        });
    }
    
    override public function init() : Void
    {

    }
    
    override public function deinit() : Void
    {
        listenCableBreak.space = null;
    }
    
    override public function isValidEnt(e : Entity) : Bool
    {
        if ( e.getCmpsHavingAncestor(CmpBeamBase).length > 0 ) {
            return true; 
        } else if (e.getCmpsHavingAncestor(CmpMover).length > 0) {
            return true;
        }
        
        return false;
    }
    
    override public function inserted(e : Entity)
    {
        if (e.getCmpsHavingAncestor(CmpMover).length > 0) {
            movers.push(e);
        }
    }
    
    override public function removed(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpBeamBase);
        if (res.length != 0 && res[0].broken) {
            incrBeamBreak(res[0].material.matType);
        }
    }
    
    
    function incrBeamBreak(mat : MatType) : Void
    {
        var i = Type.enumIndex(mat);
        beamBreak.set(i, beamBreak.get(i)+1);
    }
    
    function set_level(l : CmpLevel) : CmpLevel
    {
        level = l;
        listenCableBreak.space = level.space;

        return l;
    }
}