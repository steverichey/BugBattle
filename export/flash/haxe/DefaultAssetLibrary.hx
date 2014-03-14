package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.text.Font;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import haxe.Unserializer;
import openfl.Assets;

#if (flash || js)
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLLoader;
#end

#if ios
import openfl.utils.SystemPath;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public static var className (default, null) = new Map <String, Dynamic> ();
	public static var path (default, null) = new Map <String, String> ();
	public static var type (default, null) = new Map <String, AssetType> ();
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("arrow.png", __ASSET__arrow_png);
		type.set ("arrow.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("bug.png", __ASSET__bug_png);
		type.set ("bug.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("bugbattle.png", __ASSET__bugbattle_png);
		type.set ("bugbattle.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("dead.png", __ASSET__dead_png);
		type.set ("dead.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("menubg.png", __ASSET__menubg_png);
		type.set ("menubg.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("ow.png", __ASSET__ow_png);
		type.set ("ow.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("ow_alt.png", __ASSET__ow_alt_png);
		type.set ("ow_alt.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("playbg.png", __ASSET__playbg_png);
		type.set ("playbg.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("player.png", __ASSET__player_png);
		type.set ("player.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("pressstart.png", __ASSET__pressstart_png);
		type.set ("pressstart.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("skull.png", __ASSET__skull_png);
		type.set ("skull.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("spider.png", __ASSET__spider_png);
		type.set ("spider.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("splat.png", __ASSET__splat_png);
		type.set ("splat.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("youlose.png", __ASSET__youlose_png);
		type.set ("youlose.png", Reflect.field (AssetType, "image".toUpperCase ()));
		
		
		#elseif html5
		
		path.set ("arrow.png", "arrow.png");
		type.set ("arrow.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("bug.png", "bug.png");
		type.set ("bug.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("bugbattle.png", "bugbattle.png");
		type.set ("bugbattle.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("dead.png", "dead.png");
		type.set ("dead.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("menubg.png", "menubg.png");
		type.set ("menubg.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("ow.png", "ow.png");
		type.set ("ow.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("ow_alt.png", "ow_alt.png");
		type.set ("ow_alt.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("playbg.png", "playbg.png");
		type.set ("playbg.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("player.png", "player.png");
		type.set ("player.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("pressstart.png", "pressstart.png");
		type.set ("pressstart.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("skull.png", "skull.png");
		type.set ("skull.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("spider.png", "spider.png");
		type.set ("spider.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("splat.png", "splat.png");
		type.set ("splat.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("youlose.png", "youlose.png");
		type.set ("youlose.png", Reflect.field (AssetType, "image".toUpperCase ()));
		
		
		#else
		
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
						
						var manifest:Array<AssetData> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							path.set (asset.id, asset.path);
							type.set (asset.id, asset.type);
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest");
				
			}
			
		} catch (e:Dynamic) {
			
			trace ("Warning: Could not load asset manifest");
			
		}
		
		#end
		
	}
	
	
	public override function exists (id:String, type:AssetType):Bool {
		
		var assetType = DefaultAssetLibrary.type.get (id);
		
		#if pixi
		
		if (assetType == IMAGE) {
			
			return true;
			
		} else {
			
			return false;
			
		}
		
		#end
		
		if (assetType != null) {
			
			if (assetType == type || ((type == SOUND || type == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if ((assetType == BINARY || assetType == TEXT) && type == BINARY) {
				
				return true;
				
			} else if (path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (type == BINARY || type == null) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getBitmapData (id:String):BitmapData {
		
		#if pixi
		
		return BitmapData.fromImage (path.get (id));
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), BitmapData);
		
		#elseif js
		
		return cast (ApplicationMain.loaders.get (path.get (id)).contentLoaderInfo.content, Bitmap).bitmapData;
		
		#else
		
		return BitmapData.load (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
		#elseif js
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
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
		
		return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if pixi
		
		return null;
		
		#elseif (flash || js)
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		return new Font (path.get (id));
		
		#end
		
	}
	
	
	public override function getMusic (id:String):Sound {
		
		#if pixi
		
		//return null;		
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}
	
	
	public override function getPath (id:String):String {
		
		#if ios
		
		return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		#else
		
		return path.get (id);
		
		#end
		
	}
	
	
	public override function getSound (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, type.get (id) == MUSIC);
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:AssetType):Bool {
		
		#if flash
		
		if (type != AssetType.MUSIC && type != AssetType.SOUND) {
			
			return className.exists (id);
			
		}
		
		#end
		
		return true;
		
	}
	
	
	public override function loadBitmapData (id:String, handler:BitmapData -> Void):Void {
		
		#if pixi
		
		handler (getBitmapData (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBitmapData (id));
			
		}
		
		#else
		
		handler (getBitmapData (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if pixi
		
		handler (getBytes (id));
		
		#elseif (flash || js)
		
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
	
	
	public override function loadFont (id:String, handler:Font -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getFont (id));
			
		//}
		
		#else
		
		handler (getFont (id));
		
		#end
		
	}
	
	
	public override function loadMusic (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}
	
	
	public override function loadSound (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getSound (id));
			
		//}
		
		#else
		
		handler (getSound (id));
		
		#end
		
	}
	
	
}


#if pixi
#elseif flash

class __ASSET__arrow_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__bug_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__bugbattle_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__dead_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__menubg_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__ow_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__ow_alt_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__playbg_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__player_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__pressstart_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__skull_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__spider_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__splat_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__youlose_png extends flash.display.BitmapData { public function new () { super (0, 0); } }


#elseif html5

















#end