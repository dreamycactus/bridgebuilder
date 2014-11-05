package com.org.bbb;
import haxe.ds.StringMap;

/**
 * ...
 * @author 
 */
class CmpObjectiveBudget extends CmpObjective
{
    public var maxBudget : Float;
    public var currentBudget : Float;
    public var expectedBudget : Float; // Average spending to beat level
    public var minimumBudget : Float;  // Lowest possible spending to beat level
    
    public function new(level : CmpLevel) 
    {
        super("", false, false, level);
    }
    
    override public function met() : Bool
    {
        return currentBudget <= maxBudget;
    }
    
}