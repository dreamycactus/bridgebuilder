package com.org.bbb.widgets ;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.HBox;
import ru.stablex.ui.widgets.InputText;
import ru.stablex.ui.widgets.VBox;


class WComponentEditor extends HBox
{
    var col1 : VBox;
    var col2 : VBox;
    
    public function new() 
    {
        super();
        col1 = UIBuilder.create(VBox, { } );
        col2 = UIBuilder.create(VBox, { } );
        
    }
    
    public function addRow(name : String, textfield : InputText)
    {
    }
    
}