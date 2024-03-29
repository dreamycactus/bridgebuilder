package com.org.bbb.systems ;
import com.org.bbb.level.CmpLevel;
import com.org.bbb.level.CmpSpawn;
import com.org.bbb.physics.CmpMoverCar;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.System;
import nape.dynamics.InteractionFilter;

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
    override public function removed(e : Entity) : Void
    {
    }
    public function runExecution(b : Bool) : Void
    {
        var cars : Array<Entity> = state.getEntitiesOfType(GameConfig.tCar);
        for (c in cars) {
            var mover = c.getCmp(CmpMoverCar);
            if (!mover.body.userData.isPlayer) {
                mover.compound.visitBodies(function(b) {
                        b.setShapeFilters(new InteractionFilter(GameConfig.cgLoad, 0));
                });
            }
            
        }
        for (e in level.ents) {
            
        }
        for (s in spawns) {
            s.active = b;
        }
    }
}