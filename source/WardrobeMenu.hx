package;

import flixel.FlxG;
import flixel.FlxSprite;
import Controls.Control;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Discord.DiscordClient;

class WardrobeMenu extends MusicBeatState
{
    var racialDiversity:Array<String> = ['Radical', 'Old Radical', 'Racial Pride', 'RadiFAIL'];
    var curSelected:Int;

    var words:FlxTypedGroup<Alphabet>;

    var racial:FlxTypedGroup<WardrobeCharacter>;

    var wordPositions:Array<Float> = [];

    override function create()
    {
        if (FlxG.save.data.redballUnlock)
            racialDiversity.push('RedBall');

        if (FlxG.save.data.sussyUnlock)
            racialDiversity.push('Sussy Radical');

        if (FlxG.save.data.businessUnlock)
            racialDiversity.push('Business Radical');

        curSelected = racialDiversity.indexOf(FlxG.save.data.outfit);

        DiscordClient.changePresence("In Wardrobe", null, 'sussy', 'racialdiversity');

        var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/UI/DressRacially.png');
        add(bg);

        racial =  new FlxTypedGroup<WardrobeCharacter>();
        add(racial);

        words = new FlxTypedGroup<Alphabet>();
        add(words);

        for (i in 0...racialDiversity.length)
        {
            var thing:WardrobeCharacter = new WardrobeCharacter(0, 10, racialDiversity[i]);
            thing.screenCenter();
            if (thing.isLikeBF)
                thing.y = 85;
            else
                thing.y -= 94;
            thing.ID = i;
            thing.visible = false;
            racial.add(thing);

            var word:Alphabet = new Alphabet(0, 550, racialDiversity[i], true);
            word.screenCenter(X);
            wordPositions.push(word.x);
            word.x = word.x + i * 750;
            word.ID = i;
            words.add(word);
        }

        changeSelection(false, true);

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (controls.LEFT_P)
            changeSelection(false);

        if (controls.RIGHT_P)
            changeSelection(true);

        if (controls.BACK || controls.ACCEPT)
        {
            FlxG.save.data.outfit = racialDiversity[curSelected];
            FlxG.switchState(new ExtrasMenu());
        }

        super.update(elapsed);
    }

    function changeSelection(poop:Bool, firsty:Bool = false)
    {
        if (poop && !firsty)
            curSelected++;
        else if (!firsty)
            curSelected--;

        if (curSelected >= racialDiversity.length)
            curSelected = 0;

        if (curSelected < 0)
            curSelected = racialDiversity.length - 1;

        racial.forEach(function(thing:WardrobeCharacter){
            if (racialDiversity[curSelected] == thing.char)
                thing.visible = true;
            else
                thing.visible = false;
        });

        words.forEach(function(spr:Alphabet){
            FlxTween.cancelTweensOf(spr);
            FlxTween.tween(
                spr, {x: wordPositions[spr.ID] + (spr.ID - curSelected) * 750}, 
                0.3, {ease: FlxEase.quintOut});
        });

        if (!firsty)
            FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
    }

    public static function initOutfit()
    {
        if (FlxG.save.data.outfit == null)
            FlxG.save.data.outfit = 'Radical';

        if (FlxG.save.data.sussyUnlock == null)
            FlxG.save.data.sussyUnlock = false;

        if (FlxG.save.data.redballUnlock == null)
            FlxG.save.data.redballUnlock = false;
    }
}