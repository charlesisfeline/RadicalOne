package;

import flixel.FlxG;

class RadicalPrefs
{
    static public function initPrefs()
    {
        if (FlxG.save.data.inputSystem == null)
            FlxG.save.data.inputSystem = 'RadicalOne';

        if (FlxG.save.data.offset == null)
            FlxG.save.data.offset = 0;

        if (FlxG.save.data.DFJK == null)
            FlxG.save.data.DFJK = false;

        if (FlxG.save.data.downsroll == null)
            FlxG.save.data.downsroll = false;

        if (FlxG.save.data.missNoise == null)
            FlxG.save.data.missNoise = true;

        if (FlxG.save.data.ludumRating == null)
            FlxG.save.data.ludumRating = false;

        if (FlxG.save.data.hitsounds == null)
            FlxG.save.data.hitsounds = false;
    }
}