package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.System;

/**
 * ...
 * @author 
 */
class SysLevelDirector extends System
{
    var spawns : List<CmpSpawn> = new List();
    public var level : CmpLevel;
    public function new(state : MESState, level : CmpLevel) 
    {
        super(state);
        this.level = level;
    }
    
    override public function isValidEnt(e : Entity) : Bool
    {
        if (e.getCmpsHavingAncestor(CmpSpawn).length > 0) {
            return true; 
        }
        return false;
    }
    
    override public function inserted(e : Entity) : Void
    {
        var sps = e.getCmpsHavingAncestor(CmpSpawn);
        for (s in sps) {
            spawns.push(s);
        }
    }
    
    public function runExecution(b : Bool) : Void
    {
        for (e in level.ents) {
            
        }
        for (s in spawns) {
            s.active = b;
        }
    }
}