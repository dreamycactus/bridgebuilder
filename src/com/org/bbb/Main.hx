package com.org.bbb;

import com.org.mes.Top;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import haxe.macro.Compiler;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;

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
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        
        this.stage.addEventListener(Event.ENTER_FRAME, enterFrame);

		Config.init();
        top = new Top();
        EntFactory.inst.top = top;
        var bp = Config.createLevelState(top, "levels/b1.xml");
        //var bp = new StateMainMenu(top);
    
        top.changeState(bp, false);
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
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		//Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
		//Lib.current.stage.scaleMode = openfl.display.StageScaleMode.EXACT_FIT;
        Lib.current.addChild(new Main());
	}
}
