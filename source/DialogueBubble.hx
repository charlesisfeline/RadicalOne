package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;

using StringTools;

class DialogueBubble extends FlxSpriteGroup
{
	var box:FlxSprite;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var whosTalking:String = '';

	public var finishThing:Void->Void;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		box = new FlxSprite(40);
		box.frames = FlxAtlasFrames.fromSparrow('assets/images/dialogueJunk/speech_bubble_talking.png', 'assets/images/dialogueJunk/speech_bubble_talking.xml');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.addByPrefix('loudOpen', 'speech bubble loud open', 24, false);
		box.animation.addByPrefix('loud', 'AHH speech bubble', 24);
		box.animation.addByPrefix('gamingOpen', 'gaming text Box open', 24, false);
		box.animation.addByPrefix('gaming', 'gaming text box', 24);
		box.animation.play('normalOpen');
		add(box);

		if (!talkingRight)
		{
			box.flipX = true;
		}

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		add(dialogue);

		this.dialogueList = dialogueList;
	}
	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (box.animation.curAnim != null)
		{
			box.animation.play(box.animation.curAnim.name.substring(0, box.animation.curAnim.name.indexOf('Open')));
			dialogueOpened = true;
		}

		if (box.animation.curAnim.name.startsWith('normal'))
		{
			box.x = 40;
			box.y = 375;
			dialogue.setPosition(0, FlxG.height * 0.5 + 80);
		}
		else if (box.animation.curAnim.name.startsWith('loud'))
		{
			box.x = 0;
			box.y = 305;
			dialogue.setPosition(0, FlxG.height * 0.5 + 80);
		}
		else
		{
			box.x = 150;
			box.y = 180;
			dialogue.setPosition(145, 175);
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			remove(dialogue);

			if (dialogueList[1] == null)
			{
				finishThing();
				kill();
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	function startDialogue():Void
	{
		cleanDialog();

		switch (whosTalking)
		{
			case 'left':
				if (box.animation.curAnim.name != 'normal' || box.flipX == false)
				{
					box.animation.play('normalOpen');
					box.flipX = true;
					FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);
				}
				PlayState.focusOnTheDudes();
			case 'right':
				if (box.animation.curAnim.name != 'normal' || box.flipX == true)
				{
					box.animation.play('normalOpen');
					box.flipX = false;
					FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);
				}
				PlayState.focusOnTheDudes();
			case 'left-loud':
				if (box.animation.curAnim.name != 'loud' || box.flipX == true)
				{
					box.animation.play('loudOpen');
					box.flipX = false;
					FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);
				}
				PlayState.focusOnTheDudes();
			case 'right-loud':
				if (box.animation.curAnim.name != 'loud' || box.flipX == false)
				{
					box.animation.play('loudOpen');
					box.flipX = true;
					FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);
				}
				PlayState.focusOnTheDudes();
			case 'gaming':
				if (box.animation.curAnim.name != 'gaming' || box.flipX == true)
				{
					trace('GAMING DIALOGUE QUE');
					box.animation.play('gamingOpen');
					box.flipX = false;
					FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);
				}
				PlayState.zoomIntoGaming();
		}

		var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		dialogue = theDialog;
		add(theDialog);
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(':');
		whosTalking = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
		dialogueList[0] = checkForReturn(dialogueList[0]);
	}

	function checkForReturn(daText:String)
	{
		var newText:Array<String> = daText.split('~');
		var swagText:String = '';
		for (i in 0...newText.length)
		{
			swagText += newText[i].trim() + '\n';
		}
		return swagText;
	}
}
