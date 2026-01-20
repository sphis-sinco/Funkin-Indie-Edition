using StringTools;

function isChar(character:Character)
{
	return (character.curCharacter == 'spooky');
}

function dadvar(character:Character)
{
	if (isChar(character))
		character.dadVar = 4.1;
}

function dance(character:Character, forced:Bool = false, altAnim:Bool = false):Bool
{
	if (isChar(character))
	{
		if (!character.debugMode)
			if (!character.animation.curAnim.name.startsWith('sing'))
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
