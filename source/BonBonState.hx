package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class BonBonState extends MusicBeatState
{
    var blueButton:FlxSprite;
	
	override function create()
	{

        FlxG.mouse.visible = true;

        blueButton = new FlxSprite(263, 179);
		blueButton.frames = FlxAtlasFrames.fromSparrow('assets/images/color_my_bonbon/blueButton.png', 'assets/images/color_my_bonbon/blueButton.xml');
		blueButton.animation.addByPrefix('button', "Button", 24, false);
		blueButton.animation.play('button');
		blueButton.animation.addByPrefix('bon', "BlueBon", 24, false);
		blueButton.scrollFactor.set(0.4, 0.4);
		add(blueButton);
		//blueButton.addEventListener(MouseEvent.CLICK, onButtonClick);

		super.create();
    }
/*  function onButtonClick(e:MouseEvent)
    {
        trace('click');
    }  */
	override function update(elapsed:Float)
	{
		if (FlxG.mouse.overlaps(blueButton))
		{
			if (FlxG.mouse.pressed)
			{
				if (blueButton.animation.curAnim.name == 'button')
				{
					blueButton.animation.play('bon');
					blueButton.setGraphicSize(Std.int(blueButton.width * 1.7));
					trace('wow');
				}
				else
				{
					blueButton.animation.play('button');
					blueButton.setGraphicSize(Std.int(112));
					trace('not wow');
				}
			}
		}

		super.update(elapsed);
    }
}
