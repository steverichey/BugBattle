package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxRandom;

class Bug extends FlxSprite
{
	inline static private var SPEED:Float = 200;
	
	public function new()
	{
		super( 128, 96 );
		loadGraphic( "bug.png", true, true, 12, 7 );
		animation.add( "walk", [0, 1], 12 );
		animation.play( "walk" );
		scale.set( 8, 8 );
		updateHitbox();
		renew();
		height += 8;
		centerOffsets();
	}
	
	public function renew()
	{
		super.reset( FlxRandom.chanceRoll() ? -width : 128 * 4, FlxRandom.intRanged( 24, 40 ) * 8 - 4 );
		
		facing = x < 64 * 4 ? FlxObject.RIGHT : FlxObject.LEFT;
		
		if ( facing == FlxObject.LEFT )
		{
			velocity.x = -SPEED + FlxRandom.floatRanged( -SPEED / 2, SPEED / 2);
		}
		else
		{
			velocity.x = SPEED + FlxRandom.floatRanged( -SPEED / 2, SPEED / 2);
		}
	}
	
	override public function update()
	{
		if ( !isOnScreen( FlxG.camera ) )
		{
			kill();
		}
		
		super.update();
	}
}