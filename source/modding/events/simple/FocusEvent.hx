package modding.events.simple;

import modding.scripting.Script;

enum abstract FocusType(String) from String to String
{
	var GAINED = 'GAINED';
	var LOST = 'LOST';
}

class FocusEvent extends ScriptEvent
{
	public var focusType:FocusType;

	public function new(focusType:Float, script:Script, state:String)
	{
		super(script, state);
		this.focusType = focusType;
	}
}
