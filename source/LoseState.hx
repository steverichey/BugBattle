package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.remoting.Context;
import haxe.remoting.ExternalConnection;

class LoseState extends FlxState
{
	private var _timer:Float = 0;
	private var _ctx:Context;
	private var _cnx:ExternalConnection;
	
	inline static private var MIN_WAIT_TIME:Float = 1;
	inline static private var MAX_WAIT_TIME:Float = 5;
	
	override public function create()
	{
		super.create();
		
		FlxG.camera.bgColor = 0xff020202;
		FlxG.camera.zoom = 4;
		
		var youlose:FlxSprite = new FlxSprite( 0, 0, "youlose.png" );
		youlose.scale.set( 4, 4 );
		youlose.updateHitbox();
		youlose.x = ( 128 - youlose.width ) / 2;
		youlose.y = ( 96 - youlose.height ) / 2;
		
		var total:FlxText = new FlxText(0, 0, 128, Std.string( PlayState.total ));
		total.alignment = "center";
		total.color = 0xff66FAC8;
		total.alpha = 0.25;
		total.y = 96 - total.height;
		
		if ( Main.highScore != -1 && PlayState.total > Main.highScore )
		{
			/**
			* Connect to JavaScript.
			*/
			_ctx = new Context();
			_ctx.addObject("LoseState", LoseState);
			
			try {
				_cnx = ExternalConnection.jsConnect("default", _ctx);
			} catch ( e:Dynamic ) {
				#if debug
				trace( Std.string( e ) );
				#end
			}
			//cnx.JsMain.setText.call( Std.string( Main.highScore ) );
		}
		
		add( youlose );
		add( total );
	}
	
	override public function update()
	{
		_timer += FlxG.elapsed;
		
		if ( _timer > MAX_WAIT_TIME || ( _timer > MIN_WAIT_TIME && FlxG.keys.justPressed.SPACE ) )
		{
			FlxG.switchState( new MenuState() );
		}
		
		super.update();
	}
	
	override public function destroy()
	{
		if ( _ctx != null ) {
			_ctx = null;
		}
		if ( _cnx != null ) {
			_cnx = null;
		}
		
		super.destroy();
	}
}