package;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxSpriteUtil;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		if ( Main.highScore == -1 )
		{
			var ul = new URLLoader();
			ul.addEventListener( Event.COMPLETE, onScoreLoaded, false, 0, true );
			ul.load( new URLRequest("score.txt") );
		}
		
		FlxG.mouse.visible = false;
		FlxG.camera.bgColor = 0xff698B9C;
		FlxG.camera.zoom = 4;
		
		var bg:FlxSprite = new FlxSprite( 0, 0, "menubg.png" );
		bg.scale.set( 2, 2 );
		bg.updateHitbox();
		bg.setPosition( 0, 96 - bg.height );
		
		var skull1:FlxSprite = new FlxSprite( 0, 0, "skull.png" );
		skull1.scale.set( 2, 2 );
		skull1.updateHitbox();
		skull1.setPosition( 2, 2 );
		
		var skull2:FlxSprite = new FlxSprite( 0, 0, "skull.png" );
		skull2.scale.set( 2, 2 );
		skull2.updateHitbox();
		skull2.setPosition( 128 - skull2.width - 2, 2 );
		
		var bugbattle:FlxSprite = new FlxSprite( 0, 0, "bugbattle.png" );
		bugbattle.x = ( 128 - 105 ) / 2;
		bugbattle.y = ( 96 - 50 ) / 2 - 8;
		
		var pressstart:FlxSprite = new FlxSprite( 0, 0, "pressstart.png" );
		pressstart.scale.set( 2, 2 );
		pressstart.updateHitbox();
		pressstart.x = ( 128 - pressstart.width ) / 2;
		pressstart.y = 96 - pressstart.height - 6;
		
		add( bg );
		add( skull1 );
		add( skull2 );
		add( bugbattle );
		add( pressstart );
	}
	
	override public function update():Void
	{
		if ( FlxG.keys.justPressed.SPACE )
		{
			FlxG.switchState( new PlayState() );
		}
		
		super.update();
	}
	
	private function onScoreLoaded( ?e:Event ):Void
	{
		Main.highScore = Std.parseInt( cast( e.target, URLLoader ).data );
		
		#if debug
		trace( "High score: " + Main.highScore );
		#end
	}
}