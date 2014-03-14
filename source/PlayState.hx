package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	static public var positions:Array<Bool>;
	static public var total:Int = 0;
	
	private var _cooldown:Float = 0;
	private var _firing:Bool = false;
	private var _dead:Bool = false;
	private var _deathTimer:Float = 0;
	private var _bugTimer:Float = 0;
	private var _pos:Int = 0;
	private var _recycle:Bool = false;
	private var _pointer:Int = 0;
	
	private var _player:FlxSprite;
	private var _arrowPos:FlxPoint;
	private var _deadPlayer:FlxSprite;
	private var _collision:FlxSprite;
	private var _splats:Array<Splat>;
	private var _arrows:Array<Arrow>;
	private var _bugs:Array<Bug>;
	private var _spiders:Array<Spider>;
	private var _bugGroup:FlxGroup;
	private var _spiderGroup:FlxGroup;
	private var _splatGroup:FlxGroup;
	private var _ow:FlxSprite;
	
	inline static private var LEFT_X:Int = 36 * 4;
	inline static private var MID_X:Int = 44 * 4;
	inline static private var RIGHT_X:Int = 52 * 4;
	inline static private var UP_Y:Int = 29 * 4;
	inline static private var DEFAULT_Y:Int = 32 * 4;
	inline static private var DOWN_Y:Int = 40 * 4;
	inline static private var FREQ_BUG:Int = 15;
	inline static private var FREQ_SPIDER:Int = 1;
	inline static private var COOLDOWN_TIME:Float = 0.05;
	inline static private var DEATH_TIME:Float = 3;
	inline static private var BUG_SPAWN_TIME:Float = 0.75;
	
	#if debug
	inline static private var INVINCIBLE:Bool = false;
	#end
	
	override public function create():Void
	{
		super.create();
		
		total = 0;
		
		var bg:FlxSprite = new FlxSprite( 0, 0, "playbg.png" );
		bg.scale.set( 8, 8 );
		bg.updateHitbox();
		bg.setPosition(0, 0);
		
		_player = new FlxSprite( 0, 0 );
		_player.loadGraphic( "player.png", true, true, 14, 15 );
		_player.animation.add( "idle", [0] );
		_player.animation.add( "shoot", [1] );
		_player.animation.play( "idle" );
		_player.scale.set( 8, 8 );
		_player.updateHitbox();
		_player.x = RIGHT_X;
		_player.y = DEFAULT_Y;
		
		_deadPlayer = new FlxSprite( 0, 0, "dead.png" );
		_deadPlayer.scale.set( 8, 8 );
		_deadPlayer.updateHitbox();
		_deadPlayer.setPosition( _player.x - 40, _player.y + 88 );
		_deadPlayer.kill();
		
		_collision = new FlxSprite();
		_collision.makeGraphic( 24, 24, 0xff00ff00 );
		_collision.setPosition( 216, 216 );
		_collision.visible = false;
		
		_arrows = new Array<Arrow>();
		_arrowPos = new FlxPoint();
		
		_bugs = new Array<Bug>();
		_spiders = new Array<Spider>();
		_splats = new Array<Splat>();
		positions = [ false, false, false ];
		_bugGroup = new FlxGroup();
		_spiderGroup = new FlxGroup();
		_splatGroup = new FlxGroup();
		
		_ow = new FlxSprite();
		_ow.loadGraphic( "ow_alt.png", true, false, 276, 74 );
		_ow.animation.add( "ow", [0, 1, 2], 12, false );
		_ow.setPosition( 109, 31 * 8 + 22 );
		_ow.alpha = 0.75;
		_ow.kill();
		
		add( bg );
		add( _player );
		add( _deadPlayer );
		add( _collision );
		add( _splatGroup );
		add( _spiderGroup );
		add( _bugGroup );
		add( _ow );
		
		#if debug
		FlxG.watch.add( _bugs, "length", "numbug" );
		FlxG.watch.add( _arrows, "length", "numarr" );
		#end
	}
	
	override public function update():Void
	{
		if ( _dead )
		{
			_deathTimer += FlxG.elapsed;
			
			if ( _deathTimer > DEATH_TIME )
			{
				FlxG.switchState( new LoseState() );
			}
			
			if ( _ow.animation.get("ow").finished )
			{
				_ow.kill();
			}
			else if ( _ow.alive )
			{
				_ow.update();
			}
			
			//_spiders.update();
			//_arrows.update();
			
			for ( spider in _spiders ) {
				spider.update();
			}
			
			for ( splat in _splats ) {
				splat.update();
			}
			
			for ( arrow in _arrows ) {
				arrow.update();
			}
			
			return;
		}
		
		if ( FlxG.keys.pressed.UP )
		{
			_player.y = UP_Y;
			
			if ( FlxG.keys.pressed.LEFT )
			{
				_player.facing = FlxObject.LEFT;
				_player.x = LEFT_X;
				_player.angle = 45;
			}
			else if ( FlxG.keys.pressed.RIGHT )
			{
				_player.facing = FlxObject.RIGHT;
				_player.x = RIGHT_X;
				_player.angle = -45;
			}
			else
			{
				_player.x = MID_X;
				
				if ( _player.facing == FlxObject.LEFT )
				{
					_player.angle = 90;
				}
				else
				{
					_player.angle = -90;
				}
			}
		}
		else if ( FlxG.keys.pressed.DOWN )
		{
			_player.y = DOWN_Y;
			
			if ( FlxG.keys.pressed.LEFT )
			{
				_player.facing = FlxObject.LEFT;
				_player.x = LEFT_X;
				_player.angle = -45;
			}
			else if ( FlxG.keys.pressed.RIGHT )
			{
				_player.facing = FlxObject.RIGHT;
				_player.x = RIGHT_X;
				_player.angle = 45;
			}
			else
			{
				_player.x = MID_X;
				
				if ( _player.facing == FlxObject.LEFT )
				{
					_player.angle = -90;
				}
				else
				{
					_player.angle = 90;
				}
			}
		}
		else
		{
			if ( FlxG.keys.pressed.LEFT )
			{
				_player.facing = FlxObject.LEFT;
				_player.x = LEFT_X;
				_player.y = DEFAULT_Y;
				_player.angle = 0;
			}
			else if ( FlxG.keys.pressed.RIGHT )
			{
				_player.facing = FlxObject.RIGHT;
				_player.x = RIGHT_X;
				_player.y = DEFAULT_Y;
				_player.angle = 0;
			}
		}
		
		_cooldown += FlxG.elapsed;
		
		if ( FlxG.keys.justPressed.SPACE && _cooldown > COOLDOWN_TIME )
		{
			_player.animation.play( "shoot" );
			_firing = true;
		}
		
		if ( FlxG.keys.justReleased.SPACE && _firing )
		{
			_player.animation.play( "idle" );
			
			_recycle = false;
			
			for ( i in 0..._arrows.length ) {
				if ( !_arrows[i].exists ) {
					_pointer = i;
					_recycle = true;
					break;
				}
			}
			
			var arrow:Arrow;
			
			if ( !_recycle ) {
				arrow = new Arrow();
				_arrows.push( arrow );
				add( arrow );
			} else {
				arrow = _arrows[_pointer];
			}
			
			if ( _player.facing == FlxObject.LEFT )
			{
				switch ( _player.angle ) {
					case 0:
						_arrowPos.set(152,168);
					case 45:
						_arrowPos.set(164,148);
					case -45:
						_arrowPos.set(150,214);
					case 90:
						_arrowPos.set(208,148);
					case -90:
						_arrowPos.set(192,226);
				}
			}
			else if ( _player.facing == FlxObject.RIGHT )
			{
				switch ( _player.angle ) {
					case 0:
						_arrowPos.set(254,168);
					case 45:
						_arrowPos.set(250,214);
					case -45:
						_arrowPos.set(240,144);
					case 90:
						_arrowPos.set(208,224);
					case -90:
						_arrowPos.set(192,148);
				}
			}
			
			arrow.renew( _arrowPos.x, _arrowPos.y, _player.angle, _player.facing );
			_firing = false;
			_cooldown = 0;
		}
		
		_bugTimer += FlxG.elapsed;
		
		if ( _bugTimer > BUG_SPAWN_TIME && FlxRandom.chanceRoll(10) )
		{
			if ( FlxRandom.chanceRoll( 75 ) )
			{
				_recycle = false;
				
				for ( i in 0..._bugs.length ) {
					if ( !_bugs[i].exists ) {
						_pointer = i;
						_recycle = true;
						break;
					}
				}
				
				var bug:Bug;
				
				if ( !_recycle ) {
					bug = new Bug();
					_bugs.push( bug );
					_bugGroup.add( bug );
				} else {
					bug = _bugs[_pointer];
				}
				
				bug.renew();
			}
			else
			{
				_pos = FlxRandom.intRanged( 0, 2 );
				
				if ( !positions[_pos] )
				{
					positions[_pos] = true;
					
					_recycle = false;
					
					for ( i in 0..._spiders.length ) {
						if ( !_spiders[i].exists ) {
							_pointer = i;
							_recycle = true;
							break;
						}
					}
					
					var spider:Spider;
					
					if ( !_recycle ) {
						spider = new Spider();
						_spiders.push( spider );
						_spiderGroup.add( spider );
					} else {
						spider = _spiders[_pointer];
					}
					
					spider.renew( _pos );
				}
			}
			
			_bugTimer = 0;
		}
		
		//_bugs.sort( FlxSort.byY );
		
		var numbug:Int = 0;
		
		for ( b in _bugs )
		{
			if ( b.alive )
				numbug++;
		}
		
		for ( bug in _bugs )
		{
			#if debug
			if ( FlxG.overlap( _collision, bug ) && !INVINCIBLE ) {
			#else
			if ( FlxG.overlap( _collision, bug ) ) {
			#end
				_dead = true;
			}
		}
		
		for ( spider in _spiders )
		{
			#if debug
			if ( FlxG.overlap( _collision, spider ) && !INVINCIBLE ) {
			#else
			if ( FlxG.overlap( _collision, spider ) ) {
			#end
				_dead = true;
			}
		}
		
		if ( _dead ) {
			_player.kill();
			_deadPlayer.revive();
			_ow.revive();
			_ow.animation.play("ow");
		}
		
		for ( arrow in _arrows )
		{
			for ( spider in _spiders )
			{
				FlxG.overlap( arrow, spider, arrowHit );
			}
			
			for ( bug in _bugs )
			{
				FlxG.overlap( arrow, bug, arrowHit );
			}
		}
		
		_bugs.sort( sortY );
		
		super.update();
	}
	
	private function arrowHit( ?arrow:Dynamic, ?hazard:Dynamic ):Void
	{
		total++;
		
		var splat:Splat;
		
		_recycle = false;
		
		for ( i in 0..._splats.length ) {
			if ( !_splats[i].exists ) {
				_pointer = i;
				_recycle = true;
				break;
			}
		}
		
		if ( !_recycle ) {
			splat = new Splat();
			_splats.push( splat );
			_splatGroup.add( splat );
		} else {
			splat = _splats[_pointer];
		}
		
		arrow.kill();
		
		if ( Std.is( hazard, Spider ) )
		{
			if ( hazard.x == Spider.POSITIONS()[0] )
			{
				positions[0] = false;
			}
			else if ( hazard.x == Spider.POSITIONS()[1] )
			{
				positions[1] = false;
			}
			else
			{
				positions[2] = false;
			}
			
			splat.renew( hazard.x - ( splat.width - hazard.width ) / 2, hazard.y + hazard.height / 2 - 16 );
		}
		else
		{
			splat.renew( hazard.x - ( splat.width - hazard.width ) / 2, hazard.y - ( splat.height - hazard.height ) / 2 );
		}
		
		hazard.kill();
	}
	
	inline static private function sortY(Base1:FlxBasic, Base2:FlxBasic):Int
	{
		return FlxSort.byValues( FlxSort.ASCENDING, cast( Base1, FlxObject).y, cast( Base2, FlxObject).y );
	}
	
	override public function destroy():Void
	{
		positions = null;
		_player.destroy();
		_player = null;
		for ( a in _arrows ) {
			a.destroy();
			a = null; }
		_arrows = null;
		for ( b in _bugs ) {
			b.destroy();
			b = null; }
		_bugs = null;
		_bugGroup.destroy();
		_bugGroup = null;
		for ( s in _spiders ) {
			s.destroy();
			s = null; }
		_spiders = null;
		_spiderGroup.destroy();
		_spiderGroup = null;
		_arrowPos.destroy();
		_arrowPos = null;
		_deadPlayer.destroy();
		_deadPlayer = null;
		_collision.destroy();
		_collision = null;
		for ( s in _splats ) {
			s.destroy();
			s = null; }
		_splats = null;
		_splatGroup.destroy();
		_splatGroup = null;
		super.destroy();
	}
}