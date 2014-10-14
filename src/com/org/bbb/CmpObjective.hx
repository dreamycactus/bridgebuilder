package com.org.bbb;
import com.org.bbb.CmpLevel;
import com.org.mes.Cmp;
import haxe.ds.StringMap;
import nape.space.Space;

/**
 * ...
 * @author 
 */
class CmpObjective extends Cmp
{
    public var updating : Bool;
    public var mandatory : Bool;
    public var toTerminate : Bool = false;
    public var flagName : String;
    public var level(default, set_level) : CmpLevel;
    @:isVar public var active(default, set_active) : Bool = false;
    
    public function new(flagName : String, updating : Bool, mandatory : Bool, level : CmpLevel) 
    {
        super();
        this.flagName = flagName;
        this.updating = updating;
        this.mandatory = mandatory;
        this.level = level;
    }
    
    public function met() : Bool
    {
        return true;
    }
    
    public function onActivate() : Void { }
    public function onDeactivate() : Void { }
    
    function set_active(a : Bool) : Bool
    {
        if (a != active) {
            if (a) {
                onActivate();
            } else {
                onDeactivate();
            }
        }
        active = a;
        return a;
    }
    
    function set_level(l : CmpLevel) {
        level = l;
        return l;
    }
    
}