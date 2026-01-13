package modding.events;

class StateEvent
{
	public var state:String;


	public function new(state:String)
	{
		this.state = state;
	}

	public var excludeFieldsInToString:Array<String> = [];
	public function toString():String
	{
		return CoolUtil.classFieldsToString(this, excludeFieldsInToString);
	}
}
