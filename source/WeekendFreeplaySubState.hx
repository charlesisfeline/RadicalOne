package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class WeekendFreeplaySubState extends MusicBeatSubstate
{
    var testign:FlxSprite;

    var funnyArrow:FlxText;

    var curSelected:Int = 0;

    var allTheseSongsDude:Array<String> = [];

    var grpSongNames:FlxTypedGroup<FlxText>;

    public function new(songArray:Array<String>)
    {
        super();
        trace('the junk');

        var boxWidth:Int = 0;

        allTheseSongsDude = songArray;

        for (i in allTheseSongsDude)
        {
            if (i.length > boxWidth)
                boxWidth = i.length;
        }

        testign = new FlxSprite().makeGraphic(boxWidth * 40, allTheseSongsDude.length * 40, FlxColor.BLACK);
        testign.alpha = 0.5;
        testign.screenCenter();
        add(testign);

        funnyArrow = new FlxText(testign.x, testign.y - 6);
        funnyArrow.size = 40;
        funnyArrow.text = '>';
        add(funnyArrow);

        grpSongNames = new FlxTypedGroup<FlxText>();
        add(grpSongNames);

        for (i in 0...allTheseSongsDude.length)
        {
            var coolSongName:FlxText = new FlxText(testign.x + 40, testign.y + i * 40 - 6);
            coolSongName.size = 40;
            coolSongName.text = allTheseSongsDude[i];
            grpSongNames.add(coolSongName);
        }
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ESCAPE)
            close();


        if (controls.DOWN_P)
            curSelected += 1;
        
        if (controls.UP_P)
            curSelected -= 1;

        if (curSelected == -1)
            curSelected = allTheseSongsDude.length - 1;

        if (curSelected > allTheseSongsDude.length - 1)
            curSelected = 0;

        funnyArrow.y = testign.y + curSelected * 40 - 6;

        grpSongNames.forEach(function(songName:FlxText)
        {
            if (songName.text == allTheseSongsDude[curSelected])
                songName.color = FlxColor.WHITE;
            else
                songName.color = 0xFFAAAAAA;
        });

        if (controls.ACCEPT)
		{
			var poop:String = Highscore.formatSong(allTheseSongsDude[curSelected].toLowerCase(), 1);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, allTheseSongsDude[curSelected].toLowerCase());
			PlayState.initModes();
            PlayState.weekEndFreeplay = true;
			PlayState.storyDifficulty = 1;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}
    }
}