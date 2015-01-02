package com.org.bbb;

import com.org.glengine.BrEngine;
import com.org.mes.Entity;
import com.org.mes.EntityType;
import com.org.mes.Top;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.math.Rectangle;
import openfl.geom.Rectangle;
import openfl.display.OpenGLView;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.Lib;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.geom.Matrix;
import openfl.utils.Float32Array;
import ru.stablex.ui.UIBuilder;

#if cpp
import cpp.vm.Profiler;
#end

//import nape.geom.Vec2;

class Main extends Sprite
{
    var inited:Bool;
    var prevTime : Float = 0;
    var top : Top;
    /* ENTRY POINT */
    
    //function resize(e) 
    //{
        //if (!inited) init();
        //// else (resize or orientation change)
        //GameConfig.stageHeight = Lib.current.stage.stageHeight;
        //GameConfig.stageWidth = Lib.current.stage.stageWidth;
        //if (top == null) { return; }
            //if (top.state.getSystem(SysRender) != null) {
            //var msprite = top.state.getSystem(SysRender).mainSprite;
            //var sx = Lib.current.stage.stageWidth / 600;
            //var sy = Lib.current.stage.stageHeight / 300;
            //var scale = Math.min(sy, sx);
            //var mat = new Matrix();
            //mat.scale(scale, scale);
            //}
        ////msprite.transform.matrix = mat;
        //
        ////var cam = top.state.getSystem(SysRender).camera;
        ////cam.zoom = scale;
    //}
    //
    //function init() 
    //{
        //if (inited) return;
        //inited = true;
        //
        //Lib.current.stage.align = StageAlign.TOP_LEFT;
        //Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        //
        //UIBuilder.regClass('CmpControlBuild');
        //UIBuilder.regClass('GameConfig');
        //UIBuilder.regClass('WControlBar');
        //UIBuilder.regClass('WBottomBar');
        //UIBuilder.regClass('WSideBar');
        //UIBuilder.regSkins('data/ui/skins.xml');
        //UIBuilder.init("data/ui/defaults.xml");
        //this.stage.addEventListener(Event.ENTER_FRAME, enterFrame);
//
        //GameConfig.init();
        //top = new Top();
        //EntFactory.inst.top = top;
        ////var bp = new StateTransPan(top, new BBBState(top), StateBridgeLevel.createLevelState(top, "levels/b7.xml"));
        ////var bp = new StateMainMenu(top);
        //var bp = new StateLevelSelect(top);
        //bp.enableControl();
    //
        //top.changeState(bp, false);
        //resize(null);
//
    //}
    
    //function enterFrame(_)
    //{
        //var curTime = Lib.getTimer();
        //var deltaTime:Float = (curTime - prevTime);
        //prevTime = curTime;
        //
        //top.update(deltaTime);
    //}

    /* SETUP */
    //var engine : BrEngine;
    public function new() 
    {
        super();    
        
        //addEventListener(Event.ADDED_TO_STAGE, added);
    }
    
	public override function init (context:RenderContext):Void {
        //engine = new BrEngine();
    }
    
    public override function render (context:RenderContext):Void {
        //engine.renderView(new Rectangle(0, 0, 1024, 576));
    }
    
    public override function update (deltaTime:Int):Void {
        trace('hello');
    }

    function added(e) 
    {
        //removeEventListener(Event.ADDED_TO_STAGE, added);
        //stage.addEventListener(Event.RESIZE, resize);
        //init();
    }
    
    //public static function main() 
    //{
        //// static entry point
        ////Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
        ////Lib.current.stage.scaleMode = openfl.display.StageScaleMode.EXACT_FIT;
        ////Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
//#if cpp
//
//#if (HXCPP_DEBUGGER && debug)
        //new debugger.Local(true);
//#end
//#if HXCPP_STACK_TRACE
        ////cpp.vm.Profiler.start("log.txt");
//#end
        //
//#end      
        ////Lib.current.addChild(new Main());
        //var gl = new BrEngine();
        //Lib.current.addChild(gl.view);
    //}
    
    
}
