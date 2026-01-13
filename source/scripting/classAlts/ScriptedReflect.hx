package scripting.classAlts;

class ScriptedReflect
{
	public static function hasField(o:Dynamic, field:String):Bool
		return Reflect.hasField(o, field);

	public static function field(o:Dynamic, field:String):Dynamic
		return Reflect.field(o, field);

	public static function setField(o:Dynamic, field:String, value:Dynamic):Void
		return Reflect.setField(o, field, value);

	public static function getProperty(o:Dynamic, field:String):Dynamic
		return Reflect.getProperty(o, field);

	public static function setProperty(o:Dynamic, field:String, value:Dynamic):Void
		return Reflect.setProperty(o, field, value);

	public static function callMethod(o:Dynamic, func:haxe.Constraints.Function, args:Array<Dynamic>):Dynamic
		return Reflect.callMethod(o, func, args);

	public static function fields(o:Dynamic):Array<String>
		return Reflect.fields(o);

	public static function isFunction(f:Dynamic):Bool
		return Reflect.isFunction(f);

	public static function compare<T>(a:T, b:T):Int
		return Reflect.compare(a, b);

	public static function compareMethods(f1:Dynamic, f2:Dynamic):Bool
		return Reflect.compareMethods(f1, f2);

	public static function isObject(v:Dynamic):Bool
		return Reflect.isObject(v);

	public static function isEnumValue(v:Dynamic):Bool
		return Reflect.isEnumValue(v);

	public static function deleteField(o:Dynamic, field:String):Bool
		return Reflect.deleteField(o, field);

	public static function copy<T>(o:Null<T>):Null<T>
		return Reflect.copy(o);

	@:overload(function(f:Array<Dynamic>->Void):Dynamic
	{
	})
	public static function makeVarArgs(f:Array<Dynamic>->Dynamic):Dynamic
	{
		return Reflect.makeVarArgs(f);
	}
}
