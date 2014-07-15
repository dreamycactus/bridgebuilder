package com.org.bbb;
import com.org.mes.Entity;
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
    public function new(top : Top, stage : Stage)
    {
        super(top);
        this.stage = stage;
    }
    
    override public function init()
    {
        UIBuilder.init();
        trace("hello");
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