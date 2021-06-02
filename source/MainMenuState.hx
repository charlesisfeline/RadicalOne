package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import Discord.DiscordClient;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var yoJunk:FlxTypedGroup<Parents_Christmas>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		DiscordClient.changePresence("On Main Menu", null, 'sussy', 'racialdiversity');

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
		}

		persistentUpdate = persistentDraw = true;

		var ui_tex = FlxAtlasFrames.fromSparrow('assets/images/UI/campaign_menu_UI_assets.png', 'assets/images/UI/campaign_menu_UI_assets.xml');

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/UI/menuBG.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic('assets/images/UI/menuDesat.png');
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFF51ff54;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		yoJunk = new FlxTypedGroup<Parents_Christmas>();
		add(yoJunk);

		var tex = FlxAtlasFrames.fromSparrow('assets/images/UI/main_menu_assets.png', 'assets/images/UI/main_menu_assets.xml');

		var lanceysWindowsMenuHeLikeOpenedItForSomeReasonAndHeGottaSayItsLookinPrettyNice:Array<String> = ['story', 'freeplay', 'extras'];

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.visible = false;
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;

			var iLoveWow2:Parents_Christmas = new Parents_Christmas();
			iLoveWow2.loadGraphic('assets/images/UI/' + lanceysWindowsMenuHeLikeOpenedItForSomeReasonAndHeGottaSayItsLookinPrettyNice[i] + '.png');
			iLoveWow2.setGraphicSize(Std.int(iLoveWow2.width * 2));
			iLoveWow2.updateHitbox();
			iLoveWow2.ID = i;
			iLoveWow2.screenCenter();
			iLoveWow2.initX();
			iLoveWow2.x = iLoveWow2.realX + i * 1200;
			iLoveWow2.antialiasing = true;
			yoJunk.add(iLoveWow2);

		}

		leftArrow = new FlxSprite();
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.screenCenter();
		leftArrow.x -= FlxG.width / 2.5;
		add(leftArrow);

		rightArrow = new FlxSprite();
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.screenCenter();
		rightArrow.x += FlxG.width / 2;
		add(rightArrow);

		//FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://sites.google.com/view/radicalone/home", "&"]);
					#else
					FlxG.openURL('https://cdn.discordapp.com/attachments/811598851910664232/835792868722999317/Fefe_Winning_Smile.png');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					yoJunk.forEach(function(spr:FlxSprite)
					{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new ExtrasMenu());
								}
							});
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}


	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});

		yoJunk.forEach(function(ritzDeservedIt:Parents_Christmas)
		{
			FlxTween.cancelTweensOf(ritzDeservedIt);
			FlxTween.tween(ritzDeservedIt, {x: ritzDeservedIt.realX + (ritzDeservedIt.ID - curSelected) * 1200}, 0.4, {ease: FlxEase.backOut});
		});
	}
}

class Parents_Christmas extends FlxSprite
{
	public var realX:Float;

	public function new()
	{
		super();
	}

	public function initX()
	{
		this.realX = x;
	}
}
