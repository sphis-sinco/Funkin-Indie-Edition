package modding;

import flixel.FlxG;

class ModList
{
	public static var enabledMods:Array<String> = [];

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

		var savedEM:Array<String> = FlxG.save.data.enabledMods;
		for (mod in savedEM)
			toggleMod(mod);
	}
}
