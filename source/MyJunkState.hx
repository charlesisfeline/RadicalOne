package;

import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import lime.app.Application;
import openfl.Assets;
import polymod.Polymod;

using StringTools;

class MyJunkState extends MusicBeatState
{
    var MYJUNK:FlxSprite;

    override public function create()
    {
        Conductor.changeBPM(102);
		persistentUpdate = true;
		persistentDraw = true;
        PlayerSettings.init();

        FlxG.mouse.visible = false;


        //MYJUNK = new FlxSprite(640, 360);
        MYJUNK = new FlxSprite(0, 0);
        MYJUNK.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/MYJUNK.png', 'assets/images/UI/MYJUNK.xml');
        MYJUNK.animation.addByPrefix('JUNKENING', 'Movie', 24, false);
        MYJUNK.animation.play('JUNKENING');
        add(MYJUNK);

        FlxG.sound.play('assets/sounds/splash.ogg', 1, false, null, true, function()
        {
            FlxG.switchState(new TitleState());
        });
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}