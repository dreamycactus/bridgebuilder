package com.org.bbb;

import com.org.mes.Entity;
import com.org.mes.EntityType;
import com.org.mes.Top;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.Lib;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.geom.Matrix;
import ru.stablex.ui.UIBuilder;


import nape.geom.Vec2;

class Main extends Sprite 
{
    var inited:Bool;
    var prevTime : Float = 0;
    var top : Top;
    /* ENTRY POINT */
    
    function resize(e) 
    {
        if (!inited) init();
        // else (resize or orientation change)
        GameConfig.stageHeight = Lib.current.stage.stageHeight;
        GameConfig.stageWidth = Lib.current.stage.stageWidth;
        if (top == null) { return; }
            if (top.state.getSystem(SysRender) != null) {
            var msprite = top.state.getSystem(SysRender).mainSprite;
            var sx = Lib.current.stage.stageWidth / 600;
            var sy = Lib.current.stage.stageHeight / 300;
            var scale = Math.min(sy, sx);
            var mat = new Matrix();
            mat.scale(scale, scale);
            }
        //msprite.transform.matrix = mat;
        
        //var cam = top.state.getSystem(SysRender).camera;
        //cam.zoom = scale;
    }
    
    function init() 
    {
        if (inited) return;
        inited = true;
        
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        
        UIBuilder.regClass('CmpControlBuild');
        UIBuilder.regClass('GameConfig');
        UIBuilder.regClass('WControlBar');
        UIBuilder.regClass('WBottomBar');
        UIBuilder.regClass('WSideBar');
        UIBuilder.regSkins('data/ui/skins.xml');
        UIBuilder.init("data/ui/defaults.xml");
        this.stage.addEventListener(Event.ENTER_FRAME, enterFrame);

        GameConfig.init();
        top = new Top();
        EntFactory.inst.top = top;
        var bp = new StateTransPan(top, new BBBState(top), StateBridgeLevel.createLevelState(top, "levels/b1.xml"));
        //var bp = new StateMainMenu(top);
        //var bp = new StateLevelSelect(top);
    
        top.changeState(bp, false);
        resize(null);

    }
    
    function enterFrame(_)
    {
        var curTime = Lib.getTimer();
        var deltaTime:Float = (curTime - prevTime);
        prevTime = curTime;
        
        top.update(deltaTime);
    }

    /* SETUP */

    public function new() 
    {
        super();    
        
        addEventListener(Event.ADDED_TO_STAGE, added);
    }

    function added(e) 
    {
        removeEventListener(Event.ADDED_TO_STAGE, added);
        stage.addEventListener(Event.RESIZE, resize);
        init();
    }
    
    public static function main() 
    {
        // static entry point
        //Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
        //Lib.current.stage.scaleMode = openfl.display.StageScaleMode.EXACT_FIT;
        //Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
#if (cpp && debug)
#if HXCPP_DEBUGGER
        new debugger.Local(true);
#end
#end
        Lib.current.addChild(new Main());
        
    }
}
