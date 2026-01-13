package;

import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class CoolUtil
{
	public static function getCurrentState():String
	{
		if (FlxG.state == null)
			return 'Unknown';
		var cls = Type.getClass(FlxG.state);
		if (cls == null)
			return 'Unknown';
		var name = Type.getClassName(cls);
		return name != null ? name.split('.').pop() : 'Unknown';
	}

	public static function classFieldsToString(theclass:Any, excludeFieldsInToString:Array<String> = []):String
	{
		var eventName:String = Type.getClassName(this);
		var fieldsList:String = '';

		var fi = 0;
		for (field in Reflect.fields(this))
		{
			if (!excludeFieldsInToString.contains(field))
				fieldsList += '${fi > 0?', '} $field: ${Reflect.field(this, field)}';
			fi++;
		}

		return '$eventName($fieldsList)';
	}

	public static inline function getMacroAbstractClass(className:String)
	{
		return Type.resolveClass('${className}_HSC');
	}

	public static var difficultyArray:Array<String> = ['Easy', "Normal", "Hard"];

	public static var daPixelZoom:Float = 6;

	public static function difficultyFromInt(difficulty:Int):String
	{
		return difficultyArray[difficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = OpenFlAssets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function coolStringFile(path:String):Array<String>
	{
		var daList:Array<String> = path.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
