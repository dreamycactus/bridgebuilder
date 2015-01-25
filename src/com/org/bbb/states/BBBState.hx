package com.org.bbb.states ;
import com.org.mes.MESState;
import com.org.mes.Top;
import openfl.display.Sprite;

/**
 * ...
 * @author 
 */
class BBBState extends MESState
{
    public var mainSprite(get_mainSprite, null) : Sprite;
    
    public function new(top : Top) 
    {
        super(top);
    }
    
    public function get_mainSprite() : Sprite
    {
        return null;
    }
    
    public function disableControl() : Void
    {
        
    }
    
    public function enableControl() : Void
    {
        
    }
}