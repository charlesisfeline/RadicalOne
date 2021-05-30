package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class GuardDogs extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = FlxAtlasFrames.fromSparrow(PlayState.stagePath + 'babbys/non_babby_junk/flynets_dog.png', PlayState.stagePath + 'babbys/non_babby_junk/flynets_dog.xml');

		animation.addByPrefix('dance', 'dog bop', 24, false);

		animation.play('dance');
	}

	public function dance(danceType:String):Void
	{
		switch (danceType)
		{
			case 'funny':
				animation.play('dance', true);
		}
	}
}
