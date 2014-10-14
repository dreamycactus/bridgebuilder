package com.org.bbb;

/**
 * ...
 * @author 
 */
class CmpObjectiveEndBridgeIntact extends CmpObjective
{

    public function new(l : CmpLevel) 
    {
        super("intact", false, true, l);
    }
    
    override public function met() : Bool
    {
        var stats = entity.state.getSystem(SysRuntimeOverlord).beamBreak;
        for (s in stats) {
            if (s != 0) {
                return false;
            }
        }
        return true;
    }
}