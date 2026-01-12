package art.scripts;

import haxe.io.Input;
import haxe.macro.Compiler;
import sys.io.Process;

using StringTools;

// haxe -m art.scripts.MergeInto --interp -D BRANCH="whatever"
class MergeInto
{
	static function main()
	{
		//  Sys.command('git', ['branch']);
		var gitbranch = new Process('git', ['branch']);
		var branchCmd = gitbranch.stdout.readAll();
		var branches = Std.string(branchCmd).split('\n');

		var curBranch = '';
		for (line in branches)
			if (line.contains('*'))
				curBranch = line.substr(2);

		var targetBranch = Compiler.getDefine('BRANCH');
		trace('current branch: ' + curBranch);
		trace('target branch: ' + targetBranch);

		if (targetBranch == null || targetBranch == "")
		{
			trace('missing targetBranch');
			return;
		}

		var foundTargBrnch = false;
		for (line in branches)
			if (line.substr(2) == targetBranch)
				foundTargBrnch = true;

		if (!foundTargBrnch)
		{
			trace(targetBranch + " doesn't exist");
			return;
		}

		trace('Are you sure?');
		var choice:String = Sys.stdin().readLine();

		switch (choice.toLowerCase())
		{
			case 'y':
				trace('Yes');
				Sys.command('git', ['checkout', targetBranch]);
				Sys.command('git', ['merge', curBranch]);
				Sys.command('git', ['push']);
				Sys.command('git', ['checkout', curBranch]);
			case 'n':
				trace('No, okay.');
			default:
				trace('I\'m going to assume no.');
		}
	}
}
