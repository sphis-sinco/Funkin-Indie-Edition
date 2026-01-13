package modding.scripting;

import modding.events.simple.UpdateEvent;
import modding.events.basic.CreateEvent;
import polymod.hscript.HScriptable;

// @:hscriptClass
class Scriptedscript extends Script implements HScriptable {}

class Script
{
	public var id:String = '';

	public function new(id:String)
	{
		this.id = id;
		trace('Newly init Script: ${toString()}');
	}

	public var excludeFieldsInToString:Array<String> = [];
	public function toString():String
	{
		return CoolUtil.classFieldsToString(this, excludeFieldsInToString);
	}

	// the events

	public function onCreate(event:CreateEvent) {}

	public function onUpdate(event:UpdateEvent) {}

	public function onStateSwitch(event:Any) {}

	public function onFocusGained(event:Any) {}

	public function onFocusLost(event:Any) {}

	public function destroy() {}
}
