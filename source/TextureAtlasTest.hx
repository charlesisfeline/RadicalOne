package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import haxe.Json;
import lime.utils.Assets;
import animateatlas.AtlasFrameMaker;

using StringTools;

class TextureAtlasTest extends MusicBeatState
{
    override function create()
    {
        var tex:FlxAtlasFrames = new FlxAtlasFrames(FlxGraphic.fromAssetKey(Character.charPath + 'monkey_sprite/spritemap.png'), new FlxPoint(1024, 1024));
        for (i in jsonLoad(Character.charPath + 'monkey_sprite/spritemap.json').SPRITES)
        {
            var frameData = i.SPRITE;
            tex.addAtlasFrame(new FlxRect(frameData.x, frameData.y, frameData.w, frameData.h), new FlxPoint(1024, 1024), new FlxPoint(0, 0), frameData.name);
        }
        var test:FlxSprite = new FlxSprite();
        var tex2 = AtlasFrameMaker.construct(Character.charPath + 'monkey_sprite', ['Idle']);
        test.frames = tex2;
        trace(tex2);
        test.animation.addByPrefix('idle', 'Idle', 24, false);
        test.animation.play('idle');
        //trace(tex);
        add(test);
        super.create();
    }

    public static function jsonLoad(path:String):Atlas
    {
        var rawJson = Assets.getText(path).trim();

        while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

        while (!rawJson.startsWith("{"))
            rawJson = rawJson.substr(1, rawJson.length);

        // trace(rawJson);

        return cast Json.parse(rawJson).ATLAS;
    }
}

typedef Atlas = {
    var SPRITES:Array<SprData>;
}

typedef SprData = {
    var SPRITE:FrameData;
}

typedef FrameData = {
    var name:String;
    var x:Int;
    var y:Int;
    var w:Int;
    var h:Int;
    var rotated:Bool;
}