package;

import scripting.Script;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var barColor:FlxColor;

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		barColor = isPlayer ? 0xFF66FF33 : 0xFFFF0000;
		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = FlxG.save.data.antialiasing;

		var ret = false;
		for (key => value in Script.callOnCharacterScripts('makeCharacter', [this]))
		{
			if (value == ret)
				ret = true;
		}

		if (!ret)
			switch (curCharacter)
			{
				default:
					parseDataFile();
			}

		Script.callOnCharacterScripts('postMakeCharacter', [this]);
	}

	function parseDataFile()
	{
		Debug.logInfo('Generating character (${curCharacter}) from JSON data...');

		// Load the data from JSON and cast it to a struct we can easily read.
		var jsonData = Paths.loadJSON('characters/${curCharacter}');
		if (jsonData == null)
		{
			Debug.logError('Failed to parse JSON data for character ${curCharacter}');
			return;
		}

		var data:CharacterData = cast jsonData;

		var tex:FlxAtlasFrames;
		if (data.properties?.packer)
			tex = Paths.getPackerAtlas(data.asset, 'shared');
		else
			tex = Paths.getSparrowAtlas(data.asset, 'shared');

		frames = tex;
		if (frames != null)
			for (anim in data.animations)
			{
				var frameRate = anim.frameRate == null ? 24 : anim.frameRate;
				var looped = anim.looped == null ? false : anim.looped;
				var flipX = anim.flipX == null ? false : anim.flipX;
				var flipY = anim.flipY == null ? false : anim.flipY;

				if (anim.frameIndices != null)
				{
					animation.addByIndices(anim.name, anim.prefix, anim.frameIndices, "", frameRate, looped, flipX, flipY);
				}
				else
				{
					animation.addByPrefix(anim.name, anim.prefix, frameRate, looped, flipX, flipY);
				}

				animOffsets[anim.name] = anim.offsets == null ? [0, 0] : anim.offsets;
			}

		barColor = FlxColor.fromString(data.barColor);
		trace(data.barColor);

		playAnim(data.startingAnim);

		if (data.properties?.pixel)
		{
			antialiasing = false;
			setGraphicSize(Std.int(width * (CoolUtil.daPixelZoom + (data.properties?.scale_addition ?? 0))));
		}
		else
		{
			antialiasing = true;
			if (data.properties?.scale_addition != null)
				setGraphicSize(Std.int(width * (1 + (data.properties?.scale_addition ?? 0))));
		}

		flipX = data.properties?.flipX ?? false;
		updateHitbox();

		loadOffsetFile(curCharacter);

		Script.callOnCharacterScripts('parsedDataFile', [this]);

		if ((data.properties?.danceOnCreation ?? false))
			dance();

		if (isPlayer && frames != null)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if ((data.properties?.flipHorizontalSingingAsPlayer ?? false))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffsetFile(character:String, library:String = 'shared')
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/characters/' + character + "Offsets", library));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}

		Script.callOnCharacterScripts('loadedOffsetFile', [this]);
	}

	public var dadVar:Float = 4;

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			if (curCharacter.endsWith('-car')
				&& !animation.curAnim.name.startsWith('sing')
				&& animation.curAnim.finished
				&& animation.getByName('idleHair') != null)
				playAnim('idleHair');

			if (animation.getByName('idleLoop') != null)
			{
				if (!animation.curAnim.name.startsWith('sing') && animation.curAnim.finished)
					playAnim('idleLoop');
			}

			dadVar = 4.0;

			Script.callOnCharacterScripts('dadvar', [this]);

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		Script.callOnCharacterScripts('update', [this, elapsed]);

		super.update(elapsed);
	}

	public var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false, altAnim:Bool = false)
	{
		var ret = false;
		for (key => value in Script.callOnCharacterScripts('dance', [this, forced, altAnim]))
		{
			if (value == ret)
				ret = true;
		}

		if (!ret)
			if (!debugMode)
			{
				switch (curCharacter)
				{
					default:
						if (altAnim && animation.getByName('idle-alt') != null)
							playAnim('idle-alt', forced);
						else
							playAnim('idle', forced);
				}
			}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (AnimName.endsWith('alt') && animation.getByName(AnimName) == null)
		{
			#if debug
			FlxG.log.warn(['Such alt animation doesnt exist: ' + AnimName]);
			#end
			AnimName = AnimName.split('-')[0];
		}

		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		Script.callOnCharacterScripts('playAnim', [this, AnimName, Force, Reversed, Frame]);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
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
	var ?properties:CharacterProperties;
}

typedef CharacterProperties =
{
	var ?packer:Bool;
	var ?pixel:Bool;

	var ?scale_addition:Null<Float>;

	var ?flipX:Bool;

	var ?danceOnCreation:Bool;
	var ?flipHorizontalSingingAsPlayer:Bool;
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
