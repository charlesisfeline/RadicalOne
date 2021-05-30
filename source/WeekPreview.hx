package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;

class WeekPreview extends FlxSprite
{
	public var preview:String;

	public function new(x:Float, preview:String = 'pic1', isShadow:Bool = false)
	{
		super(x);

		this.preview = preview;

		var tex = FlxAtlasFrames.fromSparrow('assets/images/UI/weekPreviews.png', 'assets/images/UI/weekPreviews.xml');
		frames = tex;

		if (isShadow)
			color = FlxColor.BLACK;

		animation.addByPrefix('pic1', "pic1", 24);
		animation.addByPrefix('pic2', 'pic2', 24);
		animation.addByPrefix('pic3', 'pic3', 24);
		animation.addByPrefix('pic4', "pic4", 24);
		animation.addByPrefix('pic5', 'pic1', 24);
		animation.addByPrefix('pic6', 'pic6', 24);

		animation.play(preview);
	}
}