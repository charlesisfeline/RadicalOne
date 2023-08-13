package;

import flixel.FlxSprite;
import sys.FileSystem;
import flixel.ui.FlxBar;
import flixel.FlxG;
import lime.utils.Assets;
import flixel.util.FlxTimer;

using StringTools;

class Preload extends MusicBeatState
{
	public function new()
	{
		super();
	}

	var loadingBar:FlxBar;
	var preloadSongs:Array<String> = [];
	var _percent:Float = 0;
	var transitioning:Bool = false;

	override function create()
	{
		var everySong:Array<String> = FileSystem.readDirectory('assets/music');

		for (song in everySong)
		{
			// dont cache the voices
			if (song.endsWith('_Inst.ogg') && Assets.exists('assets/music/$song'))
				preloadSongs.push('assets/music/$song');
		}

		loadingBar = new FlxBar(0, 0, LEFT_TO_RIGHT, FlxG.width - 150, 20, this);
		loadingBar.screenCenter();
		loadingBar.y += 250;
		add(loadingBar);
		super.create();

		preload();
	}

	override function update(time:Float)
	{
		loadingBar.value = _percent;

		if (_percent >= 99.99 && !transitioning)
		{
			transitioning = true;
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MyJunkState());
			});
		}

		super.update(time);
	}

	function preload():Void
	{
		for (song in preloadSongs)
		{
			FlxG.sound.cache(song);
			_percent += 100 / preloadSongs.length;
		}
	}
}
