package com.org.bbb;
import com.org.bbb.BuildMat.MatType;
import com.org.bbb.GameConfig.MaterialNames;
import haxe.ds.IntMap;
import motion.Actuate;
import nape.phys.Material;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import ru.stablex.ui.skins.Paint;
import ru.stablex.ui.skins.Skin;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Bmp;
import ru.stablex.ui.widgets.Box;
import ru.stablex.ui.widgets.Button;
import ru.stablex.ui.widgets.HBox;
import ru.stablex.ui.widgets.VBox;
import ru.stablex.ui.widgets.Widget;

/**
 * ...
 * @author 
 */
using Lambda;
enum WidgetState { TRANSITIONING; IDLE; }

class WControlBar extends HBox
{
    public var state : WidgetState;
    public var wmaterials : HBox;
    public var control : CmpControlBuild;
    var materials : IntMap<Button> = new IntMap();
    var currentMat : MaterialNames;
    var buttonTab : Button;
    
    
    var matBut = 'matBut';
    
    public function new() 
    {
        super();
        this.state = WidgetState.IDLE;
        currentMat = MaterialNames.STEEL;

    }
    
    public function hide()
    {
        Actuate.tween(this, 0.5, { y : -this.height } );
        cast(UIBuilder.get('sidebar'), WSideBar).hidee();
        
    }
    
    public function show()
    {
        Actuate.tween(this, 0.5, { y :0 } );
        cast(UIBuilder.get('sidebar'), WSideBar).showw();
    }
    
    public function expandToScreen() : Void
    {
        //addChild(
    }
    
    function setButtonColor(col : Int, b : Button) : Void
    {
        b.skin.as(Paint).color = col;
        b.refresh();
    }
    
    public function setMaterial(m : MaterialNames) : Void
    {
        materials.iter(setButtonColor.bind(0x6c71c4));
        currentMat = m;
        if (MaterialNames.NULL == m) {
            buttonTab.text = "Delete";
        } else {
            var b = materials.get(Type.enumIndex(m));
            if (b != null) {
                setButtonColor(0xd33682, b);
                buttonTab.text = b.text;
            }
        }
        
        
    }
    
    public function addMaterialButtons(arr : Array<String>) : Void
    {
        for (a in arr) {
            var mat = GameConfig.nameToMat(a);
            if (mat != null) {
                var but = UIBuilder.create(Button, {
                    w : 100
                ,   h : 50
                ,   skinName : matBut
                ,   text : a
                });
                addChild(but);
                but.addEventListener(MouseEvent.CLICK, onMaterialButtonClick.bind(a)); 
            }
        }
        if (buttonTab == null) {
            buttonTab = cast(UIBuilder.get('buttab'));
        }
        UIBuilder.get('topbar').resize(this.width+buttonTab.width, this.height);
    }
    
    override public function addChild(child:DisplayObject) : DisplayObject
    {
        if (Std.is(child, Button)) {
            var b = cast(child, Button);
            var text = b.text;
            switch(text) {
            case GameConfig.tcable:
                materials.set(Type.enumIndex(MaterialNames.CABLE), b);
            case GameConfig.tsupercable:
                materials.set(Type.enumIndex(MaterialNames.SUPERCABLE), b);
            case GameConfig.twood:
                materials.set(Type.enumIndex(MaterialNames.WOOD), b);
            case GameConfig.tconcrete:
                materials.set(Type.enumIndex(MaterialNames.CONCRETE), b);
            case GameConfig.tsteel:
                materials.set(Type.enumIndex(MaterialNames.STEEL), b);
            case GameConfig.tdelete:
                materials.set(Type.enumIndex(MaterialNames.NULL), b);
            }
        }
        return super.addChild(child);
    }
    
    function onMaterialButtonClick(matName : String, m : MouseEvent)
    {
        control.material = GameConfig.nameToMat(matName);
    }

}