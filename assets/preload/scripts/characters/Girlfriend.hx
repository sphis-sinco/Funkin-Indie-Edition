using StringTools;

function isChar(character:Character)
{
	return (character.curCharacter == 'gf'
		|| character.curCharacter == 'gf-christmas'
		|| character.curCharacter == 'gf-car'
		|| character.curCharacter == 'gf-pixel');
}

function update(character:Character, elapsed:Float)
{
	if (isChar(character))
	{
		if (character.animation.curAnim.name == 'hairFall' && character.animation.curAnim.finished)
		{
			character.danced = true;
			character.playAnim('danceRight');
		}
	}
}

function dance(character:Character, forced:Bool = false, altAnim:Bool = false):Bool
{
	if (isChar(character))
	{
		if (!character.debugMode)
			if (!character.animation.curAnim.name.startsWith('hair') && !character.animation.curAnim.name.startsWith('sing'))
			{
				character.danced = !character.danced;

				if (character.danced)
					character.playAnim('danceRight');
				else
					character.playAnim('danceLeft');
			}
		return true;
	}

	return false;
}

function dadvar(character:Character)
{
	if (isChar(character))
		character.dadVar = 4.1;
}

function playAnim(character:Character, AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
{
	if (isChar(character))
	{
		if (AnimName == 'singLEFT')
			character.danced = true;
		else if (AnimName == 'singRIGHT')
			character.danced = false;

		if (AnimName == 'singUP' || AnimName == 'singDOWN')
			character.danced = !character.danced;
	}
}
