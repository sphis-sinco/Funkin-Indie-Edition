package modding.events.simple;

import modding.events.bases.PrePostEvent;
import modding.scripting.Script;

class UpdateEvent extends PrePostEvent
{
	public var elapsed:Float;

	public function new(elapsed:Float, prepoststate:PrePostState, script:Script, state:String)
	{
		super(prepoststate, script, state);
		this.elapsed = elapsed;
	}
}
