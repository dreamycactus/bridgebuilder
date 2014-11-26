package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.MESState;
import com.org.mes.System;
import com.org.mes.Top;
import flash.display.Stage;
import ru.stablex.ui.UIBuilder;

/**
 * ...
 * @author 
 */
class SysControl extends System
{
    public var stage : Stage;
    public function new(state : MESState, stage : Stage)
    {
        super(state);
        this.stage = stage;
    }
    
    override public function init()
    {
    }
    
    override public function inserted(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpControl);
        for (c in res) {
            //c.init();
        }
    }
    
    override public function removed(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpControl);
        for (c in res) {
            c.deinit();
        }
    }
    
    override public function isValidEnt(e : Entity) : Bool
    {
        if (e.getCmpsHavingAncestor(CmpControl).length > 0 ) {
            return true;
        }
        return false;
    }
    
    override public function deinit()
    {
        for (e in ents) {
            var res = e.getCmpsHavingAncestor(CmpControl);
            for (c in res) {
                c.deinit();
            }
        }
    }
    
    override function set_active(a : Bool) : Bool
    {  
        super.set_active(a);
        if (!a) {
            deinit();
        } else {
            for (e in ents) {
                var res = e.getCmpsHavingAncestor(CmpControl);
                for (c in res) {
                    c.init();
                }
            }
        }
        return a;
    }
}