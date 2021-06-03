package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import Discord.DiscordClient;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	public static var weekData:Array<Dynamic> = [
		['Tutorial'],
		['Job-Interview', 'Working-Hard', 'Gamings-Congrats'],
		['North', 'Radical-vs-Masked-Babbys', 'Monkey-Sprite'],
		['Namebe', 'FNAF-at-Phillys', "Destructed"],
		['BonBon-LOOOL', "Without-You", "Bonnie-Song"],
		['Cocoa', 'Eggnog', 'Winter-Horrorland'],
		['Ceast'],
		['Bustom-Source', 'FL-Keys', 'I-Didnt-Ask']
	];

	var weekNames:Array<String> = [
		'real tutorial 100%',
		'get a job',
		'minecraft babbys',
		'test',
		'te'
	];

	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var weekPreview:FlxSprite;
	var weekPreviewShad:FlxSprite;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxTypedGroup<FlxSprite>;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var yellowBG:FlxSprite;
	var yellowBGButItsABarLOOL:FlxSprite;
	var yellowBGCoverLower:FlxSprite;
	var yellowBGCoverUpper:FlxSprite;

	var rankText:FlxText;

	override function create()
	{
		DiscordClient.changePresence("In Story Menu", null, 'sussy', 'racialdiversity');

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
		}

		persistentUpdate = persistentDraw = true;

		//publicWeekData = weekData;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		rankText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat("assets/fonts/vcr.ttf", 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = FlxAtlasFrames.fromSparrow('assets/images/UI/campaign_menu_UI_assets.png', 'assets/images/UI/campaign_menu_UI_assets.xml');
		yellowBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFE9575C);
		yellowBGButItsABarLOOL = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFE9575C);
		yellowBGCoverLower = new FlxSprite(0, 456).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		yellowBGCoverUpper = new FlxSprite(0, 0).makeGraphic(FlxG.width, 56, FlxColor.BLACK);

		add(yellowBG);
		add(yellowBGCoverLower);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		add(yellowBGCoverUpper);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBGButItsABarLOOL.y + yellowBGButItsABarLOOL.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			weekUnlocked.push(true);

			// Needs an offset thingie
			/*if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}*/
		}

		trace("Line 96");	

		difficultySelectors = new FlxTypedGroup<FlxSprite>();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(yellowBGButItsABarLOOL);

		weekPreviewShad = new FlxSprite();
		add(weekPreviewShad);
		weekPreview = new FlxSprite();
		add(weekPreview);
		
		

		txtTracklist = new FlxText(FlxG.width + 50, yellowBGButItsABarLOOL.x + yellowBGButItsABarLOOL.height + 100, 0, "Tracks", 25);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		//add(txtWeekTitle);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = true;

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (0 == 0) // poop and fart. both.
		{
			if (stopspamming == false)
			{
				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
				stopspamming = true;
			}

			var songsToPlay:Array<String> = [];

			for (i in 0...weekData[curWeek].length)
			{
				songsToPlay.push(weekData[curWeek][i]);
			}

			PlayState.storyPlaylist = songsToPlay;
			PlayState.initModes();
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

            FlxG.camera.flash(FlxColor.WHITE, 1);

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;

			new FlxTimer().start(0.5, function(tmr:FlxTimer){
				FlxTween.tween(yellowBGCoverLower, {y: FlxG.height + 10}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(yellowBGCoverUpper, {y: -yellowBGCoverUpper.height - 10}, 0.5, {ease: FlxEase.quadOut});
			});

			FlxTween.tween(scoreText, {x: -400}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(txtTracklist, {x: -400}, 0.5, {ease: FlxEase.quadOut});

			//FlxTween.tween(weekPreview, {y: 0, 'scale.x': FlxG.width / weekPreview.width, 'scale.y': FlxG.height / 400}, 0.5, {ease: FlxEase.quadOut});
			//FlxTween.tween(weekPreviewShad, {y: 10, 'scale.x': FlxG.width / weekPreviewShad.width, 'scale.y': FlxG.height / 400}, 0.5, {ease: FlxEase.quadOut});

			difficultySelectors.forEach(function(spr:FlxSprite){
				FlxTween.tween(spr, {x: spr.x + 400}, 0.5, {ease: FlxEase.quadOut});
			});

			grpWeekText.forEach(function(spr:FlxSprite){
				FlxTween.tween(spr, {alpha: 0}, 0.35, {ease: FlxEase.quadOut});
			});
			
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				FlxG.switchState(new PlayState());
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0))
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);

		updateText();
	}

	function updateText()
	{
		txtTracklist.text = "Tracks\n";

		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		weekPreview.loadGraphic('assets/images/UI/weekPreview/week' + Std.string(curWeek) + '.png');
		if (weekPreview.height < 400)
			weekPreview.antialiasing = true;
		else
			weekPreview.antialiasing = false;
		weekPreview.setGraphicSize(0, 400);
		weekPreview.updateHitbox();
		weekPreview.screenCenter(X);
		weekPreview.y = 56;

		weekPreviewShad.loadGraphic('assets/images/UI/weekPreview/week' + Std.string(curWeek) + '.png');
		weekPreviewShad.color = FlxColor.BLACK;
		weekPreviewShad.alpha = 0.5;
		if (weekPreviewShad.height < 400)
			weekPreviewShad.antialiasing = true;
		else
			weekPreviewShad.antialiasing = false;
		weekPreviewShad.setGraphicSize(0, 400);
		weekPreviewShad.updateHitbox();
		weekPreviewShad.setPosition(weekPreview.x + 10, weekPreview.y + 10);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	/*static public function correctSongData()
	{
		theRealCorrect();
	}

	function theRealCorrect()
	{
		publicWeekData = weekData;
	}*/
}
