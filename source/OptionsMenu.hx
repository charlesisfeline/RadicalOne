package;

import Controls.Control;
import Controls.KeyboardScheme;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var coolInputs:Bool = false;
	var controlsStrings:Array<String>;

	var inputSysTxt:FlxText;
	var pressThis:FlxText;

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		controlsStrings = ['Input System', 
		'BIND KEYS', 
		'${FlxG.save.data.downscroll ? 'DOWN' : 'UP'}SCROLL', 
		'MISS NOISE ${FlxG.save.data.missNoise ? 'ON' : 'OFF'}', 
		FlxG.save.data.ludumRating ? 'LUDUM DARE RATING SYSTEM' : 'NORMAL RATING SYSTEM'];

		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/UI/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		inputSysTxt = new FlxText(FlxG.width - 200, 0, 0, FlxG.save.data.inputSystem, 85);
		inputSysTxt.setFormat("assets/fonts/vcr.ttf", 85, FlxColor.BLACK, RIGHT);
		inputSysTxt.screenCenter();
		inputSysTxt.x += 300;
		add(inputSysTxt);

		pressThis = new FlxText(FlxG.width - 200, 0, 0, 'Press "G" to set offest.', 85);
		pressThis.setFormat("assets/fonts/vcr.ttf", 45, FlxColor.BLACK, RIGHT);
		pressThis.screenCenter();
		pressThis.x += 300;
		pressThis.y += 70;
		pressThis.visible = false;
		add(pressThis);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && !paused)
		{
			switch(curSelected) {
				case 0:
					switch (FlxG.save.data.inputSystem)
					{
						case 'RadicalOne':
							FlxG.save.data.inputSystem = 'Kade Engine';
						case 'Kade Engine':
							FlxG.save.data.inputSystem = 'FNF Pre Week 5';
						case 'FNF Pre Week 5':
							FlxG.save.data.inputSystem = 'FPS Plus';
						case 'FPS Plus':
							FlxG.save.data.inputSystem = 'RadicalOne';
					}
					trace(FlxG.save.data.inputSystem);
					inputSysTxt.text = FlxG.save.data.inputSystem;
					inputSysTxt.screenCenter();
					inputSysTxt.x += 300;
					FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);
				case 1:
					FlxG.switchState(new KeyBindState());
				case 2:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					grpControls.remove(grpControls.members[curSelected]);
					var stupid:Alphabet = new Alphabet(0, (70 * curSelected) + 30, '${FlxG.save.data.downscroll ? 'DOWN' : 'UP'}SCROLL', true, false);
					stupid.isMenuItem = true;
					stupid.targetY = 0;
					grpControls.add(stupid);
				case 3:
					FlxG.save.data.missNoise = !FlxG.save.data.missNoise;
					grpControls.remove(grpControls.members[curSelected]);
					var stupid:Alphabet = new Alphabet(0, (70 * curSelected) + 30, 'MISS NOISE ${FlxG.save.data.missNoise ? 'ON' : 'OFF'}', true, false);
					stupid.isMenuItem = true;
					stupid.targetY = 0;
					grpControls.add(stupid);
				case 4:
					FlxG.save.data.ludumRating = !FlxG.save.data.ludumRating;
					grpControls.remove(grpControls.members[curSelected]);
					var stupid:Alphabet = new Alphabet(0, (70 * curSelected) + 30, FlxG.save.data.ludumRating ? 'LUDUM DARE RATING SYSTEM' : 'NORMAL RATING SYSTEM', true, false);
					stupid.isMenuItem = true;
					stupid.targetY = 0;
					grpControls.add(stupid);
			}
		} // FlxG.save.data.missNoise

		pressThis.visible = (FlxG.save.data.inputSystem == 'Kade Engine' && curSelected == 0);

		if (FlxG.keys.justPressed.G && pressThis.visible)
		{
			openSubState(new OffsetThing());
		}

		if (isSettingControl)
			waitingInput();
		else
		{
			if (controls.BACK && !paused)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P && !paused)
				changeSelection(-1);
			if (controls.DOWN_P && !paused)
				changeSelection(1);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
        if (!paused)
        {
            paused = true;
        }

		super.openSubState(SubState);
	}

    private var paused:Bool = false;

	override function closeSubState()
    {
        if (paused)
        { 
            paused = false;
        }
		super.closeSubState();
	}

	function waitingInput():Void
	{
		if (FlxG.keys.getIsDown().length > 0)
		{
			PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	var isSettingControl:Bool = false;

	function changeBinding():Void
	{
		if (!isSettingControl)
		{
			isSettingControl = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
/*		#if !switch
		NGio.logEvent('Fresh');
		#end*/

		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (curSelected == 0)
			inputSysTxt.visible = true;
		else
			inputSysTxt.visible = false;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
