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
import Controls.KeyboardScheme;
import flixel.addons.display.FlxBackdrop;

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

	var scrollThingsBottom:Array<FlxSprite> = [];
	var scrollThingsTop:Array<FlxSprite> = [];

	var weez:Array<FlxSprite> = [];

	var swagger:Array<String> = [
		'The main story mode of the game.',
		'Play any song you like, without cutscenes or dialogue.',
		'Options, Bonus Weekends, Wardrobe, Etc.'
	];

	var swagText:FlxText;

	var gaming:FlxSprite;
	var racial:FlxSprite;

	override function create()
	{
		DiscordClient.changePresence("On Main Menu", null, 'sussy', 'racialdiversity');

		Controls.initControls();
		controls.setKeyboardScheme(KeyboardScheme.Solo, true);

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

		var wow2:FlxSprite = new FlxSprite(0, 75).makeGraphic(20, 570, FlxColor.BLACK);
		wow2.alpha = 0.5;
		add(wow2);

		for (i in 0...32) {
			var thing:FlxSprite = new FlxSprite(40 * i, 75).makeGraphic(40, 570, FlxColor.BLACK);
			thing.alpha = 0.5;
			thing.ID = i;
			thing.x += 20;
			add(thing);
			weez.push(thing);
		}

		var deez:FlxSprite = new FlxSprite().loadGraphic('assets/images/UI/thiung.png');
		deez.screenCenter();
		deez.alpha = 0.55;
		add(deez);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		yoJunk = new FlxTypedGroup<Parents_Christmas>();
		add(yoJunk);

		var them = FlxAtlasFrames.fromSparrow('assets/images/UI/them.png', 'assets/images/UI/them.xml');

		gaming = new FlxSprite(-67, 125);
		gaming.frames = them;
		gaming.animation.addByPrefix('idle', 'gmae', 24, false);
		gaming.animation.play('idle');
		add(gaming);

		racial = new FlxSprite(840, 180);
		racial.frames = them;
		racial.animation.addByPrefix('idle', 'raci', 24, false);
		racial.animation.play('idle');
		add(racial);

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
			iLoveWow2.initJunkrus();
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

		add(new FlxSprite().makeGraphic(1280, 75, FlxColor.BLACK));
		add(new FlxSprite(0, FlxG.height - 75).makeGraphic(1280, 75, FlxColor.BLACK));

		for (i in 0...12) {
			var scrol:FlxSprite = new FlxSprite(i * 225, FlxG.height - 75).loadGraphic('assets/images/UI/racialCool.png', true, 223, 72);
			scrol.animation.add('idle', [for (i in 0...20) i], 10, true);
			scrol.animation.play('idle');
			add(scrol);
			scrollThingsBottom.push(scrol);

			var scrol2:FlxSprite = new FlxSprite((i * 225)).loadGraphic('assets/images/UI/racialCool.png', true, 223, 72);
			scrol2.animation.add('idle', [for (i in 0...20) i], 10, true);
			scrol2.animation.play('idle');
			add(scrol2);
			scrollThingsTop.push(scrol2);
		}

		//FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		swagText = new FlxText(0, 0, 0, swagger[curSelected], 24);
		swagText.screenCenter();
		swagText.y += 175;
		swagText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(swagText);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	// https://cdn.discordapp.com/attachments/806355831331094539/851487143624966194/meme.png

	override function beatHit()
	{
		racial.animation.play('idle', true);
		gaming.animation.play('idle', true);

		for (deez in weez) {
			if (deez.ID % 2 == 0) {
				deez.scale.set(1, FlxG.random.float(0.5, 0.95));
				FlxTween.tween(deez, {"scale.y": 1}, Conductor.crochet * 0.0005, {ease: SwagEase.swagEase});
			}
		}
		super.beatHit();
	}

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

		for (spr in scrollThingsBottom) {
			spr.x -= 2;
			if (spr.x < 223 * -2) spr.x = 223 * (scrollThingsBottom.length - 2);
		}

		for (spr in scrollThingsTop) {
			spr.x += 2;
			if (spr.x > 223 * (scrollThingsTop.length - 2)) spr.x = 223 * -1;
		}

		Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
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

		var posThing:Array<Int> = [0, 1, 2];

		yoJunk.forEach(function(ritzDeservedIt:Parents_Christmas)
		{
			// FlxG.log.add(ritzDeservedIt.ID + 'deez' + (ritzDeservedIt.ID - curSelected));
			FlxTween.cancelTweensOf(ritzDeservedIt);
			FlxTween.tween(ritzDeservedIt, {x: ritzDeservedIt.realX + (ritzDeservedIt.ID - curSelected) * 1200, y: (ritzDeservedIt.ID != curSelected) ? -175 : ritzDeservedIt.realY}, 0.4, {ease: FlxEase.quintOut});
		});

		swagText.text = swagger[curSelected];
		swagText.screenCenter();
		swagText.y += 175;
	}
}

class Parents_Christmas extends FlxSprite
{
	public var realX:Float;
	public var realY:Float;

	public function new()
	{
		super();
	}

	public function initJunkrus():Void
	{
		this.realX = x;
		this.realY = y;
	}
}
