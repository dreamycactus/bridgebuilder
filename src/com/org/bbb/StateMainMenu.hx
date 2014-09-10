package com.org.bbb;
import com.org.mes.MESState;
import com.org.mes.Top;
import flash.display.Stage;
import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.actuators.GenericActuator.IGenericActuator;
import motion.easing.Back;
import motion.easing.Bounce;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Quad;
import motion.easing.Quart;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

/**
 * ...
 * @author 
 */
class StateMainMenu extends BBBState
{
    var sprite : Sprite;
    var titleText : TextField;
    var startText : TextField;
    var stage : Stage;
    var aa : Int = 0;
    var tween : IGenericActuator;
    
    public function new(top : Top)
    {
        super(top);
        sprite = new Sprite();
        
        titleText = Config.basicTextField("Bridge Builder", 60, 0xFFFFFF, TextFieldAutoSize.CENTER);
        titleText.x = (Config.stageWidth-titleText.width)/2;
        titleText.y = Config.stageHeight * 0.1;
        
        startText = Config.basicTextField("Click to start", 30, 0xFFFFFF, TextFieldAutoSize.CENTER);
        startText.x = (Config.stageWidth - startText.width) / 2;
        startText.y = Config.stageHeight * 0.85;
        
        sprite.addChild(titleText);
        sprite.addChild(startText);
        
        this.stage = Lib.current.stage;
    }
    
    
    public override function init()
    {
        tween = Actuate.tween(startText, 1.5, { alpha : 0 } ).ease(Quad.easeInOut).repeat().reflect();
        
        stage.addChild(sprite);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, startLevel);
    }
    
    function startLevel(_)
    {
        top.changeState(new TransPan(top, this, Config.createLevelState(top, "levels/b1.xml")));
    }
    
    public override function deinit()
    {
        Actuate.stop(startText);
        tween = null;
        stage.removeChild(sprite);
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, startLevel);
    }
    
    override public function disableControl() : Void
    {
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, startLevel);
    }
    
    override public function enableControl() : Void
    {
        stage.addEventListener(MouseEvent.MOUSE_DOWN, startLevel);
    }
    
    override public function get_mainSprite()
    {
        return sprite;
    }
    
    
    
}