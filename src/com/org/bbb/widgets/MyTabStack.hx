package com.org.bbb.widgets;

import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.TabPage;
import ru.stablex.ui.widgets.TabStack;

/**
 * ...
 * @author ...
 */
class MyTabStack extends TabStack
{
    var sentinel : TabPage;
    public function new() 
    {
        super();
        
        sentinel = UIBuilder.create(TabPage);
        addChild(sentinel);
    }
    
}