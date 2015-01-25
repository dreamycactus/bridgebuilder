package com.org.bbb.level ;
import com.org.mes.Cmp;

/**
 * ...
 * @author 
 */
class CmpObjectiveEndBridgeIntact extends CmpObjective
{
    var beamBroken = false;
    public function new(l : CmpLevel) 
    {
        super("intact", false, true, l);
        subscriptions = [Msgs.BEAMBREAK];
    }
    
    override public function met() : Bool
    {
        
    
        return true;
    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void 
    {
        switch(msgType) {
        case Msgs.BEAMBREAK:
            
        default:
        }
    }

    
}