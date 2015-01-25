package com.org.bbb.editor ;
import haxe.ds.StringMap;
import nape.phys.Body;
import ru.stablex.ui.layouts.Column;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.HBox;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.VBox;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author ...
 */
//@CmpGroup(CmpControl)
class CmpAnchorInstance extends Widget
{
    var cmpAnchor : CmpAnchor;
    var widgets : Array<Widget> = new Array();
    var col1: Widget;
    var col2: Widget;
    
    public function new() 
    {
        var columnLayout = new Column();
        columnLayout.cols = [0.4, 0.6];
        this.layout = columnLayout;
        col1 = UIBuilder.create(VBox, { } );
        col2 = UIBuilder.create(VBox, { } );
        addChild(col1);
        addChild(col2);
    }
    
    public function set_x(x) : Float
    {
        cmpAnchor.x = x;
        return x;
    }
    
    public function set_body(b) : Body
    {
        cmpAnchor.body = b;
        return b;
    }
}