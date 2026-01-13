package scripting;

import lime.utils.Assets;

using haxe.io.Path;

#if sys
import sys.FileSystem;
#end
import scripting.classAlts.ScriptedStd;
import haxe.Log;
import crowplexus.iris.Iris;

using StringTools;

class Script extends Iris
{
	public static var miscScripts:Array<MiscScript> = [];

	public static var SPECIFIC_SCRIPT_FOLDERS:Array<String> = [];

	public static function loadMiscScripts()
	{
		callOnMiscScripts('destroy');

		for (ms in miscScripts)
		{
			ms.destroy();
			miscScripts.remove(ms);
		}

		var readDir:Dynamic;
		readDir = function(dir:String)
		{
			var dirContent:Array<String> = [];
			var dirSplit:Array<String> = [];

			#if sys
			try
			{
				dirContent = FileSystem.readDirectory(dir);
			}
			catch (e)
			{
				trace(e);
				dirContent = [];
			}
			#end

			dirSplit = dir.split('/');
			for (dirPath in Path.directory(Paths.haxe('')).split('/'))
				dirSplit.remove(dirPath);

			for (content in dirContent)
			{
				if (content.extension() == Path.extension(Paths.haxe('')) #if sys
					&& !FileSystem.isDirectory(dir.addTrailingSlash() + content) #end)
				{
					var newMiscScript:MiscScript = new MiscScript(content.withoutExtension(), dirSplit.join('/').addTrailingSlash());
					miscScripts.push(newMiscScript);
				}
				else
				{
					#if sys
					if (FileSystem.isDirectory(dir.addTrailingSlash() + content)
						&& (!SPECIFIC_SCRIPT_FOLDERS.contains(content) && dir == Path.directory(Paths.haxe(''))))
						readDir(dir.addTrailingSlash() + content);
					#end
				}
			}
		}

		readDir(Path.directory(Paths.haxe('')));

		callOnMiscScripts('miscScriptsLoaded');
	}

	public static function callOnMiscScripts(method:String, ?params:Array<Dynamic>):Map<String, Dynamic>
	{
		var returnValues:Map<String, Dynamic> = [];

		for (ms in miscScripts)
			returnValues.set(ms.config.name, ms.call(method, params));

		return returnValues;
	}

	public static function setOnMiscScripts(vari:String, value:Dynamic)
	{
		for (ms in miscScripts)
			ms.set(vari, value);
	}

	override public function new(path:String, scriptName:String)
	{
		if (!Paths.doesTextAssetExist(Paths.haxe(path)))
			Debug.logError('Cannot find script: ' + Paths.haxe(path));
		else
			Debug.logInfo('Found script: ' + Paths.haxe(path));

		super((Paths.doesTextAssetExist(Paths.haxe(path)) ? Assets.getText(Paths.haxe(path)) : 'function create() { trace("couldnt find script : ${Paths.haxe(path)}"); }'),
			{
				name: scriptName
			});

		initVars();
	}

	public static function getDefaultVariables():Map<String, Dynamic>
	{
		return [
			// Haxe related stuff
			"Std" => ScriptedStd,
			"Math" => Math,
			"Reflect" => Reflect,
			"StringTools" => StringTools,
			"Json" => haxe.Json,

			// OpenFL & Lime related stuff
			"Assets" => openfl.utils.Assets,
			"Application" => lime.app.Application,
			"Main" => Main,
			"window" => lime.app.Application.current.window,

			'trace' => Log.trace,

			// Flixel related stuff
			"FlxG" => flixel.FlxG,
			"FlxSprite" => flixel.FlxSprite,
			"FlxBasic" => flixel.FlxBasic,
			"FlxCamera" => flixel.FlxCamera,
			"FlxEase" => flixel.tweens.FlxEase,
			"FlxTween" => flixel.tweens.FlxTween,
			"FlxSound" => flixel.sound.FlxSound,
			"FlxAssets" => flixel.system.FlxAssets,
			"FlxMath" => flixel.math.FlxMath,
			"FlxGroup" => flixel.group.FlxGroup,
			"FlxTypedGroup" => flixel.group.FlxGroup.FlxTypedGroup,
			"FlxSpriteGroup" => flixel.group.FlxSpriteGroup,
			"FlxTypeText" => flixel.addons.text.FlxTypeText,
			"FlxText" => flixel.text.FlxText,
			"FlxTimer" => flixel.util.FlxTimer,
			"FlxPoint" => CoolUtil.getMacroAbstractClass("flixel.math.FlxPoint"),
			"FlxAxes" => CoolUtil.getMacroAbstractClass("flixel.util.FlxAxes"),
			"FlxColor" => CoolUtil.getMacroAbstractClass("flixel.util.FlxColor"),

			// Engine related stuff

			"PlayState" => PlayState,
			"HealthIcon" => HealthIcon,

			"Note" => Note,

			"Character" => Character,
			"Boyfriend" => Boyfriend,

			"PauseSubstate" => PauseSubState,
			"FreeplayState" => FreeplayState,
			"MainMenuState" => MainMenuState,
			"PauseSubState" => PauseSubState,
			"StoryMenuState" => StoryMenuState,
			"TitleState" => TitleState,
			"Paths" => Paths,
			"Conductor" => Conductor,

			"CoolUtil" => CoolUtil,
			"Debug" => Debug,

			"ModCore" => ModCore,

			"Discord" => Discord,

			"MiscScript" => MiscScript,
			"Script" => Script,
		];
	}

	public function initVars()
	{
		for (key => value in getDefaultVariables())
			set(key, value);
	}

	override function call(fun:String, ?args:Array<Dynamic>):IrisCall
	{
		if (interp != null)
		{
			var method:Dynamic = interp.variables.get(fun); // function signature

			if (!Reflect.isFunction(method) || method == null)
				return null;
		}

		return super.call(fun, args);
	}
}
