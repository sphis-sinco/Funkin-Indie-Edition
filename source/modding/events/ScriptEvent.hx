package modding.events;

import modding.scripting.Script;

class ScriptEvent extends StateEvent
{
	public var script:Script;

	public function new(script:Script, state:String)
	{
		super(state);

		this.script = script;
	}
}
