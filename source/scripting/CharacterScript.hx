package scripting;

class CharacterScript extends Script
{
	override public function new(scriptFile:String, ?path:String)
	{
		super('characters/$scriptFile', 'CharacterScript(characters/$scriptFile)');
	}
}
