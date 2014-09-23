package;


import haxe.Timer;
import haxe.Unserializer;
import lime.app.Preloader;
import lime.audio.openal.AL;
import lime.audio.AudioBuffer;
import lime.graphics.Image;
import lime.utils.ByteArray;
import lime.utils.UInt8Array;
import lime.Assets;

#if sys
import sys.FileSystem;
#end

#if flash
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("img/beam.png", __ASSET__img_beam_png);
		type.set ("img/beam.png", AssetType.IMAGE);
		className.set ("img/deck.png", __ASSET__img_deck_png);
		type.set ("img/deck.png", AssetType.IMAGE);
		className.set ("fonts/LibreBaskerville-Regular.ttf", __ASSET__fonts_librebaskerville_regular_ttf);
		type.set ("fonts/LibreBaskerville-Regular.ttf", AssetType.FONT);
		className.set ("fonts/nokiafc22.ttf", __ASSET__fonts_nokiafc22_ttf);
		type.set ("fonts/nokiafc22.ttf", AssetType.FONT);
		className.set ("levels/b1.xml", __ASSET__levels_b1_xml);
		type.set ("levels/b1.xml", AssetType.TEXT);
		className.set ("levels/b2.xml", __ASSET__levels_b2_xml);
		type.set ("levels/b2.xml", AssetType.TEXT);
		className.set ("levels/b3.xml", __ASSET__levels_b3_xml);
		type.set ("levels/b3.xml", AssetType.TEXT);
		className.set ("levels/bp.xml", __ASSET__levels_bp_xml);
		type.set ("levels/bp.xml", AssetType.TEXT);
		className.set ("levels/btest.xml", __ASSET__levels_btest_xml);
		type.set ("levels/btest.xml", AssetType.TEXT);
		
		
		#elseif html5
		
		var id;
		id = "img/beam.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "img/deck.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "fonts/LibreBaskerville-Regular.ttf";
		className.set (id, __ASSET__fonts_librebaskerville_regular_ttf);
		
		type.set (id, AssetType.FONT);
		id = "fonts/nokiafc22.ttf";
		className.set (id, __ASSET__fonts_nokiafc22_ttf);
		
		type.set (id, AssetType.FONT);
		id = "levels/b1.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "levels/b2.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "levels/b3.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "levels/bp.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "levels/btest.xml";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		
		
		#else
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("img/beam.png", __ASSET__img_beam_png);
		type.set ("img/beam.png", AssetType.IMAGE);
		
		className.set ("img/deck.png", __ASSET__img_deck_png);
		type.set ("img/deck.png", AssetType.IMAGE);
		
		className.set ("fonts/LibreBaskerville-Regular.ttf", __ASSET__fonts_librebaskerville_regular_ttf);
		type.set ("fonts/LibreBaskerville-Regular.ttf", AssetType.FONT);
		
		className.set ("fonts/nokiafc22.ttf", __ASSET__fonts_nokiafc22_ttf);
		type.set ("fonts/nokiafc22.ttf", AssetType.FONT);
		
		className.set ("levels/b1.xml", __ASSET__levels_b1_xml);
		type.set ("levels/b1.xml", AssetType.TEXT);
		
		className.set ("levels/b2.xml", __ASSET__levels_b2_xml);
		type.set ("levels/b2.xml", AssetType.TEXT);
		
		className.set ("levels/b3.xml", __ASSET__levels_b3_xml);
		type.set ("levels/b3.xml", AssetType.TEXT);
		
		className.set ("levels/bp.xml", __ASSET__levels_bp_xml);
		type.set ("levels/bp.xml", AssetType.TEXT);
		
		className.set ("levels/btest.xml", __ASSET__levels_btest_xml);
		type.set ("levels/btest.xml", AssetType.TEXT);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						if (eventCallback != null) {
							
							eventCallback (this, "change");
							
						}
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var assetType = this.type.get (id);
		
		if (assetType != null) {
			
			if (assetType == requestedType || ((requestedType == SOUND || requestedType == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if ((assetType == BINARY || assetType == TEXT) && requestedType == BINARY) {
				
				return true;
				
			} else if (path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (requestedType == BINARY || requestedType == null) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getAudioBuffer (id:String):AudioBuffer {
		
		#if flash
		
		var buffer = new AudioBuffer ();
		buffer.src = cast (Type.createInstance (className.get (id), []), Sound);
		return buffer;
		
		#elseif js
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return AudioBuffer.fromFile (path.get (id));
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		//else return new Sound (new URLRequest (path.get (id)), null, type.get (id) == MUSIC);
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if flash
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
		#elseif js
		
		var bytes:ByteArray = null;
		var data = Preloader.loaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			bytes = new ByteArray ();
			bytes.writeUTFBytes (data);
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}
		
		if (bytes != null) {
			
			bytes.position = 0;
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		//return null;
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), ByteArray);
		//else 
		return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Dynamic /*Font*/ {
		
		// TODO: Complete Lime Font API
		
		#if openfl
		#if (flash || js)
		
		return cast (Type.createInstance (className.get (id), []), openfl.text.Font);
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			openfl.text.Font.registerFont (fontClass);
			return cast (Type.createInstance (fontClass, []), openfl.text.Font);
			
		} else {
			
			return new openfl.text.Font (path.get (id));
			
		}
		
		#end
		#end
		
		return null;
		
	}
	
	
	public override function getImage (id:String):Image {
		
		#if flash
		
		return Image.fromBitmapData (cast (Type.createInstance (className.get (id), []), BitmapData));
		
		#elseif js
		
		return Image.fromImageElement (Preloader.images.get (path.get (id)));
		
		#else
		
		return Image.fromFile (path.get (id));
		
		#end
		
	}
	
	
	/*public override function getMusic (id:String):Dynamic {
		
		#if flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		//var sound = new Sound ();
		//sound.__buffer = true;
		//sound.load (new URLRequest (path.get (id)));
		//return sound;
		return null;
		
		#elseif js
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return null;
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		//else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}*/
	
	
	public override function getPath (id:String):String {
		
		//#if ios
		
		//return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		//#else
		
		return path.get (id);
		
		//#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if js
		
		var bytes:ByteArray = null;
		var data = Preloader.loaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			return cast data;
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}
		
		if (bytes != null) {
			
			bytes.position = 0;
			return bytes.readUTFBytes (bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		
		#if flash
		
		if (requestedType != AssetType.MUSIC && requestedType != AssetType.SOUND) {
			
			return className.exists (id);
			
		}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:String):Array<String> {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (requestedType == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadAudioBuffer (id:String, handler:AudioBuffer -> Void):Void {
		
		#if (flash || js)
		
		//if (path.exists (id)) {
			
		//	var loader = new Loader ();
		//	loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
		//		handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
		//	});
		//	loader.load (new URLRequest (path.get (id)));
			
		//} else {
			
			handler (getAudioBuffer (id));
			
		//}
		
		#else
		
		handler (getAudioBuffer (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
		#else
		
		handler (getBytes (id));
		
		#end
		
	}
	
	
	public override function loadImage (id:String, handler:Image -> Void):Void {
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bitmapData = cast (event.currentTarget.content, Bitmap).bitmapData;
				handler (Image.fromBitmapData (bitmapData));
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getImage (id));
			
		}
		
		#else
		
		handler (getImage (id));
		
		#end
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = ByteArray.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = ByteArray.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = ByteArray.readFile ("assets/manifest");
			#else
			var bytes = ByteArray.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				bytes.position = 0;
				
				if (bytes.length > 0) {
					
					var data = bytes.readUTFBytes (bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								path.set (asset.id, asset.path);
								type.set (asset.id, cast (asset.type, AssetType));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	/*public override function loadMusic (id:String, handler:Dynamic -> Void):Void {
		
		#if (flash || js)
		
		//if (path.exists (id)) {
			
		//	var loader = new Loader ();
		//	loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
		//		handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
		//	});
		//	loader.load (new URLRequest (path.get (id)));
			
		//} else {
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}*/
	
	
	public override function loadText (id:String, handler:String -> Void):Void {
		
		//#if js
		
		/*if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (event.currentTarget.data);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getText (id));
			
		}*/
		
		//#else
		
		var callback = function (bytes:ByteArray):Void {
			
			if (bytes == null) {
				
				handler (null);
				
			} else {
				
				handler (bytes.readUTFBytes (bytes.length));
				
			}
			
		}
		
		loadBytes (id, callback);
		
		//#end
		
	}
	
	
}


#if !display
#if flash

//@:keep class __ASSET__img_beam_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
//@:keep class __ASSET__img_deck_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
//@:keep class __ASSET__fonts_librebaskerville_regular_ttf extends flash.text.Font { }
//@:keep class __ASSET__fonts_nokiafc22_ttf extends flash.text.Font { }
//@:keep class __ASSET__levels_b1_xml extends flash.utils.ByteArray { }
//@:keep class __ASSET__levels_b2_xml extends flash.utils.ByteArray { }
//@:keep class __ASSET__levels_b3_xml extends flash.utils.ByteArray { }
//@:keep class __ASSET__levels_bp_xml extends flash.utils.ByteArray { }
//@:keep class __ASSET__levels_btest_xml extends flash.utils.ByteArray { }
//

#elseif html5

#if openfl


@:keep class __ASSET__fonts_librebaskerville_regular_ttf extends openfl.text.Font { public function new () { super (); fontName = "fonts/LibreBaskerville-Regular.ttf"; } } 
@:keep class __ASSET__fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { super (); fontName = "fonts/nokiafc22.ttf"; } } 






#end

#elseif (windows || mac || linux)


//@:bitmap("assets/img/beam.png") class __ASSET__img_beam_png extends openfl.display.BitmapData {}
//@:bitmap("assets/img/deck.png") class __ASSET__img_deck_png extends openfl.display.BitmapData {}
//@:font("assets/fonts/LibreBaskerville-Regular.ttf") class __ASSET__fonts_librebaskerville_regular_ttf extends openfl.text.Font {}
//@:font("assets/fonts/nokiafc22.ttf") class __ASSET__fonts_nokiafc22_ttf extends openfl.text.Font {}
//@:file("data/levels/b1.xml") class __ASSET__levels_b1_xml extends lime.utils.ByteArray {}
//@:file("data/levels/b2.xml") class __ASSET__levels_b2_xml extends lime.utils.ByteArray {}
//@:file("data/levels/b3.xml") class __ASSET__levels_b3_xml extends lime.utils.ByteArray {}
//@:file("data/levels/bp.xml") class __ASSET__levels_bp_xml extends lime.utils.ByteArray {}
//@:file("data/levels/btest.xml") class __ASSET__levels_btest_xml extends lime.utils.ByteArray {}
//


#end
#end

