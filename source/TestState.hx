package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;

class TestState extends MusicBeatState 
{
    var swagThing:FlxSprite = new FlxSprite();
    var txt:FlxText;

    override function create()
    {
        FlxG.sound.playMusic('assets/sounds/soundTest.ogg');

        swagThing.loadGraphic('assets/images/newgrounds_logo.png');
        swagThing.screenCenter();
        add(swagThing);

        txt = new FlxText(250);
        add(txt);

        Conductor.changeBPM(120);

        super.create();
    }

    override function update(elapsed:Float)
    {
        Conductor.songPosition = FlxG.sound.music.time;

        if (FlxG.keys.justPressed.ANY) FlxG.switchState(new MainMenuState());

        super.update(elapsed);
    }

    override function beatHit()
    {
        var tempBeat = lastBeat;
        super.beatHit();
        txt.text = 'time since last beat: ' + (lastBeat - tempBeat);

        swagThing.scale.set(1.35, 1.35);
        FlxTween.cancelTweensOf(swagThing);
        FlxTween.tween(swagThing, {"scale.x": 1, "scale.y": 1}, Conductor.crochet / 2000);
    }
}