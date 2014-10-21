package com.org.bbb;
import com.org.mes.Top;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.text.TextFieldAutoSize;
import ru.stablex.ui.skins.Paint;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Button;

/**
 * ...
 * @author 
 */
class StateLevelSelect extends BBBState
{
    var sprite : Sprite;
    var inited : Bool = false;
    public function new(top : Top) 
    {
        super(top);
        sprite = new Sprite();
        
        var uiInstance = UIBuilder.buildFn('data/ui/uiLevelSelect.xml')();
        var content = Assets.getText("levels/levellist.xml");
        var xml = Xml.parse(content);
        var root = xml.elementsNamed("root").next();
        var widgets : Array<Button> = new Array();

        for (e in root) {
            if (e.nodeType == Xml.PCData || e.nodeType == Xml.Comment) {
                continue;
            }
            switch(e.nodeName.toLowerCase()) {
            case "level":
                var path = e.get("path");
                var b = UIBuilder.create(Button, {
                    text : path,
                });
                var p = new Paint();
                p.border = 1;
                b.skin = p;
                b.addEventListener(MouseEvent.MOUSE_UP, loadLevel.bind(b.text));
                b.onInitialize();
                b.onCreate();
                UIBuilder.get('levelstuff').addChild(b);
            }
        }
        inited = true;
        sprite.addChild(uiInstance);
        
        var titleText = GameConfig.basicTextField("Bridge Builder", 60, 0x839496, TextFieldAutoSize.CENTER);
        titleText.x = (GameConfig.stageWidth-titleText.width)/2;
        titleText.y = GameConfig.stageHeight * 0.1;
        sprite.addChild(titleText);

        
        Lib.current.stage.addChild(sprite);
    }
    
    override public function init()
    {
     
        
    }
    
    override public function deinit()
    {
        Lib.current.stage.removeChild(sprite);
        UIBuilder.get("levelstuff").free(true);
        
    }
    
    override public function disableControl() : Void
    {
    }
    
    override public function enableControl() : Void
    {
    }
    
    override public function get_mainSprite()
    {
        return sprite;
    }
    
    function loadLevel(p : String, _)
    {
        top.changeState(new StateTransPan(top, this, StateBridgeLevel.createLevelState(top, p)));
    }
    
}