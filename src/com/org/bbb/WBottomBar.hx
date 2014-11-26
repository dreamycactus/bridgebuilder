package com.org.bbb;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.HBox;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.VBox;

/**
 * ...
 * @author 
 */
class WBottomBar extends HBox
{
    var wBudgetText : Text;
    public function new() 
    {
        super();
    }
    
    public function setBudgetText(t : String)
    {
        if (wBudgetText == null) {
            wBudgetText = cast(UIBuilder.get('budget'), Text);
        }
        wBudgetText.text = t;
    }
}