function(__ui__arguments:Dynamic = null) : ru.stablex.ui.widgets.Widget {
var __ui__widget1 : ru.stablex.ui.widgets.Widget = new ru.stablex.ui.widgets.Widget();
if( ru.stablex.ui.UIBuilder.defaults.exists("Widget") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Widget");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget1);
     }
}
__ui__widget1.h = 1200;
__ui__widget1.id = 'rootWidget';
__ui__widget1.widthPt = 100;
__ui__widget1._onInitialize();
var editor : CmpControlEditor = cast(__ui__arguments.editor, CmpControlEditor);

var __ui__widget2 : ru.stablex.ui.widgets.Floating = new ru.stablex.ui.widgets.Floating();
if( ru.stablex.ui.UIBuilder.defaults.exists("Floating") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Floating");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget2);
     }
}
__ui__widget2.h = 576;
__ui__widget2.w = 1024;
__ui__widget2.id = 'saveFloating';
__ui__widget2.visible = false;
if( !Std.is(__ui__widget2.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget2.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget2.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget2.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget2.skin, ru.stablex.ui.skins.Paint).color = 0x999999;
__ui__widget2._onInitialize();

var __ui__widget3 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.left = 512;
__ui__widget3.h = 200;
__ui__widget3.w = 500;
__ui__widget3.id = 'saveText';
__ui__widget3.top = 250;
__ui__widget3._onInitialize();
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);

var __ui__widget3 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.text = 'Close';
__ui__widget3.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){ru.stablex.ui.UIBuilder.get("saveFloating").visible = false;});
__ui__widget3._onInitialize();
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);
__ui__widget2._onCreate();
__ui__widget1.addChild(__ui__widget2);

var __ui__widget2 : ru.stablex.ui.widgets.Floating = new ru.stablex.ui.widgets.Floating();
if( ru.stablex.ui.UIBuilder.defaults.exists("Floating") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Floating");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget2);
     }
}
__ui__widget2.h = 576;
__ui__widget2.w = 1024;
__ui__widget2.id = 'loadFloating';
__ui__widget2.visible = false;
if( !Std.is(__ui__widget2.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget2.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget2.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget2.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget2.skin, ru.stablex.ui.skins.Paint).color = 0x999999;
__ui__widget2._onInitialize();

var __ui__widget3 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.left = 512;
__ui__widget3.h = 200;
__ui__widget3.w = 500;
__ui__widget3.id = 'loadText';
__ui__widget3.top = 250;
__ui__widget3._onInitialize();
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);

var __ui__widget3 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.text = 'Close';
__ui__widget3.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){ru.stablex.ui.UIBuilder.get("loadFloating").visible = false;});
__ui__widget3._onInitialize();
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);

var __ui__widget3 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.text = 'Load';
__ui__widget3.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.loadLevel(cast(ru.stablex.ui.UIBuilder.get("loadText"),ru.stablex.ui.widgets.Text).text); ru.stablex.ui.UIBuilder.get("loadFloating").visible = false;});
__ui__widget3._onInitialize();
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);
__ui__widget2._onCreate();
__ui__widget1.addChild(__ui__widget2);

var __ui__widget2 : ru.stablex.ui.widgets.HBox = new ru.stablex.ui.widgets.HBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("HBox") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("HBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget2);
     }
}
__ui__widget2.h = 576;
__ui__widget2.w = 1024;
__ui__widget2.align = 'top, left';
__ui__widget2._onInitialize();

var __ui__widget3 : ru.stablex.ui.widgets.TabStack = new ru.stablex.ui.widgets.TabStack();
if( ru.stablex.ui.UIBuilder.defaults.exists("TabStack") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("TabStack");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.left = 100;
__ui__widget3.name = 'editorMenu';
__ui__widget3._onInitialize();

var __ui__widget4 : ru.stablex.ui.widgets.TabPage = new ru.stablex.ui.widgets.TabPage();
if( ru.stablex.ui.UIBuilder.defaults.exists("TabPage") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("TabPage");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.defaults = 'EditorMenu';
__ui__widget4.title.text = 'File';
__ui__widget4._onInitialize();

var __ui__widget5 : ru.stablex.ui.widgets.VBox = new ru.stablex.ui.widgets.VBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("VBox") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.defaults = 'EditorMenu';
__ui__widget5._onInitialize();

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'New Level';
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Load';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){ru.stablex.ui.UIBuilder.get("loadFloating").visible = true;});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Save';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.saveLevel();});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);

var __ui__widget4 : ru.stablex.ui.widgets.TabPage = new ru.stablex.ui.widgets.TabPage();
if( ru.stablex.ui.UIBuilder.defaults.exists("TabPage") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("TabPage");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.defaults = 'EditorMenu';
__ui__widget4.title.text = 'Mode';
__ui__widget4._onInitialize();

var __ui__widget5 : ru.stablex.ui.widgets.VBox = new ru.stablex.ui.widgets.VBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("VBox") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.left = 100;
__ui__widget5.defaults = 'EditorMenu';
__ui__widget5._onInitialize();

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Editor';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.set_mode(EditMode.EDIT);});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Bridge Build';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.set_mode(EditMode.BUILD);});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Game Preview';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.set_mode(EditMode.PLAY);});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);

var __ui__widget4 : ru.stablex.ui.widgets.TabPage = new ru.stablex.ui.widgets.TabPage();
if( ru.stablex.ui.UIBuilder.defaults.exists("TabPage") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("TabPage");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.defaults = 'EditorMenu';
__ui__widget4.title.text = 'Options';
__ui__widget4._onInitialize();

var __ui__widget5 : ru.stablex.ui.widgets.VBox = new ru.stablex.ui.widgets.VBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("VBox") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.left = 200;
__ui__widget5.defaults = 'EditorMenu';
__ui__widget5._onInitialize();

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Draw Nape Debug';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.toggleDrawDebug();});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Draw BBox';
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);

var __ui__widget4 : ru.stablex.ui.widgets.TabPage = new ru.stablex.ui.widgets.TabPage();
if( ru.stablex.ui.UIBuilder.defaults.exists("TabPage") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("TabPage");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.defaults = 'EditorMenu';
__ui__widget4.title.text = 'Create';
__ui__widget4._onInitialize();

var __ui__widget5 : ru.stablex.ui.widgets.VBox = new ru.stablex.ui.widgets.VBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("VBox") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.left = 300;
__ui__widget5.defaults = 'EditorMenu';
__ui__widget5._onInitialize();

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Anchor';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.createDefaultEntity('anchor');});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Terrain';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.createDefaultEntity('terrain');});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Static Sprite';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.createDefaultEntity('sprite');});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Spawn';
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'End';
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);

var __ui__widget4 : ru.stablex.ui.widgets.TabPage = new ru.stablex.ui.widgets.TabPage();
if( ru.stablex.ui.UIBuilder.defaults.exists("TabPage") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("TabPage");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.defaults = 'EditorMenu';
__ui__widget4.title.text = 'Material';
__ui__widget4._onInitialize();

var __ui__widget5 : ru.stablex.ui.widgets.VBox = new ru.stablex.ui.widgets.VBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("VBox") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.left = 400;
__ui__widget5.defaults = 'EditorMenu';
__ui__widget5._onInitialize();

var __ui__widget6 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.text = 'Steel';
__ui__widget6.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){editor.builder.set_material(GameConfig.matSteel);});
__ui__widget6.defaults = 'EditorMenu';
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);

var __ui__widget4 : ru.stablex.ui.widgets.TabPage = new ru.stablex.ui.widgets.TabPage();
if( ru.stablex.ui.UIBuilder.defaults.exists("TabPage") ){
     var defs = 'EditorMenu'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("TabPage");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.defaults = 'EditorMenu';
__ui__widget4.title.text = 'Meh';
__ui__widget4._onInitialize();
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);

var __ui__widget3 : ru.stablex.ui.widgets.Scroll = new ru.stablex.ui.widgets.Scroll();
if( ru.stablex.ui.UIBuilder.defaults.exists("Scroll") ){
     var defs = 'EditorCmpPanel'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Scroll");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.right = 0;
__ui__widget3.w = 300;
__ui__widget3.top = 0;
__ui__widget3.defaults = 'EditorCmpPanel';
__ui__widget3._onInitialize();

var __ui__widget4 : ru.stablex.ui.widgets.VBox = new ru.stablex.ui.widgets.VBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("VBox") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.id = 'cmpedit';
__ui__widget4.align = 'top, left';
__ui__widget4._onInitialize();

var __ui__widget5 : ru.stablex.ui.widgets.Text = new ru.stablex.ui.widgets.Text();
if( ru.stablex.ui.UIBuilder.defaults.exists("Text") ){
     var defs = 'EditorHeading'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Text");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'Entity:';
__ui__widget5.id = 'cmpeditTitle';
__ui__widget5.defaults = 'EditorHeading';
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);
__ui__widget2._onCreate();
__ui__widget1.addChild(__ui__widget2);
__ui__widget1._onCreate();
return __ui__widget1;}