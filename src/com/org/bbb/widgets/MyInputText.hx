package com.org.bbb.widgets;
import openfl.events.Event;
import openfl.events.FocusEvent;
import ru.stablex.ui.events.WidgetEvent;
import ru.stablex.ui.skins.Paint;
import ru.stablex.ui.widgets.InputText;

/**
 * ...
 * @author ...
 */
class MyInputText extends InputText
{
    static function _onTextChange(e:Event)
    {
        var itext = cast(e.currentTarget, MyInputText);
        itext.onTextChange();
    }
    static function _onFocus(e:FocusEvent)
    {
        var itext = cast(e.currentTarget, MyInputText);
        itext.onFocus();
    }
    static function _onUnfocus(e:FocusEvent)
    {
        var itext = cast(e.currentTarget, MyInputText);
        itext.onUnfocus();
    }
    public function new() 
    {
        super();
        this.label.multiline = false;
        
        addEventListener(Event.CHANGE, MyInputText._onTextChange);
        addEventListener(FocusEvent.FOCUS_IN, MyInputText._onFocus);
        addEventListener(FocusEvent.FOCUS_OUT, MyInputText._onUnfocus);
    }
    
    public dynamic function onTextChange() : Void {}
    public dynamic function onFocus() : Void {}
    public dynamic function onUnfocus() : Void {}
}