package com.org.bbb;
import com.org.mes.System;
import com.org.mes.Top;
import flash.Lib;
import nape.space.Space;
import nape.util.Debug;
import nape.util.ShapeDebug;

/**
 * ...
 * @author 
 */
class SysRender extends System
{
    public var space : Space;
    
    public function new(top : Top, space : Space)
    {
        super(top);
        this.space = space;
        debug = new ShapeDebug(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, Lib.current.stage.color);
        debug.drawConstraints = true;
        Lib.current.addChild(debug.display);
    }
    
    override public function update()
    {
        debug.clear();
        debug.draw(space);
        debug.flush();
    }
    
    var debug:Debug;
}