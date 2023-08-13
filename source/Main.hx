package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = MyJunkState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	public static var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // CRINGE! Why would you hide it????
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public function new()
	{
		super();
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, 120, framerate, skipSplash, startFullscreen, 0x7F000000, true));

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