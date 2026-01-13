package modding.events.bases;

enum abstract PrePostState(String) from String to String
{
	var PRE:String = 'PRE';
	var POST:String = 'POST';
	var DURING:String = 'DURING';
}

class PrePostEvent extends ScriptEvent
{
	public var prepoststate:PrePostState;

	override public function new(prepoststate:PrePostState, script:Script, state:String)
	{
		super(script, state);

		this.prepoststate = prepoststate;
	}
}
