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

    var allTheseSongsDude:Array<Array<String>> = [[]];
    var songsToDisplay:Array<String> = [];
    var curSection:Int = 0;

    var grpSongNames:FlxTypedGroup<FlxText>;

    public function new(songArray:Array<String>)
    {
        super();
        trace('the junk');

        var boxWidth:Int = 0;

        var songIndex:Int = 0;
        var songsSection:Int = 0;

        for (i in 0...songArray.length)
        {
            allTheseSongsDude[songsSection].push(songArray[i]);
            songIndex++;
            if (songIndex == 6)
            {
                songIndex = 1;
                allTheseSongsDude[songsSection].push('...');
                allTheseSongsDude.push(['^^^']);
                songsSection++;
            }
        }

        songsToDisplay = allTheseSongsDude[curSection];
        //allTheseSongsDude = songArray;

        for (i in songArray)
        {
            if (i.length > boxWidth)
                boxWidth = i.length;
        }

        testign = new FlxSprite().makeGraphic(boxWidth * 40, allTheseSongsDude[0].length * 40, FlxColor.BLACK);
        testign.alpha = 0.5;
        testign.screenCenter();
        add(testign);

        funnyArrow = new FlxText(testign.x, testign.y - 6);
        funnyArrow.size = 40;
        funnyArrow.text = '>';
        add(funnyArrow);

        grpSongNames = new FlxTypedGroup<FlxText>();
        add(grpSongNames);

        createText();
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
            curSelected = songsToDisplay.length - 1;

        if (curSelected > songsToDisplay.length - 1)
            curSelected = 0;

        funnyArrow.y = testign.y + curSelected * 40 - 6;

        grpSongNames.forEach(function(songName:FlxText)
        {
            if (songName.text == songsToDisplay[curSelected])
                songName.color = FlxColor.WHITE;
            else
                songName.color = 0xFFAAAAAA;
        });

        if (controls.ACCEPT)
		{
            if (songsToDisplay[curSelected] == '...')
            {
                curSection++;
                songsToDisplay = allTheseSongsDude[curSection];
                curSelected = 1;
                createText();
            }
            else if (songsToDisplay[curSelected] == '^^^')
            {
                curSection--;
                songsToDisplay = allTheseSongsDude[curSection];
                curSelected = 5;
                createText();
            }
            else
            {
                var poop:String = Highscore.formatSong(songsToDisplay[curSelected].toLowerCase(), 1);

                trace(poop);
    
                PlayState.SONG = Song.loadFromJson(poop, songsToDisplay[curSelected].toLowerCase());
                PlayState.initModes();
                PlayState.weekEndFreeplay = true;
                PlayState.storyDifficulty = 1;
                FlxG.switchState(new PlayState());
                if (FlxG.sound.music != null)
                    FlxG.sound.music.stop();
            }
		}
    }

    function createText()
    {
        grpSongNames.forEachAlive(function(spr:FlxText)
        {
            spr.kill();
        });

        for (i in 0...songsToDisplay.length)
        {
            var coolSongName:FlxText = new FlxText(testign.x + 40, testign.y + i * 40 - 6);
            coolSongName.size = 40;
            coolSongName.text = songsToDisplay[i];
            grpSongNames.add(coolSongName);
        }
    }
}