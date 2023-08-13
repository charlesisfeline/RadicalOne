package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import Discord.DiscordClient;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<String> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 2;

	var scoreText:FlxText;
	var charText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	public static var curChar:String = 'NewRadical';

	var previewBox:FlxSprite;
	var charPreviews:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	override function create()
	{
		DiscordClient.changePresence("In Freeplay", null, 'sussy', 'racialdiversity');

		// songs = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			}
		 */

		var isDebug:Bool = false;

		for (i in 0...StoryMenuState.weekData.length)
		{
			var sub2SkyFactorial:Array<String> = StoryMenuState.weekData[i];
			for (i in sub2SkyFactorial:)
			{
				songs.push(i);
			}
		}

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/UI/menuBGBlue.png');
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false, true,
				Song.loadFromJson('${songs[i].toLowerCase()}-hard', songs[i].toLowerCase()).player2);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		previewBox = new FlxSprite(940, 208);
		previewBox.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/Preview_Box.png', 'assets/images/UI/Preview_Box.xml');
		previewBox.animation.addByPrefix('idle', 'Preview Box Movie', 24, true);
		previewBox.animation.play('idle');

		var actualSopar:Array<String> = ['RadicalOne', 'NewRadical', 'RadiFAIL', 'RedBall', 'RacialPride'];

		charPreviews = new FlxSprite(975, 280);
		charPreviews.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/Char_Previews.png', 'assets/images/UI/Char_Previews.xml');
		for (i in actualSopar)
		{
			charPreviews.animation.addByPrefix(i, i, 24, true);
		}
		charPreviews.animation.play('idle');

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);

		charText = new FlxText(FlxG.width * 0.7, 520, 0, "", 32);
		charText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;

		add(scoreText);

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		charText.text = "CHARACTER:" + curChar;

		charPreviews.animation.play(curChar, false);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		grpSongs.forEach(function(song:Alphabet)
		{
			song.screenCenter(X);
		});

		if (FlxG.keys.justPressed.NINE)
		{
			switch (curChar)
			{
				case 'NewRadical':
					curChar = 'RadicalOne';
				case 'RadicalOne':
					curChar = 'RadiFAIL';
				case 'RadiFAIL':
					curChar = 'RedBall';
				case 'RedBall':
					curChar = 'RacialPride';
				case 'RacialPride':
					curChar = 'NewRadical';
			}
		}
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase());
			PlayState.initModes();
			PlayState.storyDifficulty = curDifficulty;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty = 2;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "RADICAL"; // uhh why not hard?
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		#end

		FlxG.sound.playMusic('assets/music/' + songs[curSelected] + "_Inst" + TitleState.soundExt, 0);

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
