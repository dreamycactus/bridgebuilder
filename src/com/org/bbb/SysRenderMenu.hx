package com.org.bbb;
import com.org.mes.MESState;
import com.org.mes.System;
import openfl.display.Sprite;

/**
 * ...
 * @author 
 */
class SysRenderMenu extends System
{
    public var mainSprite : Sprite;
    public function new(st : MESState)
    {
        super(st);
        mainSprite = new Sprite();
    }
    
}