(function() : Void {
flash.Lib.current.stage.removeEventListener(flash.events.Event.ENTER_FRAME, ru.stablex.ui.UIBuilder.skinQueue);
flash.Lib.current.stage.addEventListener(flash.events.Event.ENTER_FRAME, ru.stablex.ui.UIBuilder.skinQueue);
if( !ru.stablex.ui.UIBuilder.defaults.exists("Text") ) ru.stablex.ui.UIBuilder.defaults.set("Text", new Map());
ru.stablex.ui.UIBuilder.defaults.get("Text").set("Default", function(__ui__widget0:ru.stablex.ui.widgets.Widget) : Void {
var __ui__widget1 : ru.stablex.ui.widgets.Text = cast(__ui__widget0, ru.stablex.ui.widgets.Text);
__ui__widget1.format.font = ru.stablex.Assets.getFont('fonts/LibreBaskerville-Regular.ttf').fontName;
__ui__widget1.format.size = 8;
__ui__widget1.label.embedFonts = true;
__ui__widget1.label.selectable = false;
});
ru.stablex.ui.UIBuilder.defaults.get("Text").set("budgetD", function(__ui__widget0:ru.stablex.ui.widgets.Widget) : Void {
var __ui__widget1 : ru.stablex.ui.widgets.Text = cast(__ui__widget0, ru.stablex.ui.widgets.Text);
__ui__widget1.format.font = ru.stablex.Assets.getFont('fonts/LibreBaskerville-Regular.ttf').fontName;
__ui__widget1.format.size = 12;
__ui__widget1.label.embedFonts = true;
__ui__widget1.label.selectable = false;
});
ru.stablex.ui.UIBuilder.defaults.get("Text").set("EditorCmpLabel", function(__ui__widget0:ru.stablex.ui.widgets.Widget) : Void {
var __ui__widget1 : ru.stablex.ui.widgets.Text = cast(__ui__widget0, ru.stablex.ui.widgets.Text);
__ui__widget1.format.font = ru.stablex.Assets.getFont('fonts/CONSOLA.TTF').fontName;
__ui__widget1.format.size = 12;
__ui__widget1.label.embedFonts = true;
__ui__widget1.skinName = 'EditorRow';
__ui__widget1.label.selectable = false;
});
if( !ru.stablex.ui.UIBuilder.defaults.exists("InputText") ) ru.stablex.ui.UIBuilder.defaults.set("InputText", new Map());
ru.stablex.ui.UIBuilder.defaults.get("InputText").set("Default", function(__ui__widget0:ru.stablex.ui.widgets.Widget) : Void {
var __ui__widget1 : ru.stablex.ui.widgets.InputText = cast(__ui__widget0, ru.stablex.ui.widgets.InputText);
__ui__widget1.format.font = ru.stablex.Assets.getFont('fonts/LibreBaskerville-Regular.ttf').fontName;
__ui__widget1.format.size = 8;
__ui__widget1.label.width = 200;
__ui__widget1.label.autoSize = openfl.text.TextFieldAutoSize.NONE;
__ui__widget1.label.embedFonts = true;
__ui__widget1.w = 200;
__ui__widget1.label.filters = [new openfl.filters.GlowFilter(0x333333, 1, 2, 2)];
if( !Std.is(__ui__widget1.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget1.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget1.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget1.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget1.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
cast(__ui__widget1.skin, ru.stablex.ui.skins.Paint).borderColor = 0xcdc4d9;
cast(__ui__widget1.skin, ru.stablex.ui.skins.Paint).border = 2;
});
if( !ru.stablex.ui.UIBuilder.defaults.exists("MyInputText") ) ru.stablex.ui.UIBuilder.defaults.set("MyInputText", new Map());
ru.stablex.ui.UIBuilder.defaults.get("MyInputText").set("EditorCmpField", function(__ui__widget0:ru.stablex.ui.widgets.Widget) : Void {
var __ui__widget1 : com.org.bbb.widgets.MyInputText = cast(__ui__widget0, com.org.bbb.widgets.MyInputText);
__ui__widget1.format.font = ru.stablex.Assets.getFont('fonts/CONSOLA.TTF').fontName;
__ui__widget1.format.size = 12;
__ui__widget1.autoHeight = true;
__ui__widget1.label.embedFonts = true;
__ui__widget1.w = 120;
__ui__widget1.skinName = 'EditorRow';
__ui__widget1.label.selectable = true;
});
if( !ru.stablex.ui.UIBuilder.defaults.exists("Button") ) ru.stablex.ui.UIBuilder.defaults.set("Button", new Map());
ru.stablex.ui.UIBuilder.defaults.get("Button").set("Default", function(__ui__widget0:ru.stablex.ui.widgets.Widget) : Void {
var __ui__widget1 : ru.stablex.ui.widgets.Button = cast(__ui__widget0, ru.stablex.ui.widgets.Button);
__ui__widget1.padding = 5;
__ui__widget1.format.color = 0xcdc4d9  ;
__ui__widget1.format.font = ru.stablex.Assets.getFont('fonts/LibreBaskerville-Regular.ttf').fontName;
__ui__widget1.format.size = 14;
__ui__widget1.label.autoSize = openfl.text.TextFieldAutoSize.LEFT;
__ui__widget1.label.embedFonts = true;
__ui__widget1.h = 30;
__ui__widget1.format.align = openfl.text.TextFormatAlign.CENTER;
__ui__widget1.label.mouseEnabled = false;
__ui__widget1.label.selectable = false;
if( !Std.is(__ui__widget1.skin, ru.stablex.ui.skins.Tile) ){
     __ui__widget1.skin = new ru.stablex.ui.skins.Tile();
     if( Std.is(__ui__widget1.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget1.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget1.skin, ru.stablex.ui.skins.Tile).corners = [10];
});
if( !ru.stablex.ui.UIBuilder.defaults.exists("Scroll") ) ru.stablex.ui.UIBuilder.defaults.set("Scroll", new Map());
ru.stablex.ui.UIBuilder.defaults.get("Scroll").set("EditorCmpPanel", function(__ui__widget0:ru.stablex.ui.widgets.Widget) : Void {
var __ui__widget1 : ru.stablex.ui.widgets.Scroll = cast(__ui__widget0, ru.stablex.ui.widgets.Scroll);
__ui__widget1.hBar.visible = false;
__ui__widget1.h = 600;
__ui__widget1.w = 200;
__ui__widget1.skinName = 'EditorPanel';
if( !Std.is(__ui__widget1.vBar.slider.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget1.vBar.slider.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget1.vBar.slider.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget1.vBar.slider.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget1.vBar.slider.skin, ru.stablex.ui.skins.Paint).color = 0x002200;
});})()