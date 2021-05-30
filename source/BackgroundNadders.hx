package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundNadders extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = FlxAtlasFrames.fromSparrow(PlayState.stagePath + "nadalyn/nadalyn_dancers.png", PlayState.stagePath + "nadalyn/nadalyn_dancers.xml");
		animation.addByIndices('danceLeftNad', 'nadders dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRightNad', 'nadders dance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.play('danceLeftNad');
		antialiasing = true;
	}

	var danceDirNad:Bool = false;

	public function danceNad():Void
	{
		danceDirNad = !danceDirNad;

		if (danceDirNad)
			animation.play('danceRightNad', true);
		else
			animation.play('danceLeftNad', true);
	}
}
