package;

import flixel.system.FlxSound;
import flixel.FlxG;

class ResyncSubState extends MusicBeatSubstate
{
    var snd:FlxSound;
    
    public function new()
    {
        super();

        snd = new FlxSound().loadEmbedded('assets/music/breakfast' + TitleState.soundExt, true, true); // just so the flxg soundfrontend has something to play
		snd.volume = 0;

        resync();
    }

    override function create()
    {
        super.create();
        
    }

    override function destroy()
	{
		snd.destroy();

		super.destroy();
	}

    var count:Int = 0;

    private function resync():Void
    {
        snd.play();
        FlxG.sound.list.add(snd);
        Conductor.songPosition = PlayState.instance.songTime = 0;
        
        close();
    }
}