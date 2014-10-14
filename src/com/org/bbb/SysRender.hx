package com.org.bbb;
import com.org.mes.Entity;
import com.org.mes.MESState;
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
    public var level : CmpLevel;
    public var stage : Stage;
    public var camera : Camera;
    public var mainSprite : Sprite;
    
    public function new(state : MESState, level : CmpLevel, stage : Stage)
    {
        super(state);
        this.level = level;
        this.cmpsToRender = new Array();
        this.stage = stage;
    }
     
    public function addChild(c : DisplayObject)
    {
        camera.sprite.addChild(c);
    }
    
    override public function init()
    {
        this.debug = new ShapeDebug(2000, 2000, Lib.current.stage.color);
        this.debug.drawConstraints = true;
        this.debug.cullingEnabled = true;
        
        this.mainSprite = new Sprite();
        
        stage.addChild(this.mainSprite);

        this.camera = new Camera();
        this.camera.sprite.addChild(debug.display);
        this.mainSprite.addChild(this.camera.sprite);
    }
    
    override public function deinit()
    {
        camera.sprite.removeChild(debug.display);
        stage.removeChild(mainSprite);
    }
    
    override public function update()
    {
        camera.update();

        debug.clear();
        debug.draw(level.space);
        debug.flush();
        
        for (c in cmpsToRender) {
            c.render(state.top.dt);
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
            if (c.inCamera) {
                c.addToScene(camera.sprite);
            } else {
                c.addToScene(mainSprite);
            }
        }
    }
    
    override public function removed(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpRender);
        for (c in res) {
            cmpsToRender.push(c);
            if (c.inCamera) {
                c.removeFromScene(camera.sprite);
            } else {
                c.removeFromScene(mainSprite);
            }
        }
    }
    
    var debug:Debug;
    var cmpsToRender : Array<CmpRender>;
}