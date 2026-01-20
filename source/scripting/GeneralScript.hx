package scripting;

class GeneralScript extends Script
{
	override public function new(scriptFile:String, ?path:String)
	{
		super('$path$scriptFile', '$path$scriptFile');
	}
}
