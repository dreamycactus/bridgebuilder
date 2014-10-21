package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.System;
import haxe.ds.IntMap;
import haxe.ds.StringMap;

/**
 * ...
 * @author 
 */
class SysObjective extends System
{
    var cmpobjs : Array<CmpObjective> = new Array();
    var flags : StringMap<Bool> = new StringMap();
    
    public function new(state : MESState) 
    {
        super(state);
    }
    
    override public function isValidEnt(e : Entity) : Bool
    {
        if ( e.getCmpsHavingAncestor(CmpObjective).length > 0 ) {
            return true; 
        }
        return false;
    }
    
    override public function inserted(e : Entity) : Void
    {
        var res = e.getCmpsHavingAncestor(CmpObjective);
        if ( res.length > 0 ) {
            cmpobjs.push(res[0]);
        }
    }
    
    override public function update() : Void
    {
        if (!this.active) { return; }
        var done = false;
        for (c in cmpobjs) {
            if (c.updating) {
                c.met();
            }
            if (c.toTerminate) {
                flags.set(c.flagName, c.met());
                c.entity.delete();
                done = true;
                active = false;
            }
        }
        if (done) {
            state.top.changeState(new StateTransPan(state.top, cast(state), new StateLevelSelect(state.top)));
        }
    }
    
    function onChangeActive(a : Bool) : Void
    {
    }
    
    override function set_active(a : Bool) : Bool
    {
        onChangeActive(a);
        active = a;
        return a;
    }
    
    
    
}