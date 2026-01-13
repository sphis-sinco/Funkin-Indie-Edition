package scripting;

class MiscScript extends Script
{
	override public function new(scriptFile:String, ?path:String)
	{
		super('$path$scriptFile', 'MiscScript($path$scriptFile)');
	}
}
