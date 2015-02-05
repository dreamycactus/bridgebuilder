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
__ui__widget1.h = 600;
__ui__widget1.id = 'rootWidget';
__ui__widget1.widthPt = 100;
__ui__widget1._onInitialize();
var controlBuild : CmpControlBuild = cast(__ui__arguments.controlBuild, CmpControlBuild);

var __ui__widget2 : ru.stablex.ui.widgets.HBox = new ru.stablex.ui.widgets.HBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("HBox") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("HBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget2);
     }
}
__ui__widget2.padding = 0;
__ui__widget2.right = 0;
__ui__widget2.id = 'topbar';
__ui__widget2.align = 'right,top';
__ui__widget2._onInitialize();

var __ui__widget3 : com.org.bbb.widgets.MyInputText = new com.org.bbb.widgets.MyInputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("MyInputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("MyInputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.text = 'hello';
__ui__widget3.h = 100;
__ui__widget3.w = 100;
__ui__widget3.addEventListener(ru.stablex.ui.events.WidgetEvent.CHANGE, function(event:ru.stablex.ui.events.WidgetEvent){trace('hello');});
if( !Std.is(__ui__widget3.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget3.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget3.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget3.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget3.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
__ui__widget3._onInitialize();
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);

var __ui__widget3 : com.org.bbb.widgets.WControlBar = new com.org.bbb.widgets.WControlBar();
if( ru.stablex.ui.UIBuilder.defaults.exists("WControlBar") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("WControlBar");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.id = 'controlbar';
__ui__widget3.control = __ui__arguments.controlBuild;
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
__ui__widget3.text = 'DODO';
__ui__widget3.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.wcb.show();});
__ui__widget3.h = 100;
__ui__widget3.w = 100;
__ui__widget3.id = 'buttab';
if( !Std.is(__ui__widget3.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget3.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget3.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget3.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget3.skin, ru.stablex.ui.skins.Paint).color = 0xd33682;
cast(__ui__widget3.skin, ru.stablex.ui.skins.Paint).borderColor = 0x6c71c4;
cast(__ui__widget3.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget3._onInitialize();
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);
__ui__widget2._onCreate();
__ui__widget1.addChild(__ui__widget2);

var __ui__widget2 : com.org.bbb.widgets.WSideBar = new com.org.bbb.widgets.WSideBar();
if( ru.stablex.ui.UIBuilder.defaults.exists("WSideBar") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("WSideBar");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget2);
     }
}
__ui__widget2.right = 0;
__ui__widget2.w = 100;
__ui__widget2.id = 'sidebar';
__ui__widget2.top = 150;
__ui__widget2._onInitialize();

var __ui__widget3 : ru.stablex.ui.widgets.VBox = new ru.stablex.ui.widgets.VBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("VBox") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.id = 'menu';
__ui__widget3._onInitialize();

var __ui__widget4 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.text = 'Back';
__ui__widget4.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.levelSelect();});
__ui__widget4.h = 50;
__ui__widget4.w = 100;
if( !Std.is(__ui__widget4.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget4.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget4.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget4.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget4.skin, ru.stablex.ui.skins.Paint).color = 0x9149f2;
cast(__ui__widget4.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget4._onInitialize();
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);

var __ui__widget3 : ru.stablex.ui.widgets.VBox = new ru.stablex.ui.widgets.VBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("VBox") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.id = 'control';
__ui__widget3._onInitialize();

var __ui__widget4 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.text = 'Delete Mode';
__ui__widget4.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.set_beamDeleteMode(true);});
__ui__widget4.h = 50;
__ui__widget4.w = 100;
if( !Std.is(__ui__widget4.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget4.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget4.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget4.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget4.skin, ru.stablex.ui.skins.Paint).color = 0x9149f2;
cast(__ui__widget4.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget4._onInitialize();
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);

var __ui__widget4 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.text = 'Undo';
__ui__widget4.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.undo();});
__ui__widget4.h = 50;
__ui__widget4.w = 100;
if( !Std.is(__ui__widget4.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget4.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget4.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget4.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget4.skin, ru.stablex.ui.skins.Paint).color = 0x9149f2;
cast(__ui__widget4.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget4._onInitialize();
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);

var __ui__widget4 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget4);
     }
}
__ui__widget4.text = 'Start/Stop';
__ui__widget4.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.togglePause();});
__ui__widget4.h = 50;
__ui__widget4.w = 100;
if( !Std.is(__ui__widget4.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget4.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget4.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget4.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget4.skin, ru.stablex.ui.skins.Paint).color = 0x9149f2;
cast(__ui__widget4.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget4._onInitialize();
__ui__widget4._onCreate();
__ui__widget3.addChild(__ui__widget4);
__ui__widget3._onCreate();
__ui__widget2.addChild(__ui__widget3);
__ui__widget2._onCreate();
__ui__widget1.addChild(__ui__widget2);

var __ui__widget2 : com.org.bbb.widgets.WBottomBar = new com.org.bbb.widgets.WBottomBar();
if( ru.stablex.ui.UIBuilder.defaults.exists("WBottomBar") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("WBottomBar");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget2);
     }
}
__ui__widget2.left = 0;
__ui__widget2.bottom = 0;
__ui__widget2.id = 'bottombar';
__ui__widget2.widthPt = 100;
__ui__widget2.heightPt = 5;
if( !Std.is(__ui__widget2.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget2.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget2.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget2.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget2.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFF0;
cast(__ui__widget2.skin, ru.stablex.ui.skins.Paint).alpha = 0.9;
__ui__widget2._onInitialize();

var __ui__widget3 : ru.stablex.ui.widgets.Text = new ru.stablex.ui.widgets.Text();
if( ru.stablex.ui.UIBuilder.defaults.exists("Text") ){
     var defs = 'budgetD'.split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Text");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.text = '100/1000';
__ui__widget3.id = 'budget';
__ui__widget3.defaults = 'budgetD';
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
__ui__widget2.padding = 10;
__ui__widget2.right = 3;
__ui__widget2.autoHeight = true;
__ui__widget2.w = 200;
__ui__widget2.id = 'levelEdit';
__ui__widget2.top = 0;
__ui__widget2.childPadding = 10;
__ui__widget2.renderTo = 'rootWidget';
__ui__widget2._onInitialize();

var __ui__widget3 : ru.stablex.ui.widgets.HBox = new ru.stablex.ui.widgets.HBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("HBox") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("HBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget3);
     }
}
__ui__widget3.top = 0;
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
__ui__widget4.left = 3;
__ui__widget4.padding = 10;
__ui__widget4.autoHeight = true;
__ui__widget4.w = 200;
__ui__widget4.top = 40;
__ui__widget4.childPadding = 10;
__ui__widget4._onInitialize();

var __ui__widget5 : ru.stablex.ui.widgets.HBox = new ru.stablex.ui.widgets.HBox();
if( ru.stablex.ui.UIBuilder.defaults.exists("HBox") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("HBox");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.padding = 10;
__ui__widget5.autoHeight = true;
__ui__widget5.w = 400;
__ui__widget5.childPadding = 10;
__ui__widget5._onInitialize();

var __ui__widget6 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.h = 20;
__ui__widget6.w = 50;
__ui__widget6.id = 'levelWidth';
if( !Std.is(__ui__widget6.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget6.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget6.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget6.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget6.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);

var __ui__widget6 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget6);
     }
}
__ui__widget6.h = 20;
__ui__widget6.w = 50;
__ui__widget6.id = 'levelHeight';
if( !Std.is(__ui__widget6.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget6.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget6.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget6.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget6.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
__ui__widget6._onInitialize();
__ui__widget6._onCreate();
__ui__widget5.addChild(__ui__widget6);
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'x';
__ui__widget5.h = 20;
__ui__widget5.w = 50;
__ui__widget5.id = 'inX';
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'y';
__ui__widget5.h = 20;
__ui__widget5.w = 50;
__ui__widget5.id = 'inY';
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'width';
__ui__widget5.h = 20;
__ui__widget5.w = 50;
__ui__widget5.id = 'inWidth';
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'height';
__ui__widget5.h = 20;
__ui__widget5.w = 50;
__ui__widget5.id = 'inHeight';
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.InputText = new ru.stablex.ui.widgets.InputText();
if( ru.stablex.ui.UIBuilder.defaults.exists("InputText") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'Load level in';
__ui__widget5.h = 100;
__ui__widget5.w = 150;
__ui__widget5.id = 'load';
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0xFFFFFF;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'Generate XML';
__ui__widget5.autoHeight = true;
__ui__widget5.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.generateLevelXML();});
__ui__widget5.w = 100;
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0x00FF00;
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'Load XML';
__ui__widget5.autoHeight = true;
__ui__widget5.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.loadLevelFromXml(null);});
__ui__widget5.w = 100;
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0x00FF00;
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'Create box';
__ui__widget5.autoHeight = true;
__ui__widget5.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.createBox();});
__ui__widget5.w = 100;
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0x00FF00;
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'Create Spawn';
__ui__widget5.autoHeight = true;
__ui__widget5.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.createSpawn();});
__ui__widget5.w = 100;
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0x00FF00;
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).border = 1;
__ui__widget5._onInitialize();
__ui__widget5._onCreate();
__ui__widget4.addChild(__ui__widget5);

var __ui__widget5 : ru.stablex.ui.widgets.Button = new ru.stablex.ui.widgets.Button();
if( ru.stablex.ui.UIBuilder.defaults.exists("Button") ){
     var defs = "Default".split(",");
     var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
     for(i in 0...defs.length){
         var defaultsFn : ru.stablex.ui.widgets.Widget->Void = defFns.get(defs[i]);
         if( defaultsFn != null ) defaultsFn(__ui__widget5);
     }
}
__ui__widget5.text = 'Delete';
__ui__widget5.autoHeight = true;
__ui__widget5.addEventListener(flash.events.MouseEvent.CLICK, function(event:flash.events.MouseEvent){__ui__arguments.controlBuild.deleteLastSelected();});
__ui__widget5.w = 100;
if( !Std.is(__ui__widget5.skin, ru.stablex.ui.skins.Paint) ){
     __ui__widget5.skin = new ru.stablex.ui.skins.Paint();
     if( Std.is(__ui__widget5.skin, ru.stablex.ui.widgets.Widget) ){
         var __tmp__ : ru.stablex.ui.widgets.Widget = cast(__ui__widget5.skin, ru.stablex.ui.widgets.Widget);
         ru.stablex.ui.UIBuilder.applyDefaults(__tmp__);
         __tmp__._onInitialize();
         __tmp__._onCreate();
     }
}
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).color = 0x00FF00;
cast(__ui__widget5.skin, ru.stablex.ui.skins.Paint).border = 1;
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