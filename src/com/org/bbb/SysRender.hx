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
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Text;
using Lambda;
/**
 * ...
 * @author 
 */
using com.org.bbb.Util;
 
class SysRender extends System
{
    public var level : CmpLevel;
    public var stage : Stage;
    public var camera : Camera;
    public var mainSprite : Sprite;
    public var someStats : TextField;
    var debug:Debug;
    var cmpsToRender : Array<CmpRender>;
    public var drawDebug : Bool = false;
    
    public function new(state : MESState, level : CmpLevel, stage : Stage)
    {
        super(state);
        this.level = level;
        this.cmpsToRender = new Array();
        this.stage = stage;
        someStats = new TextField();
    }
     
    public function addChild(c : DisplayObject)
    {
        camera.sprite.addChild(c);
    }
    
    override public function init()
    {
        this.debug = new ShapeDebug(1300, 800, Lib.current.stage.color);
        this.debug.drawConstraints = true;
        this.debug.cullingEnabled = true;
        
        this.mainSprite = new Sprite();
        
        stage.addChild(this.mainSprite);

        this.camera = new Camera(this);
        this.camera.sprite.addChild(debug.display);
        this.mainSprite.addChild(this.camera.sprite);
        this.mainSprite.addChild(new FPS());
        this.mainSprite.addChild(someStats);
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
        if (drawDebug) {
            debug.draw(level.space);
            debug.flush();
        }
        
        someStats.text = 'State\nEntities Created: ${state.index}\nNum Entities: ${state.ents.length}';
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
            var index = cmpsToRender.insertInPlace(c, higherDisplayLayer);
            if (c.inCamera) {
                c.addToScene(camera.sprite, index);
            } else {
                c.addToScene(mainSprite, index);
            }
        }
    }
    
    function higherDisplayLayer(a : CmpRender, b : CmpRender)
    {
        return a.displayLayer > b.displayLayer;
    }
    
    override public function removed(e : Entity)
    {
        var res = e.getCmpsHavingAncestor(CmpRender);
        for (c in res) {
            cmpsToRender.remove(c);
            if (c.inCamera) {
                c.removeFromScene(camera.sprite);
            } else {
                c.removeFromScene(mainSprite);
            }
        }
    }
    
    public function resize(w : Int, h : Int) : Void
    {
        this.debug = new ShapeDebug(w, h, Lib.current.stage.color);
        this.mainSprite.width = w;
        this.mainSprite.height = h;
        //this.camera.sprite.width = w;
        //this.camera.sprite.height = h;
    }
    

}