package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite
{
	private var idleAnim:String;
	public function new(x:Float = 0, y:Float = 0, ?note:Float = 0) 
	{
		super(x, y);

		var stageSuffix:String = '';

		frames = FlxAtlasFrames.fromSparrow('assets/images/UI/noteSplashes$stageSuffix.png', 'assets/images/UI/noteSplashes.xml');
		animation.addByPrefix("note1-0", "note impact 1  blue", 24, false);
		animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
		animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
		animation.addByPrefix("note3-0", "note impact 1 red", 24, false);
		animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
		animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
		animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
		animation.addByPrefix("note3-1", "note impact 2 red", 24, false);
		setupNoteSplash(x, y, note);
		antialiasing = true;
	}

	public function setupNoteSplash(x:Float, y:Float, ?note:Float = 0) 
	{
		setPosition(x, y);
		alpha = 0.6;
		animation.play('note' + note + '-' + FlxG.random.int(0, 1), true);
		animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
		updateHitbox();
		offset.set(Std.int(0.3 * width), Std.int(0.3 * height));
	}

	override function update(elapsed:Float) 
	{
		if (animation.curAnim.finished) 
			kill();

		super.update(elapsed);
	}
}