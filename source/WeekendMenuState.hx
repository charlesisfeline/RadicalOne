package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import Discord.DiscordClient;
import flixel.FlxSubState;

using StringTools;

class WeekendMenuState extends MusicBeatState
{
    var scoreText:FlxText;
    var txtWeekendTitle:FlxText;
    var txtDesc:FlxText;
    var trackList:FlxText;

    var movedBack:Bool = false;
	var selectedWeekend:Bool = false;
	var stopspamming:Bool = false;

    var lerpScore:Int = 0;
	var intendedScore:Int = 0;

    var squish:FlxSprite;
    var suckers:FlxSprite;

    public static var weekendData:Array<Dynamic> = [
        ['Nadalyn-Sings-Spookeez', 'Nadbattle', 'Nadders'],
		['Start-Conjunction', 'Energy-Lights', 'Telegroove'],
        ['Senpai', 'Roses', 'Thorns'],
        ['the-backyardagains', 'funny'],
        ['Interrogation', 'Tha-Biscoot', 'Among-Us-Happy-Meal', 'Chuckie', '3.4', 'Scribble-Street', 'Scary-Junk', 'Thanos-Rumble', 'Normal-Ghost'],
        ['Freebeat_1', 'JunkRUs', 'Picnic-Rumble', 'Dawgee-Want-Food', 'Dream']
    ];

    var weekendChars:Array<String> = [
        'nadalyn',
        'salted',
        'wow',
        'austin',
        'questioning',
        'redball'
    ];

    var weekendDescriptions:Array<String> = [
        'She/her \nI make sparta remixes.',
        'Rap against the most wicked \nmusic producer of all time, \nLightly Satled Beans!',
        'Uh oh! Looks like a RACIAL \nVIRUS has infected week 6!! \nDo you have the wits to \nsurvive?',
        'He played a little joke on \nyou in the past, but he\'s \nnot messin\' around this time!',
        'Just random one-off levels \nwe made. Expect some crazy \nand zany things!I mean my \nJunk.',
        'You bought a ticket to the \ncircus but found out you were \nthe only one that came!'
    ];

    var weekendNames:Array<String> = [
        'Nadalyn',
        'LSB',
        'Wow',
        'FNAF',
        'Jo Junk',
        'Redball'
    ];

    var curWeekend:Int = 3;

    override function create()
    {
        DiscordClient.changePresence("In Weekend Menu", null, 'sussy', 'racialdiversity');

        if (FlxG.sound.music != null)
        {
            if (!FlxG.sound.music.playing)
                FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
        }

        if (Highscore.getWeekendScore(2) > 0)
            FlxG.save.data.sussyUnlock = true;

        if (Highscore.getWeekendScore(5) > 0)
            FlxG.save.data.redballUnlock = true;

        //publicWeekendData = weekendData;

        scoreText = new FlxText(10, 20, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);
        add(scoreText);

        txtWeekendTitle = new FlxText(500, 100, 0, "", 80);
		txtWeekendTitle.setFormat("VCR OSD Mono", 80, FlxColor.BLACK);

        trackList = new FlxText(FlxG.width * 0.7, 20, 0, "", 32);
		trackList.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
        trackList.text = getWeekData();
        trackList.x = FlxG.width - (trackList.width + 10);

        txtDesc = new FlxText(500, 230, 0, "", 45);
		txtDesc.setFormat("VCR OSD Mono", 45, FlxColor.BLACK);

        var redBG:FlxSprite = new FlxSprite(0, 83).makeGraphic(FlxG.width, 550, 0xFFE9575C);
        add(redBG);
        var blackBarOne:FlxSprite = new FlxSprite(460, 45).makeGraphic(10, 660, 0xFF000000);
        add(blackBarOne);
        var blackBarTwo:FlxSprite = new FlxSprite(460, 200).makeGraphic(850, 10, 0xFF000000); // pretty sure theres a better way to do this?
        add(blackBarTwo);                                                                       // there isnt lol

        squish = new FlxSprite(410, 610 - 2);
        squish.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/scrolly_thing.png', 'assets/images/UI/scrolly_thing.xml');
        squish.animation.addByPrefix('idle', 'scroll squish', 24, true);
        squish.animation.addByPrefix('left', 'scroll left', 24, false);
        squish.animation.addByPrefix('right', 'scroll right', 24, false);
        squish.animation.play('idle');
        add(squish);

        suckers = new FlxSprite(10, 85);
        suckers.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/weekendSuckers.png', 'assets/images/UI/weekendSuckers.xml');
        for (i in 0...weekendChars.length)
        {
            suckers.animation.addByPrefix(weekendChars[i], weekendChars[i], 24, true);
        }
        suckers.animation.play('austin');
        suckers.setGraphicSize(Std.int(suckers.width * 0.925));
        suckers.antialiasing = true;
        suckers.updateHitbox();
        add(suckers);

        add(txtWeekendTitle);
        add(txtDesc);
        add(trackList);

        persistentUpdate = persistentDraw = true;

        paused = true;

        new FlxTimer().start(0.000001, function(tmr:FlxTimer) // what
        {
            paused = false;
        });

        super.create();
    }

    override function update(elapsed:Float)
    {
        lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "SCORE:" + lerpScore;

        txtWeekendTitle.text = weekendNames[curWeekend];
        txtDesc.text = weekendDescriptions[curWeekend];

        if (!movedBack && !paused)
        {
            if (!selectedWeekend)
            {
                if (controls.LEFT_P)
                {
                    changeWeekend(-1);
                    squish.animation.play('left', true);
                    new FlxTimer().start(0.5, function(tmr:FlxTimer)
                    {
                        squish.animation.play('idle', false);
                    });
                }
    
                if (controls.RIGHT_P)
                {
                    changeWeekend(1);
                    squish.animation.play('right', true);
                    new FlxTimer().start(0.5, function(tmr:FlxTimer)
                    {
                        squish.animation.play('idle', false);
                    });
                }
            }
    
            if (controls.ACCEPT)
            {
                selectWeekend();
            }

            if (FlxG.keys.justPressed.G)
            {
                if (Highscore.getWeekendScore(curWeekend) > 0)
                    openSubState(new WeekendFreeplaySubState(weekendData[curWeekend]));
            }
        }
    
        if (controls.BACK && !movedBack && !selectedWeekend && !paused)
        {
            FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
            movedBack = true;
            FlxG.switchState(new MainMenuState());
        }

        super.update(elapsed);
    }

    override function openSubState(SubState:FlxSubState)
	{
        if (!paused)
        {
            paused = true;
        }

		super.openSubState(SubState);
	}

    private var paused:Bool;

	override function closeSubState()
    {
        if (paused)
        { 
            paused = false;
        }
		super.closeSubState();
	}
    
    function selectWeekend()
    {
        if (stopspamming == false)
		{
			FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
			stopspamming = true;
		}

        var songsToPlay:Array<String> = [];

        for (i in 0...weekendData[curWeekend].length)
        {
            songsToPlay.push(weekendData[curWeekend][i]);
        }

        trace(songsToPlay);

		PlayState.weekendPlaylist = songsToPlay;
        PlayState.initModes();
        PlayState.isWeekend = true;
		selectedWeekend = true;

        PlayState.SONG = Song.loadFromJson(PlayState.weekendPlaylist[0].toLowerCase(), PlayState.weekendPlaylist[0].toLowerCase());
		PlayState.weekend = curWeekend;
        PlayState.weekendScore = 0;
        new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
			FlxG.switchState(new PlayState());
		});
    }

    function changeWeekend(change:Int = 0):Void
    {
        curWeekend += change;

        if (curWeekend >= weekendData.length)
			curWeekend = 0;
		if (curWeekend < 0)
			curWeekend = weekendData.length - 1;

        FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);

		updateText();
    }

    function updateText()
    {
        intendedScore = Highscore.getWeekendScore(curWeekend);
        suckers.animation.play(weekendChars[curWeekend]);
        switch (weekendChars[curWeekend])
        {
            case 'austin':
                suckers.x = 10;
                suckers.y = 85;
            case 'nadalyn':
                suckers.x = 0;
                suckers.y = 140;
            case 'wow':
                suckers.x = 25;
                suckers.y = 155;
            default:
                suckers.x = 10;
                suckers.y = 140;
        }

        if (curWeekend == 4)
            trackList.text = 'SONGS: ???';
        else
            trackList.text = getWeekData();
        trackList.x = FlxG.width - (trackList.width + 10);
    }

    function getWeekData()
    {
        var daListData:String = 'SONGS: ';
        for (i in 0...weekendData[curWeekend].length)
        {
            var daSongs:Array<String> = weekendData[curWeekend];
            var separator:String = ', ';
            if (i == daSongs.length - 1)
                separator = '';
            daListData += daSongs[i].toUpperCase() + separator;
        }
        return daListData.trim();
    }

    /*static public function correctSongArray()
    {
        theRealCorrect();
    }

    function theRealCorrect()
    {
        publicWeekendData = weekendData;
    }*/
}