package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MyJunkState, 1, 120, 120, true, false, 0x7F000000, true));

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end
	}

	var fpsCounter:FPS;

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}
}