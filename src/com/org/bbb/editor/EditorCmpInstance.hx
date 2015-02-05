package com.org.bbb.editor;
import com.org.mes.Cmp;
import ru.stablex.ui.widgets.Widget;

/**
 * @author 
 */
interface EditorCmpInstance 
{
    var widget : Widget;
    public function bindToCmp(cmp : Cmp) : Void;
    public function unbind() : Void;
}