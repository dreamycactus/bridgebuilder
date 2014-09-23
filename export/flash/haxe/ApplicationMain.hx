import lime.Assets;
#if !macro


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	private static var app:lime.app.Application;
	
	
	public static function create ():Void {
		
		preloader = new openfl.display.Preloader ();
		preloader.onComplete = start;
		preloader.create (config);
		
		#if js
		var urls = [];
		var types = [];
		
		
		urls.push ("img/beam.png");
		types.push (AssetType.IMAGE);
		
		
		urls.push ("img/deck.png");
		types.push (AssetType.IMAGE);
		
		
		urls.push ("fonts/LibreBaskerville-Regular.ttf");
		types.push (AssetType.FONT);
		
		
		urls.push ("fonts/nokiafc22.ttf");
		types.push (AssetType.FONT);
		
		
		urls.push ("levels/b1.xml");
		types.push (AssetType.TEXT);
		
		
		urls.push ("levels/b2.xml");
		types.push (AssetType.TEXT);
		
		
		urls.push ("levels/b3.xml");
		types.push (AssetType.TEXT);
		
		
		urls.push ("levels/bp.xml");
		types.push (AssetType.TEXT);
		
		
		urls.push ("levels/btest.xml");
		types.push (AssetType.TEXT);
		
		
		
		preloader.load (urls, types);
		#end
		
	}
	
	
	public static function main () {
		
		config = {
			
			antialiasing: Std.int (0),
			background: Std.int (2236962),
			borderless: false,
			depthBuffer: false,
			fps: Std.int (30),
			fullscreen: false,
			height: Std.int (576),
			orientation: "",
			resizable: true,
			stencilBuffer: false,
			title: "BridgeBuilderBob",
			vsync: false,
			width: Std.int (1024),
			
		}
		
		#if js
		#if munit
		flash.Lib.embed (null, 1024, 576, "222222");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function start ():Void {
		
		app = new openfl.display.Application ();
		app.create (config);
		
		openfl.Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
		openfl.Lib.current.stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields (com.org.bbb.Main)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		if (hasMain) {
			
			Reflect.callMethod (com.org.bbb.Main, Reflect.field (com.org.bbb.Main, "main"), []);
			
		} else {
			
			var instance:DocumentClass = Type.createInstance (DocumentClass, []);
			
			if (Std.is (instance, openfl.display.DisplayObject)) {
				
				openfl.Lib.current.addChild (cast instance);
				
			}
			
		}
		
		openfl.Lib.current.stage.dispatchEvent (new openfl.events.Event (openfl.events.Event.RESIZE, false, false));
		
		var result = app.exec ();
		
		#if sys
		Sys.exit (result);
		#end
		
	}
	
	
	#if neko
	@:noCompletion public static function __init__ () {
		
		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (Sys.executablePath ()));
		loader.addPath ("./");
		loader.addPath ("@executable_path/");
		
	}
	#end
	
	
}


#if flash @:build(DocumentClass.buildFlash())
#else @:build(DocumentClass.build()) #end
@:keep class DocumentClass extends com.org.bbb.Main {}


#else


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				
				var method = macro {
					
					this.stage = flash.Lib.current.stage;
					super ();
					dispatchEvent (new openfl.events.Event (openfl.events.Event.ADDED_TO_STAGE, false, false));
					
				}
				
				fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: method, params: [], ret: macro :Void }), pos: Context.currentPos () });
				
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
	macro public static function buildFlash ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				var method = macro {
					return flash.Lib.current.stage;
				}
				
				fields.push ({ name: "get_stage", access: [ APrivate ], meta: [ { name: ":getter", params: [ macro stage ], pos: Context.currentPos() } ], kind: FFun({ args: [], expr: method, params: [], ret: macro :flash.display.Stage }), pos: Context.currentPos() });
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end