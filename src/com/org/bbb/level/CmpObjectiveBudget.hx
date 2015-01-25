package com.org.bbb.level ;
import com.org.bbb.widgets.WBottomBar;
import com.org.mes.Cmp;
import haxe.ds.StringMap;
import ru.stablex.ui.UIBuilder;

/**
 * ...
 * @author 
 */
class CmpObjectiveBudget extends CmpObjective
{
    public var maxBudget : Int = 0;
    public var currentBudget : Int = 0;
    public var expectedBudget : Int; // Average spending to beat level
    public var minimumBudget : Int;  // Lowest possible spending to beat level
    public var bottombar : WBottomBar;
    
    public function new(level : CmpLevel, max : Int, expected : Int, minimum : Int) 
    {
        super("", false, false, level);
        this.maxBudget = max;
        this.expectedBudget = expected;
        this.minimumBudget = minimum;
        this.subscriptions = [Msgs.BEAMRECALC, Msgs.BEAMDELETE, Msgs.BEAMDOWN];
    }
    
    override public function onActivate() : Void 
    { 
        updateUI();
    }
    
    override public function met() : Bool
    {
        return currentBudget <= maxBudget;
    }
    
    public function updateUI()
    {
        if (bottombar == null) {
            bottombar = cast(UIBuilder.get('bottombar'));
        }
        if (bottombar != null) {
            bottombar.setBudgetText('Budget: $currentBudget / $maxBudget');
        }
    }
    
    override public function recieveMsg(msgType : String, sender : Cmp, options : Dynamic) : Void 
    {
        switch(msgType) {
        case Msgs.BEAMDOWN:
            currentBudget += Std.int(options.length * options.cost);
        case Msgs.BEAMDELETE:
            currentBudget -= Std.int(options.length * options.cost);
        case Msgs.BEAMRECALC:
            currentBudget = 0;
            var beams : Array<{ length : Int, cost : Int}> = options.beams;
            for (b in beams) {
                currentBudget += b.length * b.cost;
            }
        default:
        }
        updateUI();
    }

    
}