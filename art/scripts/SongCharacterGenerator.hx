package art.scripts;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

using StringTools;

// haxe -m art.scripts.SongCharacterGenerator --interp

class Paths
{
	public static function getSparrowAtlas(path:String, ?a:Any, ?b:Any, ?c:Any, ?d:Any, ?e:Any, ?f:Any, ?g:Any, ?h:Any, ?i:Any, ?j:Any, ?k:Any, ?l:Any,
			?m:Any, ?n:Any, ?o:Any, ?p:Any, ?q:Any, ?r:Any, ?s:Any, ?t:Any, ?u:Any, ?v:Any, ?w:Any, ?x:Any, ?y:Any, ?z:Any)
		return path;

	public static function getPackerAtlas(path:String, ?a:Any, ?b:Any, ?c:Any, ?d:Any, ?e:Any, ?f:Any, ?g:Any, ?h:Any, ?i:Any, ?j:Any, ?k:Any, ?l:Any, ?m:Any,
			?n:Any, ?o:Any, ?p:Any, ?q:Any, ?r:Any, ?s:Any, ?t:Any, ?u:Any, ?v:Any, ?w:Any, ?x:Any, ?y:Any, ?z:Any)
		return path;
}

class AnimationClass
{
	public var anims:Array<AnimationData> = [];

	public function new()
	{
	}

	public function getAnim(animName:String):Dynamic
	{
		for (anim in anims)
		{
			if (anim.name == animName)
				return anim;
		}

		return null;
	}

	public function addByPrefix(name:String, prefix:String, frameRate = 24, looped = true, flipX = false, flipY = false)
	{
		anims.push({
			name: name,
			prefix: prefix,
			offsets: [0, 0],

			looped: looped,

			flipX: flipX,
			flipY: flipY,

			frameRate: frameRate,
		});
	}

	public function addByIndices(Name:String, Prefix:String, Indices:Array<Int>, Postfix:String, FrameRate = 24, Looped:Bool = true, FlipX:Bool = false,
			FlipY:Bool = false)
	{
		anims.push({
			name: Name,
			prefix: Prefix,
			offsets: [0, 0],

			looped: Looped,

			flipX: FlipX,
			flipY: FlipY,

			frameRate: FrameRate,
			frameIndices: Indices,
		});
	}

	public function play(urmom:String)
	{
	};
}

typedef AnimationData =
{
	var name:String;
	var prefix:String;
	var ?offsets:Array<Int>;

	/**
	 * Whether this animation is looped.
	 * @default false
	 */
	var ?looped:Bool;

	var ?flipX:Bool;
	var ?flipY:Bool;

	/**
	 * The frame rate of this animation.
	 * @default 24
	 */
	var ?frameRate:Int;

	var ?frameIndices:Array<Int>;
}

class SongCharacterGenerator
{
	static var charsPath = 'assets/preload/data/characters/';

	public static function main()
	{
		for (file in FileSystem.readDirectory('assets/preload/data/characters'))
			if (file.endsWith('.json'))
				checkChar(file.split('.')[0]);
	}

	static function checkChar(char:String)
	{
		var charName = char;
		var barColor = 0xFFFFFFFF;
		var isPlayer = false;

		var animation:AnimationClass = new AnimationClass();
		var startingAnim = 'idle';

		var addOffset = function(anim = '', ?x = 0.0, ?y = 0.0)
		{
			trace(' * addOffset($anim : $x,$y)');
			if (animation.getAnim(anim) != null)
				animation.getAnim(anim).offsets = [x, y];
		};
		var playAnim = function(a)
		{
			startingAnim = a;
		};
		var updateHitbox = function()
		{
		};

		var width = 1.0;
		var widthMultiplier = 1.0;
		var setGraphicSize = function(s = 0.0)
		{
			widthMultiplier = s / width;
		};

		var stdint = function(f)
		{
			return f;
		}
		var loadOffsetFile = function(c)
		{
			var file = [];
			try
			{
				file = File.getContent('art/ogOffsets/${c}Offsets.txt').split('\n');
			}
			catch (e)
			{
				trace(e);
				return;
			};
			trace('loadOffsetFile($c)');

			for (offsets in file)
			{
				var offsetz = offsets.split(' ');
				// trace(' * $offsetz');
				if (offsetz.length > 1)
					addOffset(offsetz[0], Std.parseFloat(offsetz[1] ?? '0.0'), Std.parseFloat(offsetz[2] ?? '0.0'));
			}
		};

		var danceEveryNumBeat = 1.0;

		var flipX = false;
		var flipY = false;
		var singDuration = 4.0;
		var forceDance = false;

		var frames = '';
		var tex = '';

		var antialiasing = true;

		var properties:Dynamic = {};

		switch (char)
		{
			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas', 'shared', true);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(char);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar', 'shared', true);
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);
				animation.addByIndices('idleHair', 'GF Dancing Beat Hair blowing CAR', [10, 11, 12, 25, 26, 27], "", 24, true);

				loadOffsetFile(char);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel', 'shared', true);
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(char);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				animation.addByIndices('idleLoop', "Dad idle dance", [11, 12], "", 12, true);

				loadOffsetFile(char);
				barColor = 0xFFaf66ce;

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets', 'shared', true);
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				loadOffsetFile(char);
				barColor = 0xFFd57e00;

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets', 'shared', true);
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);
				animation.addByIndices('idleLoop', "Mom Idle", [11, 12], "", 12, true);

				loadOffsetFile(char);
				barColor = 0xFFd8558e;

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar', 'shared', true);
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);
				animation.addByIndices('idleHair', 'Mom Idle', [10, 11, 12, 13], "", 24, true);

				loadOffsetFile(char);
				barColor = 0xFFd8558e;

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				loadOffsetFile(char);
				barColor = 0xFFf3ff6e;
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				loadOffsetFile(char);
				barColor = 0xFFf3ff6e;
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				loadOffsetFile(char);
				barColor = 0xFFb7d855;

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared', true);
				frames = tex;

				// trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				loadOffsetFile(char);

				playAnim('idle');

				barColor = 0xFF31b0d1;

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				loadOffsetFile(char);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar', 'shared', true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByIndices('idleHair', 'BF idle dance', [10, 11, 12, 13], "", 24, true);

				loadOffsetFile(char);
				playAnim('idle');

				barColor = 0xFF31b0d1;

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel', 'shared', true);
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				loadOffsetFile(char);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				// width -= 100;
				// height -= 100;

				antialiasing = false;

				barColor = 0xFF31b0d1;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD', 'shared', true);
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, false);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				loadOffsetFile(char);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

				barColor = 0xFF31b0d1;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai', 'shared', true);
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				loadOffsetFile(char);
				barColor = 0xFFffaa6f;

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai', 'shared', true);
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				loadOffsetFile(char);
				barColor = 0xFFffaa6f;
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit', 'shared', true);
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				loadOffsetFile(char);
				barColor = 0xFFff3c6e;

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets', 'shared', true);
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);
				animation.addByIndices('idleLoop', "Parent Christmas Idle", [11, 12], "", 12, true);

				loadOffsetFile(char);
				barColor = 0xFF9a00f8;

				playAnim('idle');
		}

		trace('Saving char : ' + char);

		var notes = [];

		if (char == 'spirit')
			properties.packer = true;

		if (char.contains('bf') || char == 'pico')
			properties.flipX = true;

		if (char.contains('gf'))
			barColor = 0xA5004D;
		if (char.contains('bf'))
			barColor = 0xFF31B0D1;

		if (barColor == 0xFFFFFF)
			notes.push('missing barColor');

		if (notes.length > 0)
			properties.notes = notes;

		if (!antialiasing)
		{
			properties.pixel = true;
			if (widthMultiplier > 1 && widthMultiplier % 6 > 0)
				properties.scale_addition = widthMultiplier % 6;
		}
		else
		{
			if (widthMultiplier > 1)
				properties.scale_addition = widthMultiplier;
		}

		if (animation.anims.length > 0)
		{
			var data:Dynamic = {
				name: charName,
				asset: frames,
				startingAnim: startingAnim,
				barColor: '#${barColor.hex().substr(2)}',
				animations: animation.anims
			}

			if (Reflect.fields(properties).length > 0)
				data.properties = properties;

			File.saveContent(charsPath + char + '.json', Json.stringify(data, '\t').trim());
		}
		else
		{
			trace(char + ' is missin anims');
		}
	}
}

typedef CharacterData =
{
	var name:String;
	var asset:String;
	var startingAnim:String;

	/**
	 * The color of this character's health bar.
	 */
	var barColor:String;

	var animations:Array<AnimationData>;

	var ?properties:Dynamic;
}
