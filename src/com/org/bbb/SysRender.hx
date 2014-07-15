package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.System;
import com.org.mes.Top;
import flash.display.Stage;
import flash.Lib;
import nape.space.Space;
import nape.util.Debug;
import nape.util.ShapeDebug;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Text;
using Lambda;
/**
 * ...
 * @author 
 */
class SysRender extends System
{
    public var space : Space;
    public var stage : Stage;
    public var camera : Camera;
    public function new(top : Top, space : Space, stage : Stage)
    {
        super(top);
        this.space = space;
        this.cmpsToRender = new Array();
        
        this.debug = new ShapeDebug(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, Lib.current.stage.color);
        this.debug.drawConstraints = true;
        this.stage = stage;
        
        camera = new Camera();
        camera.mainSprite.addChild(debug.display);
        stage.addChild(camera.mainSprite);
    }
     
    public function addChild(c : DisplayObject)
    {
        camera.mainSprite.addChild(c);
    }
    
    override public function init()
    {
        
    }
    
    override public function update()
    {
        space = top.getSystem(SysPhysics).space;
        camera.update();
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
            c.addToScene(camera.mainSprite);
        }
    }
    
    var debug:Debug;
    var cmpsToRender : Array<CmpRender>;
}