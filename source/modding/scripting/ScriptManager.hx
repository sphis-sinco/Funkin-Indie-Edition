package modding.scripting;

import modding.scripting.Script.Scriptedscript;

class ScriptManager
{
	static var scripts:Array<Script> = [];

	public static function destroyScripts()
	{
		if (scripts.length > 0)
			for (script in scripts)
			{
				script.destroy();
				scripts.remove(script);
			}
	}

	public static function loadScripts()
	{
		destroyScripts();

		var newscripts = ScriptedScript.listScriptClasses();
		trace('Found ${newscripts.length} scripts to load');
		for (script in newscripts)
		{
			var theActualScriptLol = ScriptedScript.init(script, script);
			if (getScript(script) != null)
			{
				trace('* $script (cant add, ID exists)');
			}
			else
			{
				trace('* $script');
				scripts.push(theActualScriptLol);
			}
		}
	}

	public static function getScript(id:String):Script
	{
		for (script in scripts)
			if (script.id == id)
				return script;

		return null;
	}

	public static function callEvent(callback:Script->Void)
	{
		if (callback == null)
			return;

		for (script in scripts)
			callback(script);
	}
}
