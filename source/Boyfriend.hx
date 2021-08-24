package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

using StringTools;

class Boyfriend extends Character
{
	public var stunned:Bool = false;
	public var invuln:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'radical')
	{
		super(x, y, char, true);
	}

	override function update(elapsed:Float)
	{
		if (!debugMode)
		{
			animation.curAnim.name.startsWith('sing') ?
			holdTimer += elapsed:
			holdTimer = 0;

			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
				idleEnd();

			if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
				playAnim('deathLoop');
		}

		super.update(elapsed);
	}

	public function idleEnd(?ignoreDebug:Bool = false)
	{
		if (!debugMode || ignoreDebug)
		{
			isSpooky ? {
			playAnim(danced ? 'danceRight' : 'danceLeft', true, false, animation.getByName(danced ? 'danceRight' : 'danceLeft').numFrames - 1);
			} :
			playAnim('idle', true, false, animation.getByName('idle').numFrames - 1);
		}
	}
}
