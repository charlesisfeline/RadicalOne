package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import openfl.Lib;

class MenuItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;

	public function new(x:Float, y:Float, weekNum:Int = 0)
	{
		super(x, y);

		var tex = FlxAtlasFrames.fromSparrow('assets/images/UI/campaign_menu_UI_assets.png', 'assets/images/UI/campaign_menu_UI_assets.xml');

		week = new FlxSprite();
		week.frames = tex;
		// TUTORIAL IS WEEK 0
		week.animation.addByPrefix('week0', 'tutorial selected', 24);
		week.animation.addByPrefix('week1', "WEEK1 select", 24);
		week.animation.addByPrefix('week2', "week2 select", 24);
		week.animation.addByPrefix('week3', "Week 3 press", 24);
		week.animation.addByPrefix('week4', "Week 4 press", 24);
		week.animation.addByPrefix('week5', "week 5", 24);
		week.animation.addByPrefix('week6', "Week 6", 24);
		add(week);

		week.animation.play('week' + weekNum);
		week.animation.pause();
		week.updateHitbox();
	}

	var lerpFrame:Bool = true;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (lerpFrame)
			y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17);
		lerpFrame = !lerpFrame;
	}
}
