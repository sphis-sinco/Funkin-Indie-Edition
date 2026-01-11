package art.scripts;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

using StringTools;

// haxe -m art.scripts.ConvertChangelogToDownloadMe --interp
class ConvertChangelogToDownloadMe
{
	public static function main()
	{
		var downloadMe:String = File.getContent('version.downloadMe');
		var version:String = downloadMe.split(';')[0];
		var changelog:Array<String> = File.getContent('docs/changelogs/changelog-${version}.md').split('\n');

		var newDownloadMe:String = version + ';\n';

		for (line in changelog)
			if (line.startsWith('- 💖'))
				newDownloadMe += line.replace('- 💖', '-').replace('`', '"') + '\n';

		Sys.println('Generated version.downloadMe:\n');
		Sys.println(newDownloadMe);

		File.saveContent('version.downloadMe', newDownloadMe);
		Sys.println('Saved new version.downloadMe!');
	}
}
