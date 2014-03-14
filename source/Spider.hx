package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxRandom;

class Spider extends FlxSprite
{
	inline static private var SPEED:Float = 900;
	inline static public function POSITIONS():Array<Float>
	{
		return [ 40, 184, 328 ];
	}
	
	public function new()
	{
		super( 128, 96, "spider.png" );
		scale.set( 8, 8 );
		updateHitbox();
	}
	
	public function renew( Position:Int )
	{
		super.reset( POSITIONS()[ Position ], -height );
		velocity.y = SPEED;
	}
	
	override public function update()
	{
		super.update();
		
		if ( y > 0 )
		{
			y = 0;
			velocity.y = 0;
		}
	}
}