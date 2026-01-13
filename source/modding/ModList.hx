package modding;

import flixel.FlxG;

class ModList
{
	public static var enabledMods:Array<String> = [];

	public static function getModEnabled(id:String):Bool
        return enabledMods.contains(id);
    
	public static function toggleMod(id:String)
	{
		if (enabledMods.contains(id))
		{
			trace('Disabled mod: $id');
			enabledMods.remove(id);
		}
		else
		{
			trace('Enabled mod: $id');
			enabledMods.push(id);
		}
	}

	public static function init()
	{
		enabledMods = [];

		if (!FlxG.save.isBound || FlxG.save.isEmpty())
			return;
		if (FlxG.save.data.enabledMods == null)
			return;

		var savedEM:Array<String> = FlxG.save.data.enabledMods;

		for (mod in savedEM)
			toggleMod(mod);
	}
}
