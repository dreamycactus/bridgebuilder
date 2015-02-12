package com.org.bbb.editor ;
import com.org.bbb.control.CmpControl;
import com.org.bbb.physics.CmpAnchor;
import com.org.bbb.widgets.MyInputText;
import com.org.mes.Cmp;
import haxe.ds.StringMap;
import nape.phys.Body;
import ru.stablex.ui.layouts.Column;
import ru.stablex.ui.skins.Paint;
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
class CmpAnchorInstance extends CmpControl implements EditorCmpInstance
{
    var cmpAnchor(default, set): CmpAnchor;
    public var fields : Widget;
    var col1: Widget;
    var col2: Widget;
    
    var xrow : MyInputText;
    var yrow : MyInputText;
    static var count = 0;
    public function new() 
    {
        super();
                
        var xlabel = UIBuilder.create(Text, {
            defaults : "EditorCmpLabel",
            text : "x"
        });
        xrow = UIBuilder.create(MyInputText, {
            w : 120,
            text : "0",
        });
        xrow.onTextChange = function() {
            var parsed = Std.parseFloat(xrow.text);
            if (!Math.isNaN(parsed))
                cmpAnchor.x = parsed;
        };
        
        var columnLayout = new Column();
        columnLayout.cols = [80, 120];
        var p = new Paint();
        p.color = 0x333333;
        col1 = UIBuilder.create(VBox, {
            skin : p,
            align : 'top, left',
            children : [xlabel]
        });
        
        p = new Paint();
        p.color = 0x999999;
        col2 = UIBuilder.create(VBox, {
            skin : p,
            align : 'top, left',
            children : [xrow]
        });
        
        fields = UIBuilder.create(VBox, {
            w : 200,
            layout : columnLayout,
            children : [col1, col2]
        } );
        p = new Paint();
        p.color = 0xffff00;
        var title = UIBuilder.create(Text, {
            defaults : "EditorCmpLabel",
            text : 'CmpAnchor',
            skin : p,
        });
        p = new Paint();
        p.color = 0xff00ff;
        
        widget = UIBuilder.create(VBox, {
            id : 'cmpAnchorInstance${count++}',
            w : 200,
            align : 'top, left',
            children : [title, fields],
            skin : p
        }); 
    }
    
    override public function init() : Void
    {}
    override public function deinit() : Void
    {}
    
    public function bindToCmp(cmp : Cmp) : Void
    {
        if (Std.is(cmp, CmpAnchor)) {
            var cc = cast(cmp, CmpAnchor);
            cmpAnchor = cc;
        }
    }
    public function unbind() : Void
    {
        cmpAnchor = null;
    }
    
    function set_cmpAnchor(ca) : CmpAnchor
    {
        cmpAnchor = ca;
        if (ca != null) {
            xrow.text = Std.string(ca.x);
        }
        return ca;
    }
}