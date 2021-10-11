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
        // ['Nadalyn-Sings-Spookeez', 'Nadbattle', 'Nadders'],
		// ['Start-Conjunction', 'Energy-Lights', 'Telegroove'],
        ['Senpai', 'Roses', 'Thorns'],
        ['the-backyardagains', 'funny'],
        ['Interrogation', 'Tha-Biscoot', 'Among-Us-Happy-Meal', 'Chuckie', '4.3', 'Scribble-Street', 'Scary-Junk', 'Thanos-Rumble', 'Normal-Ghost', 'Plush-Factory', 'Spoar-Travel'],
        ['Freebeat_1', 'JunkRUs', 'Picnic-Rumble']
    ];

    var weekendChars:Array<String> = [
        // 'nadalyn',
        // 'salted',
        'wow',
        'austin',
        'questioning',
        'redball'
    ];

    var weekendDescriptions:Array<String> = [
        // 'She/her \nI make sparta remixes.',
        // 'Rap against the most wicked \nmusic producer of all time, \nLightly Satled Beans!',
        'Uh oh! Looks like a RACIAL \nVIRUS has infected week 6!! \nDo you have the wits to \nsurvive?',
        'He played a little joke on \nyou in the past, but he\'s \nnot messin\' around this time!',
        'Just random one-off levels \nwe made. Expect some crazy \nand zany things!I mean my \nJunk.',
        'You bought a ticket to the \ncircus but found out you were \nthe only one that came!'
    ];

    var weekendNames:Array<String> = [
        // 'Nadalyn',
        // 'LSB',
        'Wow',
        'FNAF',
        'Jo Junk',
        'Redball'
    ];

    var curWeekend:Int = 1;

    var pic:FlxSprite;

    override function create()
    {
        DiscordClient.changePresence("In Weekend Menu", null, 'sussy', 'racialdiversity');

        if (FlxG.sound.music != null)
        {
            if (!FlxG.sound.music.playing)
                FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
        }

        if (FlxG.save.data.skipFlash == null) FlxG.save.data.skipFlash = false;
        if (FlxG.save.data.skipCopy == null) FlxG.save.data.skipCopy = false;

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

        pic = new FlxSprite(0, 83);
        add(pic);

        squish = new FlxSprite(410, 610 - 2);
        squish.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/scrolly_thing.png', 'assets/images/UI/scrolly_thing.xml');
        squish.animation.addByPrefix('idle', 'scroll squish', 24, true);
        squish.animation.addByPrefix('left', 'scroll left', 24, false);
        squish.animation.addByPrefix('right', 'scroll right', 24, false);
        squish.animation.play('idle');
        add(squish);

        /*
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
        */

        regRacial = new WardrobeCharacter(417, 2370, 'Radical');
		regRacial.setGraphicSize(0, 225);
		regRacial.updateHitbox();

		// regIcon = new HealthIcon();

        unlockedThing = new FlxSprite().loadGraphic('assets/images/UI/soparatic.png');
		unlockedThing.setGraphicSize(Std.int(unlockedThing.width * 0.65));
		unlockedThing.updateHitbox(); // 417, 370
		unlockedThing.screenCenter();

		newRacial = new WardrobeCharacter(regRacial.x + 300, 2370, skin2Unlock);
		newRacial.setGraphicSize(0, 225);
		newRacial.updateHitbox();

        add(txtWeekendTitle);
        add(txtDesc);
        add(trackList);

        persistentUpdate = persistentDraw = true;

        paused = true;

        new FlxTimer().start(0.000001, function(tmr:FlxTimer) // what
        {
            paused = false;
        });

        var daY:Float = unlockedThing.y;
		unlockedThing.y += 2000;
		if (justUnlockedSkin)
		{
			justUnlockedSkin = false;
			add(unlockedThing);
			add(regRacial);
			add(newRacial);
			canSelect = false;
			new FlxTimer().start(0.75, function(tmr:FlxTimer){
				FlxTween.tween(unlockedThing, {y: daY}, 1.5, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween){
					new FlxTimer().start(0.5, function(tmr:FlxTimer){
						canExitUnlock = true;
					});
				}});
				FlxTween.tween(regRacial, {y: 370}, 1.5, {ease: FlxEase.quintOut});
				FlxTween.tween(newRacial, {y: 370}, 1.5, {ease: FlxEase.quintOut});
			});
		}

        updateText();

        super.create();
    }

    var canSelect:Bool = true;
	var canExitUnlock:Bool = false;
    var unlockedThing:FlxSprite;

	var regRacial:WardrobeCharacter;
	var newRacial:WardrobeCharacter;

    public static var justUnlockedSkin:Bool = false;
	public static var skin2Unlock:String = 'Radical';

    override function update(elapsed:Float)
    {
        lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "SCORE:" + lerpScore;

        txtWeekendTitle.text = weekendNames[curWeekend];
        txtDesc.text = weekendDescriptions[curWeekend];

        if (!canSelect && canExitUnlock)
		{
			if (controls.ACCEPT)
			{
				new FlxTimer().start(0.5, function(junk:FlxTimer){
					canSelect = true;
				});
				FlxTween.tween(unlockedThing, {alpha: 0}, 1, {ease: FlxEase.quintOut});
				FlxTween.tween(regRacial, {alpha: 0}, 1, {ease: FlxEase.quintOut});
				FlxTween.tween(newRacial, {alpha: 0}, 1, {ease: FlxEase.quintOut});
			}
		}

        if (!movedBack && !paused && canSelect)
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
                switch (curWeekend) {
                    case 0:
                        FlxG.save.data.skipFlash ?
                        selectWeekend():
                        flashWarning('flashy');
                    case 1 | 2:
                        FlxG.save.data.skipCopy ?
                        selectWeekend():
                        flashWarning('copyright');
                    default:
                        selectWeekend();
                }
            }

            if (FlxG.keys.justPressed.G)
            {
                if (Highscore.getWeekendScore(curWeekend) > 0)
                    openSubState(new WeekendFreeplaySubState(weekendData[curWeekend]));
            }
        }
    
        if (controls.BACK && !movedBack && !selectedWeekend && !paused && canSelect)
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

    function flashWarning(img:String):Void
    {
        canSelect = false;
        var warn:FlxSprite = new FlxSprite().loadGraphic('assets/images/UI/$img.png');
        warn.screenCenter();
        warn.alpha = 0;
        add(warn);
        FlxTween.tween(warn, {alpha: 1}, 0.45, {onComplete: function(twn:FlxTween){
            new FlxTimer().start(0, function(tmr:FlxTimer){
                if (FlxG.keys.justPressed.ENTER) {
                    warn.alpha = 0;
                    selectWeekend();
                }
                else if (FlxG.keys.justPressed.P) {
                    img == 'flash' ?
                    FlxG.save.data.skipFlash = true:
                    FlxG.save.data.skipCopy = true;
                    warn.alpha = 0;
                    selectWeekend();
                }
                else if (FlxG.keys.justPressed.ESCAPE) {
                    warn.kill();
                    new FlxTimer().start(0.001, function(t:FlxTimer){
                        canSelect = true;
                    });
                }
                else
                    tmr.reset();
            });
        }});
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
        PlayState.weekendName = weekendNames[curWeekend];
		selectedWeekend = true;

        FlxG.camera.flash(FlxColor.WHITE, 1);

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
        pic.loadGraphic('assets/images/UI/weekPreview/weekend$curWeekend.png');
        pic.setGraphicSize(460, 550);
        pic.updateHitbox();

        if (curWeekend == 2)
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