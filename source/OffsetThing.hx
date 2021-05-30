package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import Controls.Control;

using StringTools;

class OffsetThing extends MusicBeatSubstate
{
    var dunkIt:FlxText;
    var REALANDCCANON:Int = Std.int(FlxG.save.data.offset * 10);
    public function new()
    {
        super();
        var fjgkfd:FlxSprite = new FlxSprite().makeGraphic(590, 50, FlxColor.BLACK);
        fjgkfd.alpha = 0.5;
        fjgkfd.screenCenter();
        add(fjgkfd);

        dunkIt = new FlxText(fjgkfd.x, fjgkfd.y, 0, "https://media.discordapp.net/attachments/534520757917581312/846917659391033384/speed.gif", 20);
		dunkIt.setFormat("VCR OSD Mono", 20, FlxColor.WHITE);
        add(dunkIt);
    }

    override function update(elapsed:Float)
    {
        if (controls.LEFT_P)
        {
            REALANDCCANON -= 1;
        }

        if(REALANDCCANON < -20)
            REALANDCCANON = -20;

        if(REALANDCCANON > 20)
            REALANDCCANON = 20;

        if (controls.RIGHT_P)
        {
            REALANDCCANON += 1;
        }

        FlxG.save.data.offset = REALANDCCANON / 10;

        if (controls.BACK)
            close();
        dunkIt.text = 'Stupid Kade Engine offset thing idk \nCurrent Offset: ' + Std.string(FlxG.save.data.offset);
        super.update(elapsed);
    }
}