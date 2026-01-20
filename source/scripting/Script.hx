package scripting;

import scripting.classAlts.ScriptedReflect;
import polymod.fs.ZipFileSystem;
import lime.utils.Assets;

using haxe.io.Path;

#if sys
import sys.FileSystem;
#end
import scripting.classAlts.ScriptedStd;
import haxe.Log;
import crowplexus.iris.Iris;
import modding.ModCore;

using StringTools;

class Script extends Iris
{
	public static var miscScripts:Array<GeneralScript> = [];
	public static var characterScripts:Array<GeneralScript> = [];

	public static var SPECIFIC_SCRIPT_FOLDERS:Array<String> = ['characters'];

	public static function loadScripts()
	{
		callOnMiscScripts('destroy');
		callOnCharacterScripts('destroy');

		for (ms in miscScripts)
		{
			ms.destroy();
			miscScripts.remove(ms);
		}
		for (cs in characterScripts)
		{
			cs.destroy();
			characterScripts.remove(cs);
		}

		miscScripts = [];
		characterScripts = [];

		var readDir:Dynamic;
		readDir = function(dir:String)
		{
			var dirContent:Array<String> = [];
			var dirSplit:Array<String> = [];

			try
			{
				dirContent = Main.filesys.readDirectory(dir);
			}
			catch (e)
			{
				trace(e);
				dirContent = [];
			}

			dirSplit = dir.split('/');
			for (dirPath in Path.directory(Paths.haxe('')).split('/'))
				dirSplit.remove(dirPath);

			for (content in dirContent)
			{
				var scriptFile:String = content.withoutExtension();
				var path:String = dirSplit.join('/').addTrailingSlash();
				path = path.replace('//', '/');

				var readDirDir:String = dir.addTrailingSlash() + content;

				var ret = true;
				for (d in dirSplit)
					for (ssf in SPECIFIC_SCRIPT_FOLDERS)
						if (ssf == d && dirSplit.length == ssf.split('/').length)
							ret = false;

				#if ALL_LOADSCRIPTS_READDIR_TRACES
				trace('readDir($dir)');
				trace(' * content : $content');

				trace('   * content.extension: ' + content.extension());
				trace('   * script  extension: ' + Path.extension(Paths.haxe('')));
				trace('   * isDirectory: ' + Main.filesys.isDirectory(readDirDir));

				trace('   * dirSplit : $dirSplit');
				trace('   * dirSplit == [\'characters\'] : ${dirSplit == ['characters']}');
				trace('   * dirSplit.join(\'/\') : ${dirSplit.join('/')}');
				trace('   * fullpath: ' + Paths.haxe(path + scriptFile));
				trace('   * readDirDir: ' + readDirDir);
				#end

				if (!Main.filesys.isDirectory(readDirDir))
				{
					if (dirSplit.join('/') == 'characters')
					{
						trace('CHARACTER');
						var newCharScript:GeneralScript = new GeneralScript(scriptFile, path.addTrailingSlash());
						characterScripts.push(newCharScript);
					}
					else
					{
						if (ret)
						{
							trace('MISC');
							var newMiscScript:GeneralScript = new GeneralScript(scriptFile, path.addTrailingSlash());
							miscScripts.push(newMiscScript);
						}
					}
				}
				else if (Main.filesys.isDirectory(readDirDir))
					readDir(readDirDir);
			}
		}

		readDir(Path.directory(Paths.haxe('')));

		callOnMiscScripts('scriptsLoaded');
		callOnCharacterScripts('scriptsLoaded');
	}

	public static function callOnMiscScripts(method:String, ?params:Array<Dynamic>):Map<String, Dynamic>
	{
		var returnValues:Map<String, Dynamic> = [];

		for (ms in miscScripts)
			returnValues.set(ms.config.name, ms.call(method, params));

		return returnValues;
	}

	public static function callOnCharacterScripts(method:String, ?params:Array<Dynamic>):Map<String, Dynamic>
	{
		var returnValues:Map<String, Dynamic> = [];

		for (cs in characterScripts)
			returnValues.set(cs.config.name, cs.call(method, params));

		return returnValues;
	}

	public static function setOnMiscScripts(vari:String, value:Dynamic)
		for (ms in miscScripts)
			ms.set(vari, value);

	public static function setOnCharacterScripts(vari:String, value:Dynamic)
		for (cs in characterScripts)
			cs.set(vari, value);

	override public function new(path:String, scriptName:String)
	{
		if (!Paths.doesTextAssetExist(Paths.haxe(path)))
		{
			Debug.logError('Cannot find script: ' + Paths.haxe(path));
			super('function scriptsLoaded() { trace("couldnt find script : ${Paths.haxe(path)}"); }', {
				name: scriptName
			});
		}
		else
		{
			Debug.logInfo('Found script: ' + Paths.haxe(path));
			super(Paths.getText(Paths.haxe(path)), {
				name: scriptName
			});
		}

		initVars();
	}

	public static function getDefaultVariables():Map<String, Dynamic>
	{
		return [
			// Haxe related stuff
			"Std" => ScriptedStd,
			"Math" => Math,
			"Reflect" => ScriptedReflect,
			"StringTools" => StringTools,
			"Json" => haxe.Json,

			// OpenFL & Lime related stuff
			"Assets" => openfl.utils.Assets,
			"Application" => lime.app.Application,
			"Main" => Main,
			"window" => lime.app.Application.current.window,

			#if !hscriptPos
			'trace' => Log.trace,
			#end

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
			"PlayStateChangeables" => PlayStateChangeables,
			"ResultsScreen" => ResultsScreen,
			"PauseSubstate" => PauseSubState,
			"ChartingState" => ChartingState,
			"ChartParser" => ChartParser,
			"AnimationDebug" => AnimationDebug,
			"GameOverState" => GameOverState,
			"GameOverSubstate" => GameOverSubstate,
			"GameplayCustomizeState" => GameplayCustomizeState,
			"GitarooPause" => GitarooPause,

			"BackgroundDancer" => BackgroundDancer,
			"BackgroundGirls" => BackgroundGirls,

			"HealthIcon" => HealthIcon,
			"DialogueBox" => DialogueBox,
			"Note" => Note,
			"NoteskinHelpers" => NoteskinHelpers,
			"Character" => Character,
			"Boyfriend" => Boyfriend,

			"Stage" => Stage,
			"Song" => Song,

			"TitleState" => TitleState,
			"MainMenuState" => MainMenuState,
			"FreeplayState" => FreeplayState,
			"StoryMenuState" => StoryMenuState,

			"OptionsDirect" => OptionsDirect,
			"OptionsMenu" => OptionsMenu,

			#if FEATURE_Main.FILESYSTEM
			"Caching" => Caching,
			#end

			"Alphabet" => Alphabet,

			"Paths" => Paths,
			"Conductor" => Conductor,

			"CoolUtil" => CoolUtil,
			"Debug" => Debug,

			"ModCore" => ModCore,
			"Global" => Global,

			"GeneralScript" => GeneralScript,
			"Script" => Script,

			#if FEATURE_LUAMODCHART
			"LuaClass" => LuaClass,
			#end
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
