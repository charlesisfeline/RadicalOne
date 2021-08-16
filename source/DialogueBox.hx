package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import Dialogue.TextManager;
import flash.display.BitmapData;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Dialogue;
	var dialogueList:Array<String> = [];

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitLeftPixel:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var images:Bool = false;
	var image:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic('assets/music/HelloGood' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'north':
				FlxG.sound.playMusic('assets/music/Lunchbox' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'namebe':
				FlxG.sound.playMusic('assets/music/Lunchbox' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic('assets/music/LunchboxScary' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'monster':
				FlxG.sound.playMusic('assets/music/MonkeySprite' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'the-backyardagains':
				FlxG.sound.playMusic('assets/music/HelloGood' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'funny':
				FlxG.sound.playMusic('assets/music/intensity' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.visible = false;
		add(black);

		image = new FlxSprite();
		add(image);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		portraitLeft = new FlxSprite(232, 229);
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite((532 + 285), 229);
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitLeftPixel = new FlxSprite(-20, 40);
		portraitLeftPixel.frames = FlxAtlasFrames.fromSparrow('assets/images/dialogueJunk/chars/senpaiPortrait.png', 'assets/images/dialogueJunk/chars/senpaiPortrait.xml');
		portraitLeftPixel.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeftPixel.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeftPixel.updateHitbox();
		portraitLeftPixel.scrollFactor.set();
		add(portraitLeftPixel);
		portraitLeftPixel.visible = false;

		box = new FlxSprite(-20, 45);

		switch (PlayState.sheShed)
		{
			case 'senpai' | 'roses' | 'thorns':
				box.loadGraphic('assets/images/dialogueJunk/wow.png');
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				babbyBox = true;
				images = true;
			case 'monkey-sprite':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/dialogueJunk/scary.png', 'assets/images/dialogueJunk/dialogueBox-evil.xml');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));

				box.animation.play('normalOpen');
            case 'radical-vs-masked-babbys' | 'north':
				box.loadGraphic('assets/images/dialogueJunk/babbyBox.png');
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				babbyBox = true;
			case 'bonnie-song' | 'without-you' | 'bonbon-loool':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/dialogueJunk/dialogueBox-bawn.png',
					'assets/images/dialogueJunk/dialogueBox-bawn.xml');
				box.animation.addByPrefix('normalOpen', 'NAMEBE', 24, false);
				box.animation.addByPrefix('normal', 'NAMEBE', 24, false);
				box.setGraphicSize(Std.int(box.width * 0.9));
				box.y += 358;

				box.animation.play('normalOpen');
            default:
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/dialogueJunk/dialogueBox-namebe.png',
					'assets/images/dialogueJunk/dialogueBox-namebe.xml');
				box.animation.addByPrefix('normalOpen', 'NAMEBE', 24, false);
				box.animation.addByPrefix('normal', 'NAMEBE', 24, false);
				box.setGraphicSize(Std.int(box.width * 0.9));
				box.y += 358;
				
				box.animation.play('normalOpen');
		}

		box.updateHitbox();
		add(box);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic('assets/images/UI/pixelUI/hand_textbox.png');
		handSelect.scale.set(6, 6);
		add(handSelect);

		if (images)
		{
			black.visible = true;
			coolTextBox = new FlxSprite(-500).makeGraphic(200, 60);
			add(coolTextBox);
			swagText = new FlxText(-500, 0, Std.int(FlxG.width * 0.6), "", 24);
			swagText.color = FlxColor.BLACK;
			swagText.font = 'Pixel Arial 11 Bold';
			add(swagText);
			coolTextBox.screenCenter(Y);
			swagText.y = coolTextBox.y + 10;
		}

		box.screenCenter(X);
	/*	portraitZBab.screenCenter(X);
		portraitCBab.screenCenter(X); */

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		switch (PlayState.sheShed)
		{
			case 'north' | 'radical-vs-masked-babbys' | 'monkey-sprite' | 'senpai' | 'roses' | 'thorns':
				dialogue = new Dialogue(Pixel);
			default:
				dialogue = new Dialogue(Regular);
		}

		// dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		add(dialogue);

		this.dialogueList = dialogueList;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var babbyBox:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
		}

		if (babbyBox)
			dialogueOpened = true;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

       /*       if (PlayState.SONG.song.toLowerCase() != 'namebe' || PlayState.SONG.song.toLowerCase() != 'fnaf-at-phillys' || PlayState.SONG.song.toLowerCase() != 'destructed')
				        box.animation.play('normal');
				                                        */

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);

			if (dialogueList[1] == null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'north')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitLeftPixel.visible = false;
						portraitRight.visible = false;
						dialogue.alpha -= 1 / 5;
						TextManager.coolWidth = 0;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	var coolTextBox:FlxSprite;
	var swagText:FlxText;

	function startDialogue():Void
	{
		cleanDialog();

		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		dialogue.start(0.04, dialogueList[0]);

		if (curCharacter == 'dad')
		{
			trace('dad');
			portraitRight.visible = false;
			portraitLeft.visible = false;
			if (!portraitLeft.visible)
			{
				portraitLeftPixel.visible = true;
				portraitLeftPixel.animation.play('enter');
			}
		}
		else
		{
			var loser:Array<String> = curCharacter.split('>');

			if (images)
			{
				image.loadGraphic(BitmapData.fromFile('assets/images/dialogueJunk/images/${loser[1]}.png'));
				image.setGraphicSize(0, 440);
				image.updateHitbox();
				image.screenCenter(X);
				coolTextBox.screenCenter(X);
				var daChar:Array<String> = loser[0].split('-');
				switch (daChar[0].toLowerCase())
				{
					case 'radical': coolTextBox.x += 450;
					default: coolTextBox.x -= 450;
				}
				coolTextBox.color = FlxColor.fromString(daChar[1]);
				swagText.x = coolTextBox.x + 10;
				swagText.text = daChar[0];
				return;
			}

			if (loser.length == 1)
				loser.push('left');

			switch (loser[0])
			{
				case 'radical':
					trace('bf');
					loser[0] = 'Racial';
				case 'racial-portrait-silly':
					loser[0] = 'Racial_Portrait_Silly';
				case 'radical-point':
					loser[0] = 'Racial_Kinda_Pointing_WTF';
				case 'radical-pissed':
					loser[0] = 'Racial_Pissey_Mood';
				case 'radical-sweat':
					loser[0] = 'Racial_Why_So_Serious';
				case 'radical-ugh':
					loser[0] = 'Racial_Is_Over_It';
				case 'radical-what':
					loser[0] = 'failing_idiot';
				case 'gaming':
					trace('bf');
					loser[0] = 'Gaming';
				case 'gaming-poop':
					loser[0] = 'Gaming_Pissey_Mood';
				case 'gaming-epic':
					loser[0] = 'Gaming_Epic';
				case 'bab':
					trace('bab');
					loser[0] = 'Babby_Pissed_Off';
				case 'bob':
					trace('bab');
					loser[0] = 'Babby_Pissed_On';
				case 'monkey':
					trace('monkey');
					loser[0] = 'Funny_Monkey';
				case 'namebe':
					trace('namebe');
					loser[0] = 'Nambe_Pissed_Off';
				case 'boygirl':
					trace('namebe boy-girl');
					loser[0] = 'Boy_Girl';
				case 'wtf':
					trace('namebe gf face');
					loser[0] = 'wtf';
				case 'gspot':
					trace('gandhi');
					loser[0] = 'G_Spot';
				case 'bon':
					trace('bonbon');
					loser[0] = 'LANCEY_IS_GOING_TO_DO_A_TEST_CHART_OF_OIL_ZIG_ZAG_BEING_SWAGGER';
			}

			var wow2Time:Bool = false;

			if (loser.length == 3)
			{
				if (loser[2] == 'flip')
					wow2Time = true;
				else
					wow2Time = false;
			}
			else
				trace('no flip?');

			if (loser[1] == 'left')
				leftPort(loser[0], wow2Time)
			else if (loser[1] == 'right')
				rightPort(loser[0], wow2Time)
			else
				trace('INVALID PORTRAIT');
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}

	function leftPort(char:String, flip:Bool = false)
	{
		portraitRight.visible = false;
		portraitLeftPixel.visible = false;
		portraitLeft.loadGraphic('assets/images/dialogueJunk/chars/' + char + '.png');
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.5));
		portraitLeft.updateHitbox();
		portraitLeft.flipX = flip;
		portraitLeft.visible = true;
	}

	function rightPort(char:String, flip:Bool = false)
	{
		portraitLeft.visible = false;
		portraitLeftPixel.visible = false;
		portraitRight.loadGraphic('assets/images/dialogueJunk/chars/' + char + '.png');
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.5));
		portraitRight.updateHitbox();
		portraitRight.flipX = flip;
		portraitRight.visible = true;
	}
}
