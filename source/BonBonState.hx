package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.filters.ShaderFilter;
/*import openfl.display.SimpleButton;
import openfl.events.MouseEvent;*/

using StringTools;

class BonBonState extends MusicBeatState
{
	private var camFollow:FlxObject;
	private var camZooming:Bool = false;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

    var blueButton:FlxSprite;

	var defaultCamZoom:Float = 1.05;
	
	override public function create()
	{
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;
		
        FlxG.mouse.visible = true;

        blueButton = new FlxSprite(263, 179);
		blueButton.frames = FlxAtlasFrames.fromSparrow('assets/images/color_my_bonbon/blueButton.png', 'assets/images/color_my_bonbon/blueButton.xml');
		blueButton.animation.addByPrefix('button', "Button", 24, false);
		blueButton.animation.play('button');
		blueButton.animation.addByPrefix('bon', "BlueBon", 24, false);
		blueButton.scrollFactor.set(0.4, 0.4);
		add(blueButton);
		//blueButton.addEventListener(MouseEvent.CLICK, onButtonClick);


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
    }
}
