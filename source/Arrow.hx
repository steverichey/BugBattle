package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxVector;
import flixel.util.FlxVelocity;

class Arrow extends FlxSprite
{
	inline static private var SPEED:Int = 800;
	
	public function new( Angle:Float = 0, Facing:Int = FlxObject.RIGHT )
	{
		super( 128 * 4, 96 * 4 );
		loadGraphic( "arrow.png", false, true );
		scale.set( 8, 8 );
		updateHitbox();
		//height = 5;
		//centerOffsets( true );
		renew( 64 * 4, 48 * 4, Angle, Facing );
	}
	
	public function renew( X:Float, Y:Float, Angle:Float, Facing:Int )
	{
		super.reset( X, Y );
		angle = Angle;
		facing = Facing;
		velocity = FlxVelocity.velocityFromAngle( Std.int( angle ), facing == FlxObject.LEFT ? -SPEED : SPEED );
	}
	
	override public function update():Void
	{
		if ( !isOnScreen( FlxG.camera ) )
		{
			kill();
		}
		
		super.update();
	}
}