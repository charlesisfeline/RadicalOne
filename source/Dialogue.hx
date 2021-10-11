package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxBasic;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;

using StringTools;

enum DialogueType
{
    Pixel;
    Regular;
    Tutorial;
}

enum Dudes
{
    Radical;
    Gaming;
    Namebe;
    Monkey;
    Babbys;
    Gspot;
}

class Dialogue extends FlxSpriteGroup
{
    public var type:DialogueType;

    var swagDialogue:FlxTypeText;
    var dropText:FlxText;

    var daText:TextManager;

    public var dialogueColor:FlxColor = FlxColor.BLACK;

    public var whosTalking:Dudes = Radical;

    var diaSounds:Array<FlxSound>;

    public function new(type:DialogueType)
    {
        super();

        this.type = type;

        switch (type)
        {
            case Tutorial:
                swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
                swagDialogue.color = 0xFF3F2021;
                swagDialogue.sounds = [FlxG.sound.load('assets/sounds/pixelText' + TitleState.soundExt, 0.6)];

                dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
                dropText.color = 0xFFD89494;

                add(dropText);
                add(swagDialogue);

                dropText.font = swagDialogue.font = 'Comic Sans MS';
            case Pixel:
                swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
                swagDialogue.color = 0xFF3F2021;
                swagDialogue.sounds = [FlxG.sound.load('assets/sounds/pixelText' + TitleState.soundExt, 0.6)];

                dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
                dropText.color = 0xFFD89494;

                add(dropText);
                add(swagDialogue);

                dropText.font = swagDialogue.font = 'Pixel Arial 11 Bold';
            case Regular:
                swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 48);
                swagDialogue.color = FlxColor.BLACK;
                swagDialogue.sounds = [FlxG.sound.load('assets/sounds/pixelText' + TitleState.soundExt, 0.6)];

                add(swagDialogue);

                swagDialogue.font = 'Bouncy Thin PERSONAL USE ONLY';
        }
    }

    public function start(time:Float = 0.04, text:String = 'swag')
    {
        whosTalking == Gspot ?
        diaSounds = [FlxG.sound.load('assets/sounds/gspot.ogg', 0.6)]:
        diaSounds = [
            for (i in 1...5) 
                FlxG.sound.load('assets/sounds/'
            + (switch (whosTalking) {
                case Radical:
                    'racial';
                case Gaming:
                    'gaming';
                case Namebe:
                    'namebe';
                case Monkey:
                    'monkey';
                case Babbys:
                    'babby';
                case Gspot:
                    'gspot';
            }) + '_$i'
            + TitleState.soundExt, 0.6)];
        
        swagDialogue.sounds = diaSounds;
        swagDialogue.resetText(text);
        swagDialogue.start(time, true);
    }

    override function update(t:Float)
    {
        if (type == Pixel)
            dropText.text = swagDialogue.text;
        super.update(t);
    }
}

class TextManager extends FlxSpriteGroup
{
    public var text:String = 'swaggg';

    public var offsetX:Float = 0;
    public var offsetY:Float = 0;
    public var daWidth:Int;

    public function new(offsetX:Float, offsetY:Float, width:Int, size:Int)
    {
        super(0, offsetY);

        this.offsetX = offsetX;
        daWidth = width;
    }

    private var txtArray:Array<DiaChar> = [];
    public static var coolWidth:Int = 0;

    public function start(time:Float)
    {
        offsetY = coolWidth = 0;
        for (char in txtArray)
        {
            char.kill();
        }
        txtArray = [];

        var splitText:Array<String> = text.split('');
        var splitWords:Array<String> = text.split(' ');

        var realIndex:Int = 0;

        for (i in 0...splitText.length)
        {
            if (coolWidth == 0 && splitText[i] == ' ')
                continue;
            var daChar:DiaChar = new DiaChar(splitText[i], coolWidth + offsetX, offsetY, time * realIndex);
            add(daChar);
            txtArray.push(daChar);
            if (coolWidth + 42 >= daWidth)
            {
                coolWidth = 0;
                offsetY += 42;
            }

            realIndex++;
        }
    }
}

class DiaChar extends FlxSpriteGroup
{
    static inline final shortChars:String = "il;'!.,";
    static inline final longChars:String = "mwMW";

    public function new(character:String, offsetX:Float = 0, offsetY:Float = 0, tmrOffset:Float = 1)
    {
        super();

        var daCharacter:FlxText = new FlxText(offsetX, offsetY, 100, character, 32);
        daCharacter.font = 'HAPPY DONUTS';
        daCharacter.color = FlxColor.BLACK;

        // IDK IF THESES VALUES ARE EVEN TRUE IM JUST PUTTIN RANDOM JUNK LOLOL
        if (shortChars.split('').contains(character))
            TextManager.coolWidth += 25;
        else if (longChars.split('').contains(character))
            TextManager.coolWidth += 56;
        else
            TextManager.coolWidth += 42;

        scale.set(0, 0);

        new FlxTimer().start(tmrOffset, function(tmr:FlxTimer){
            add(daCharacter);

            FlxTween.tween(this, {"scale.x": 1.3, "scale.y": 1.3}, 0.075, {onComplete: function(twn:FlxTween){
                FlxTween.tween(this, {"scale.x": 1, "scale.y": 1}, 0.15, {ease: FlxEase.quadOut});
            }, ease: FlxEase.quadIn});
        });
    }
}