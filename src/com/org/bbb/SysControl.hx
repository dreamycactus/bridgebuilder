package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.System;
import com.org.mes.Top;

/**
 * ...
 * @author 
 */
class SysControl extends System
{

    public function new(top : Top)
    {
        super(top);
    }
    
    override public function inserted(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpControl);
        for (c in res) {
            c.init();
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
}