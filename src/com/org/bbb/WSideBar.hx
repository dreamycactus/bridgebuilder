package com.org.bbb;
import motion.Actuate;
import openfl.display.DisplayObject;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.Floating;
import ru.stablex.ui.widgets.VBox;
import ru.stablex.ui.widgets.ViewStack;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author 
 */
class WSideBar extends ViewStack
{
    var menu : VBox;
    var control : VBox;
    var tmpChildren : Array<DisplayObject> = new Array();
    var vvisible : Bool = true;
    
    public function new() 
    {
        super();
    }
    
    public function hidee()
    {
        Actuate.tween(control, 0.3, { alpha : 1 } );
        Actuate.tween(menu, 0.3, { x : 100 } );
    }
    
    public function showw()
    {        
        Actuate.tween(control, 0.3, { alpha : 0 } );
        Actuate.tween(menu, 0.3, { x : 0 } );
    }
    
    public function toggleVisible() : Void
    {
        vvisible = !vvisible;
        if (vvisible) {
            Actuate.tween(control, 0.3, { alpha : 1 } );
            Actuate.tween(menu, 0.3, { x : 100 } );
        } else {
            Actuate.tween(control, 0.3, { alpha : 0 } );
            Actuate.tween(menu, 0.3, { x : 100 } );
        }
    }
    
    override public function addChild(child : DisplayObject) : DisplayObject
    {
        var id = cast(child, Widget).id;
        if (id== "menu") {
            menu = cast(child);
        } else if (id == "control") {
            control = cast(child);
        }
        super.addChild(child);
        return child;
    }
    
}