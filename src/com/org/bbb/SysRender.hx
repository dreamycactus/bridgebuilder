package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.System;
import com.org.mes.Top;
import flash.display.Stage;
import flash.Lib;
import nape.space.Space;
import nape.util.Debug;
import nape.util.ShapeDebug;
using Lambda;
/**
 * ...
 * @author 
 */
class SysRender extends System
{
    public var space : Space;
    public var stage : Stage;
    
    public function new(top : Top, space : Space, stage : Stage)
    {
        super(top);
        this.space = space;
        this.cmpsToRender = new Array();
        
        this.debug = new ShapeDebug(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, Lib.current.stage.color);
        this.debug.drawConstraints = true;
        this.stage = stage;
        
        stage.addChild(debug.display);
    }
    
    override public function update()
    {
        debug.clear();
        debug.draw(space);
        debug.flush();
        
        for (c in cmpsToRender) {
            c.render(top.dt);
        }
    }
    
    override public function isValidEnt(e : Entity) : Bool
    {
        
        if ( e.getCmpsHavingAncestor(CmpRender).length > 0 ) {
            var c : CmpRenderGrid;
            return true;
        }
        return false;
    }
    
    override public function inserted(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpRender);
        for (c in res) {
            cmpsToRender.push(c);
            c.addToScene();
        }
    }
    
    var debug:Debug;
    var cmpsToRender : Array<CmpRender>;
}