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
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author 
 */
class StateLevelSelect extends BBBState
{
    var sprite : Sprite;
    var inited : Bool = false;
    var fun : MouseEvent -> Void;
    
    public function new(top : Top) 
    {
        super(top);
        sprite = new Sprite();
        
        var uiInstance = UIBuilder.buildFn('data/ui/uiLevelSelect.xml')();
        var content = Assets.getText("levels/levellist.xml");
        var xml = Xml.parse(content);
        var root = xml.elementsNamed("root").next();
        var widgets : Array<Button> = new Array();
        var levelwidget = UIBuilder.get('levelstuff');

        for (e in root) {
            if (e.nodeType == Xml.PCData || e.nodeType == Xml.Comment) {
                continue;
            }
            switch(e.nodeName.toLowerCase()) {
            case "level":
                var path = e.get("path");
                var p = new Paint();
                p.border = 1;
                var b = UIBuilder.create(Button, {
                    text : path,
                    skin : p
                }); 

                //fun = loadLevel.bind(b.text);
                //trace();
                b.addEventListener(MouseEvent.MOUSE_DOWN, loadLevel.bind(path));
                levelwidget.addChild(b);

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
        cast(UIBuilder.get('levelstuff'), Widget); // TODO Disable all buttons
    }
    
    override public function enableControl() : Void
    {
    }
    
    override public function get_mainSprite()
    {
        return sprite;
    }
    
    function loadLevel(p : String, event:MouseEvent) : Void
    {
        trace('load level $p');
        top.changeState(new StateTransPan(top, this, StateBridgeLevel.createLevelState(top, p)));
    }
    
}