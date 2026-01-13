package scripting.classAlts;

class ScriptedStd
{
	public static function int(x:Float):Int
		return Std.int(x);

	public static function isOfType(v:Dynamic, t:Dynamic):Bool
		return Std.isOfType(v, t);

	public static function parseFloat(x:String):Float
		return Std.parseFloat(x);

	public static function parseInt(x:String):Null<Int>
		return Std.parseInt(x);

	public static function random(x:Int):Int
		return Std.random(x);

	public static function string(x:Dynamic):String
		return Std.string(x);
}
