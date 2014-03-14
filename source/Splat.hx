package;

import flash.display.BitmapData;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxRandom;
import openfl.Assets;

class Splat extends FlxSprite
{
	private var _color:Int = 0;
	private var _dissolveTime:Float = 0;
	private var _argb:ARGB;
	
	static private var _cached:BitmapData;
	static private var _zeroPoint:Point;
	
	inline static private var DISSOLVE_TIME:Float = 2.5;
	
	public function new()
	{
		if ( _cached == null )
		{
			_cached = Assets.getBitmapData( "splat.png" );
			_zeroPoint = new Point(0, 0);
		}
		
		super(0, 0);
		loadGraphic( _cached.clone() );
		scale.set( 8, 8 );
		updateHitbox();
		renew();
	}
	
	public function renew( X:Float = 0, Y:Float = 0 )
	{
		if ( !alive ) {
			revive();
			framePixels = _cached.clone();
		}
		
		setPosition( X, Y );
		_dissolveTime = 0;
	}
	
	override public function update()
	{
		_dissolveTime += FlxG.elapsed;
		
		if ( _dissolveTime < DISSOLVE_TIME )
		{
			for ( yPos in 0...framePixels.height )
			{
				for ( xPos in 0...framePixels.width )
				{
					if ( FlxRandom.chanceRoll( 10 ) )
					{
						_argb = FlxColorUtil.getARGB( framePixels.getPixel32( xPos, yPos ) );
						_color = FlxColorUtil.makeFromARGB( _argb.alpha / 2, _argb.red, _argb.green, _argb.blue );
						framePixels.setPixel32( xPos, yPos, _color );
					}
				}
			}
		}
		else
		{
			kill();
		}
		
		super.update();
	}
}