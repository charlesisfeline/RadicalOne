package;

import Section.SwagSection;
import Song.SwagSong;
import NamebeMappings.NameMap;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import Controls.KeyboardScheme;
import Discord.DiscordClient;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxStarField;
import flixel.addons.effects.FlxClothSprite; // just me messing around with flixel-addons
import flixel.effects.FlxFlicker;
import openfl.Lib;
// import swf.SWF;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var MAPPINGS:NameMap;
	public static var isStoryMode:Bool = false;
	public static var isWeekend:Bool = false;
	public static var storyWeek:Int = 0;
	public static var weekend:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekendPlaylist:Array<String> = [];
	public static var weekEndFreeplay:Bool = false;
	public static var randomLevel:Bool = false;
	public static var demoMode:Bool = false;

	public static var gamingsOwnCoords:Array<Float>;
	public static var hasFocusedOnGaming:Bool = false;
	public static var hasFocusedOnDudes:Bool = false;

	public static var sheShed:String;

	var halloweenLevel:Bool = false;
	var areTheirDogs:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	private var gspot:Character;
	private var gaming:Character;
	private var bab:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:SwagSection;
	private var sectionNum:Int = 0;

	private var invulnCount:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var otherStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

    var grpLimoNadders:FlxTypedGroup<BackgroundNadders>;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;
	var pogBabby:FlxSprite;
	var ogBG:FlxSprite;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var theBoolYouMade:Bool = false;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var gamingBop:FlxSprite;
	var grpGuardDogs:FlxTypedGroup<GuardDogs>;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var remSwag:FlxSprite;

	public static var stagePath:String = 'assets/images/stages/'; 
	
	var vans:FlxSprite;
	var sun:FlxSprite;
	var stars:FlxBackdrop;

	var paly2:String;
	var paly3:String;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	var wolves:FlxTypedGroup<FlxSprite>;

	var sway:Array<FlxSprite> = [];

	var songsWithDialogue:Array<String> = [
		'senpai', 'roses', 'thorns', 
		'north', 'radical-vs-masked-babbys', 'monkey-sprite', 
		'namebe', 'bouncy-drop', 'destructed', 
		'the-backyardagains', 'funny'
	];

	public static var campaignScore:Int = 0;
	public static var weekendScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	static public var whatInputSystem:String;

	var charColors:Array<FlxColor> = [
		0xFFf71436, // radical
		0xFF24ff45, // gaming speakers
		0xFF88a4cf, // job interviewer
		0xFFffbd2e, // machine
		0xFF19fca2, // babbys
		0xFF9e3923, // monkey sprite
		0xFF3cff00, // namebe
		0xFFff00e1, // gandhi
		0xFF24ff45, // gaming namebe
		0xFF24ff45, // gaming standing
		0xFF000000, // invisible
		0xFF000000, // null
		0xFF41855e, // lightly salted beans
		0xFFffe4a8, // wow
		0xFFffe0cf, // wow 2
		0xFFb55de8, // mr flynet
		0xFF001eff, // wow senpai
		0xFFff0000, // wow senpai but angry
		0xFFd9f4ff, // skank himself
		0xFFffa8f9, // goomba
		0xFFeb4d09, // flandre cool awesome
		0xFFdfff4f, // nadalyn
		0xFF472fbd, // failure
		0xFFff4548, // red ball
		0xFF7c57bd, // dadamono
		0xFF644e66, // 3.4
		0xFFffffff, // stickman
		0xFFf5e187, // skank and pronoun
		0xFF4884ff, // junkers
		0xFF96eb3b, // pic-nick
		0xFF5bf56a, // pc
		0xFFd78df2, // thanos dad
		0xFFeff556, // community night funkin
		0xFF4a412a, // stupid ugly
		0xFFff4548, // red ball dream
		0xFF472fbd, // failure dream
		0xFFdfff4f, // dawgee
		0xFFffffff // ghost
	];

	/*var charColors:Array<FlxColor> = [
		0xFFf71436, // radical
		0xFF24ff45, // gaming speakers
		0xFF88a4cf, // job interviewer
		0xFFffbd2e, // machine
		0xFF19fca2, // babbys
		0xFF9e3923, // monkey sprite
		0xFF3cff00, // namebe
		0xFFff00e1, // gandhi
		0xFFffa8f0, // bonbon
		0xFF24ff45, // gaming standing
		0xFF7565f0, // four
		0xFFffff00, // x
		0xFFbf0033, // christmas monkey sprite
		0xFF000000, // invisible
		0xFF000000, // null
		0xFF41855e, // lightly salted beans
		0xFFffe4a8, // wow
		0xFFffe0cf, // wow 2
		0xFFb55de8, // mr flynet
		0xFF001eff, // wow senpai
		0xFFff0000, // wow senpai but angry
		0xFFfba6ff, // pronun
		0xFFf2f277, // charlie
		0xFFd9f4ff, // skank himself
		0xFFffa8f9, // goomba
		0xFFeb4d09, // flandre cool awesome
		0xFFdfff4f, // nadalyn
		0xFF472fbd, // failure
		0xFFff4548, // red ball
		0xFF7c57bd, // dadamono
		0xFF644e66, // 3.4
		0xFFffffff, // stickman
		0xFFf5e187, // skank and pronoun
		0xFF4884ff, // junkers
		0xFF96eb3b, // pic-nick
		0xFF5bf56a, // pc
		0xFFd78df2, // thanos dad
		0xFFeff556 // community night funkin
	];*/

	override public function create()
	{
		initVars();
		initDialog();

		switch(curStage)
		{
			case 'blank':
				trace(dialogue);
			case 'susmeal':
				defaultCamZoom = 2;

				var pp:FlxStarField3D = new FlxStarField3D(0, 0, FlxG.width, FlxG.height);
				pp.screenCenter();
				pp.scrollFactor.set();
				add(pp);
			case 'interview':
				defaultCamZoom = 0.8;

				add(new FlxSprite(-445, -104).loadGraphic(stagePath + 'office/InterviewRoom.png'));
			case 'picnic':
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(stagePath + 'picnic/sky.png');
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(stagePath + 'picnic/city.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(stagePath + 'picnic/tree.png');
				add(streetBehind);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(stagePath + 'picnic/frontground.png');
				add(street);
			case 'junkers':
				var junkers:FlxSprite = new FlxSprite().loadGraphic(stagePath + 'junkers/Capture.PNG');
				junkers.setGraphicSize(FlxG.width);
				junkers.updateHitbox();
				junkers.scrollFactor.set();
				add(junkers);
			case 'spooky':
				curStage = "spooky";
				halloweenLevel = true;

				var hallowTex = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/normal.png', stagePath + 'babbys/normal.xml');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
				
				pogBabby = new FlxSprite(-820, 275);
				pogBabby.frames = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/babby_pog.png', stagePath + 'babbys/babby_pog.xml');
				pogBabby.animation.addByPrefix('pog', 'pog', 24, false);
				pogBabby.antialiasing = true;

				trace('WEEK 2 BG');

				isHalloween = true;
			case 'spookyscary':
				halloweenLevel = true;

				var hallowTex = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/scary.png', stagePath + 'babbys/scary.xml');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'junkiung');
				halloweenBG.animation.addByPrefix('lightning', 'junkingVEETOO', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				ogBG = new FlxSprite(-200, -100);
				ogBG.frames = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/normal.png', stagePath + 'babbys/normal.xml');
				ogBG.animation.addByPrefix('idle', 'halloweem bg0');
				ogBG.animation.play('idle');
				ogBG.antialiasing = true;

				pogBabby = new FlxSprite(-140, 415);
				pogBabby.frames = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/babby_pog.png', stagePath + 'babbys/babby_pog.xml');
				pogBabby.animation.addByPrefix('pog', 'pog', 12, false);
				add(pogBabby);

				add(new FlxSprite(1145, 384).loadGraphic(stagePath + 'babbys/table.png'));

				trace('WEEK 2 BG BUT SCARY');

				isHalloween = true;
			case 'flynets':
				halloweenLevel = true;
				areTheirDogs = false;
	
				var hallowTex = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/non_babby_junk/flynets.png', stagePath + 'babbys/normal.xml');
	
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				if (SONG.song != 'the-backyardagains')
				{
					var dogPositions:Array<Dynamic> = [
						[160, 445],
						[670, 440],
						[1060, 510]
					];
					grpGuardDogs = new FlxTypedGroup<GuardDogs>();
					add(grpGuardDogs);

					for (i in 0...3)
					{
						var daPos:Array<Float> = dogPositions[i];
						var dog:GuardDogs = new GuardDogs(daPos[0], daPos[1] - 300);
						grpGuardDogs.add(dog);
					}
					areTheirDogs = true;
				}
	
				isHalloween = true;
			case 'scribble':
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(stagePath + 'scribble/sky.png');
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(stagePath + 'scribble/friendlyNieghborhood.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(stagePath + 'scribble/room.png');
				add(streetBehind);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(stagePath + 'scribble/floor.png');
				add(street);
			case 'water':
				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);

				var hallowTex = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/non_babby_junk/water.png', stagePath + 'babbys/normal.xml');
	
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.01;
				wiggleShit.waveFrequency = 7;
				wiggleShit.waveSpeed = 1;

				halloweenBG.shader = wiggleShit.shader;

				var waveSprite = new FlxEffectSprite(halloweenBG, [waveEffectBG]);

				//waveSprite.scale.set(6, 6);
				waveSprite.setPosition(-200, 100);

				// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
				// waveSprite.updateHitbox();
				// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
				// waveSpriteFG.updateHitbox();

				//add(waveSprite);
			case 'junk':

				var hallowTex = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/non_babby_junk/redball_thing_i_think.png', stagePath + 'babbys/normal.xml');
	
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
			case 'dawgee':

				var hallowTex = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/non_babby_junk/dawgee_house.png', stagePath + 'babbys/normal.xml');
	
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
			case 'dreaming':

				var hallowTex = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/non_babby_junk/dream_bg.png', stagePath + 'babbys/normal.xml');
	
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
			case '3.4':
				var hallowTex = FlxAtlasFrames.fromSparrow(stagePath + 'babbys/non_babby_junk/3.4bg.png', stagePath + 'babbys/normal.xml');
	
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
			case 'nadalyn':				
				var naddersBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(stagePath + 'nadalyn/nadders.png');
				naddersBG.scrollFactor.set(0.1, 0.1);
				add(naddersBG);
							
				var bgNadders:FlxSprite = new FlxSprite(-200, 480);
				bgNadders.frames = FlxAtlasFrames.fromSparrow(stagePath + 'nadalyn/nadalyn_dancers.png', stagePath + 'nadalyn/nadalyn_dancers.xml');
				bgNadders.scrollFactor.set(0.4, 0.4);
				add(bgNadders);

				grpLimoNadders = new FlxTypedGroup<BackgroundNadders>();
				add(grpLimoNadders);

				for (i in 0...5)
				{
					var dancerNad:BackgroundNadders = new BackgroundNadders((370 * i) + 130, bgNadders.y - 400);
					dancerNad.scrollFactor.set(0.4, 0.4);
					grpLimoNadders.add(dancerNad);
				}
			case 'namebe':
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(stagePath + 'namebe/' + sheShed + '/sky.png');
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
				
				if (SONG.song == 'Namebe' || randomLevel)
					sun = new FlxSprite(720, -280).loadGraphic(stagePath + 'namebe/SUN.png');
				else if (sheShed == 'bouncy-drop')
					sun = new FlxSprite(720, -230).loadGraphic(stagePath + 'namebe/SUN2.png');
				
				if (SONG.song != 'Destructed')
				{	
					sun.setGraphicSize(Std.int(sun.width * 0.2));
					sun.scrollFactor.set(0.1, 0.1);
					add(sun);

					var cloudJunk:CloudGenerator = new CloudGenerator(-400, 0, FlxG.width + 400, FlxG.height, stagePath + 'namebe/cloud-$sheShed.png', 0.1, 30);
					add(cloudJunk);
				}
				else
				{
					stars = new FlxBackdrop(stagePath + 'namebe/STARS.png', 1, 1, true, true);
					// stars.setGraphicSize(0, FlxG.height);
					stars.scale.set(FlxG.width / stars.width, FlxG.height / stars.height);
					stars.scrollFactor.set(0.1);
					add(stars);
				}
				
				var city:FlxSprite = new FlxSprite(-10).loadGraphic(stagePath + 'namebe/' + sheShed + '/city.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);
				
				if (sheShed == 'bouncy-drop' && FlxG.random.bool(15))
					city.loadGraphic(stagePath + 'namebe/' + sheShed + '/BigOlBunny.png');
				
				phillyTrain = new FlxSprite(2000, 360).loadGraphic(stagePath + 'namebe/' + sheShed + '/train.png');
				add(phillyTrain);
				
				trainSound = new FlxSound().loadEmbedded('assets/sounds/train_passes' + TitleState.soundExt);
				FlxG.sound.list.add(trainSound);
				
				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
				
				var street:FlxSprite = new FlxSprite(-40, 50).loadGraphic(stagePath + 'namebe/' + sheShed + '/street.png');
				add(street);
				if (sheShed == 'destructed')
				{	
					wolves = new FlxTypedGroup<FlxSprite>();
					add(wolves);
					if (FlxG.random.bool(22))
					{
						for (i in 0...3)
						{
							// if ()
							var wolfyWannaCry:FlxSprite = new FlxSprite(350 + (481 * (i - 1) - (45 * (i - 1))), 100 + (124 * (i - 1)));
							wolfyWannaCry.frames = FlxAtlasFrames.fromSparrow(stagePath + 'namebe/$sheShed/flynets.png', stagePath + 'namebe/$sheShed/flynets.xml');
							wolfyWannaCry.animation.addByIndices('danceLEFT', 'dog dance left right', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], '', 24, false);
							wolfyWannaCry.animation.addByIndices('danceRIGHT', 'dog dance left right', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], '', 24, false);
							wolfyWannaCry.animation.play('danceRIGHT');
							wolfyWannaCry.setGraphicSize(Std.int(wolfyWannaCry.width / 1.5));
							wolfyWannaCry.updateHitbox();
							wolves.add(wolfyWannaCry);
						}
					}

					vans = new FlxSprite(-1386, 196);
					vans.frames = FlxAtlasFrames.fromSparrow(stagePath + 'namebe/van.png', stagePath + 'namebe/van.xml');
					vans.animation.addByPrefix('close', 'van vroom', 24, false);
					vans.animation.addByIndices('closed', 'van vroom', [65], '', 24, false);
					vans.animation.play('close');
					vans.setGraphicSize(Std.int(vans.width * 1.4));
					vans.antialiasing = true;
					vans.updateHitbox();
					add(vans);
					if (isStoryMode)
						vans.visible = false;
					else
						vans.animation.play('closed');
				}
			case 'philly':
				var city:FlxSprite = new FlxSprite(-120, -50).loadGraphic(stagePath + 'beans/' + sheShed + '/bg.png');
				city.scrollFactor.set(0.1, 0.1);
				add(city);
				
				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);
				
				for (i in 0...3)
				{
					var light:FlxSprite = new FlxSprite(city.x);
					if (sheShed == 'energy-lights')
						light.loadGraphic(stagePath + 'beans/energy-lights/rocks' + i + '.png');
					else
						light.loadGraphic(stagePath + 'beans/' + sheShed + '/rocks.png');
					light.scrollFactor.set(0.3, 0.3);
					light.visible = true;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					phillyCityLights.add(light);
				}
				
				phillyTrain = new FlxSprite(2000, 360).loadGraphic(stagePath + 'beans/' + sheShed + '/weird.png');
				add(phillyTrain);
				
				trainSound = new FlxSound().loadEmbedded('assets/sounds/weird' + TitleState.soundExt);
				FlxG.sound.list.add(trainSound);
				
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(stagePath + 'beans/' + sheShed + '/ground.png');
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
			case 'pit':

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(stagePath + 'pit/bg.png');
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(stagePath + 'pit/details1.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(stagePath + 'pit/details2.png');
				add(streetBehind);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(stagePath + 'pit/ground.png');
				add(street);
			case 'freebeat':
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(stagePath + 'freebeat/bg.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(stagePath + 'freebeat/thing.png');
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			case 'limo':
				defaultCamZoom = 0.90;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(stagePath + 'bonbon/limoSunset.png');
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = FlxAtlasFrames.fromSparrow(stagePath + 'bonbon/bgLimo.png', stagePath + 'bonbon/bgLimo.xml');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					if (sheShed != 'without-you')
						grpLimoDancers.add(dancer);
				}

				//var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(stagePath + 'bonbon/limoOverlay.png');
				//overlayShit.alpha = 0.5;
				//add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = FlxAtlasFrames.fromSparrow(stagePath + 'bonbon/limoDrive.png', stagePath + 'bonbon/limoDrive.xml');

				var cloud:FlxSprite = new FlxSprite(-325, 515).loadGraphic(stagePath + 'bonbon/cloud.png');
				cloud.scrollFactor.set(0.9, 0.9);
				if (sheShed == 'without-you')
					cloud.setPosition(70, 485);
				add(cloud);

				gamingBop = new FlxSprite(-260, 190);
				gamingBop.frames = FlxAtlasFrames.fromSparrow(stagePath + 'bonbon/gamingRightBounce.png', stagePath + 'bonbon/gamingRightBounce.xml');
				gamingBop.animation.addByPrefix('bop', 'gamingRight', 24, false);
				gamingBop.antialiasing = true;
				gamingBop.scrollFactor.set(0.9, 0.9);
				gamingBop.setGraphicSize(Std.int(gamingBop.width * 1));
				gamingBop.updateHitbox();
				if (sheShed != 'without-you')
					add(gamingBop);

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(stagePath + 'bonbon/fastCarLol.png');
				// add(limo);

				//var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(stagePath + 'bonbon/limoOverlay.png');
				//overlayShit.alpha = 0.5;
				//add(overlayShit);
			case 'mall':

				defaultCamZoom = 0.80;

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(stagePath + 'christmas/bgWalls.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = FlxAtlasFrames.fromSparrow(stagePath + 'christmas/upperBop.png', stagePath + 'christmas/upperBop.xml');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(stagePath + 'christmas/bgEscalator.png');
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(stagePath + 'christmas/christmasTree.png');
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = FlxAtlasFrames.fromSparrow(stagePath + 'christmas/bottomBop.png', stagePath + 'christmas/bottomBop.xml');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(stagePath + 'christmas/fgSnow.png');
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FlxSprite(-820, 275);
				santa.frames = FlxAtlasFrames.fromSparrow(stagePath + 'christmas/santa.png', stagePath + 'christmas/santa.xml');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			case 'mallEvil':
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(stagePath + 'christmas/evilBG.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(stagePath + 'christmas/evilTree.png');
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(stagePath + 'christmas/evilSnow.png');
				evilSnow.antialiasing = true;
				add(evilSnow);
			case 'home':
				var bg:FlxSprite = new FlxSprite(-900, -275).loadGraphic(stagePath + 'office/livingroom.png');
				// bg.setGraphicSize(Std.int(bg.width * 2.5));
				// bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
			case 'rumble':
				var dunkign:FlxSprite = new FlxSprite(-900, -275).loadGraphic(stagePath + 'office/bigbadspace.png');
				dunkign.antialiasing = true;
				dunkign.scrollFactor.set(0.9, 0.9);
				dunkign.active = false;
				add(dunkign);
			case 'bonbon-prep':
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/color_my_bonbon/loadingScreen.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				FlxG.switchState(new BonBonState());
			case 'school':

				// defaultCamZoom = 0.9;

				var bgSky = new FlxSprite().loadGraphic(stagePath + 'weeb/weebSky.png');
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(stagePath + 'weeb/weebSchool.png');
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(stagePath + 'weeb/weebStreet.png');
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(stagePath + 'weeb/weebTreesBack.png');
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = FlxAtlasFrames.fromSpriteSheetPacker(stagePath + 'weeb/weebTrees.png', stagePath + 'weeb/weebTrees.txt');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = FlxAtlasFrames.fromSparrow(stagePath + 'weeb/petals.png', stagePath + 'weeb/petals.xml');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (sheShed == 'roses')
				{
					bgGirls.getScared();
				}

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			case 'schoolEvil':

				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
				var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

				var posX = 400;
				var posY = 200;

				var bg:FlxSprite = new FlxSprite(posX, posY);
				bg.frames = FlxAtlasFrames.fromSparrow(stagePath + 'weeb/animatedEvilSchool.png', stagePath + 'weeb/animatedEvilSchool.xml');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);

				for (i in 0...FlxG.random.int(5, 15))
				{
					var swayBF:FlxSprite = new FlxSprite(FlxG.random.int(0, FlxG.width), FlxG.random.int(0, FlxG.height)).loadGraphic('${stagePath}weeb/sway.png', true, 84, 60);
					swayBF.animation.add('true', [12, 13, 0, 1, 2, 3, 4], 24, false);
					swayBF.animation.add('false', [5, 6, 7, 8, 9, 10, 11], 24, false);
					swayBF.animation.play('false');
					swayBF.scale.set(6, 6);
					swayBF.updateHitbox();
					sway.push(swayBF);
					add(swayBF);
				}

				/* 
					var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(stagePath + 'weeb/evilSchoolBG.png');
					bg.scale.set(6, 6);
					// bg.setGraphicSize(Std.int(bg.width * 6));
					// bg.updateHitbox();
					add(bg);

					var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(stagePath + 'weeb/evilSchoolFG.png');
					fg.scale.set(6, 6);
					// fg.setGraphicSize(Std.int(fg.width * 6));
					// fg.updateHitbox();
					add(fg);

					wiggleShit.effectType = WiggleEffectType.DREAMY;
					wiggleShit.waveAmplitude = 0.01;
					wiggleShit.waveFrequency = 60;
					wiggleShit.waveSpeed = 0.8;
				*/

				// bg.shader = wiggleShit.shader;
				// fg.shader = wiggleShit.shader;

				/* 
					var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
					var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

					// Using scale since setGraphicSize() doesnt work???
					waveSprite.scale.set(6, 6);
					waveSpriteFG.scale.set(6, 6);
					waveSprite.setPosition(posX, posY);
					waveSpriteFG.setPosition(posX, posY);

					waveSprite.scrollFactor.set(0.7, 0.8);
					waveSpriteFG.scrollFactor.set(0.9, 0.8);

					// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
					// waveSprite.updateHitbox();
					// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
					// waveSpriteFG.updateHitbox();

					add(waveSprite);
					add(waveSpriteFG);
				/*/
			case 'nunjunk':
				defaultCamZoom = 0.9;

				var floor:FlxSprite = new FlxSprite(-325, -685).loadGraphic(stagePath + 'nunjunk/church1/floor.png');
				add(floor);

				var bg:FlxSprite = new FlxSprite(-325, -685).loadGraphic(stagePath + 'nunjunk/church1/bg.png');
				add(bg);

				var pillars:FlxSprite = new FlxSprite(-325, -685).loadGraphic(stagePath + 'nunjunk/church1/pillars.png');
				pillars.scrollFactor.set(0.99, 0.99);
				add(pillars);
			case 'bustom':

				var bg:FlxSprite = new FlxSprite(-375, -153).loadGraphic(stagePath + 'bustom/bg.png');
				add(bg);

				/*if (MAPPINGS == null)
					MAPPINGS = NamebeMappings.loadMapsFromJson('i-didnt-ask');*/
			case 'iAmJUNKING':
				defaultCamZoom = 0.54;

				var thaBiscoot:FlxSprite = new FlxSprite(-1293, -688).loadGraphic(stagePath + 'scarie/bg back.png');
				add(thaBiscoot);

				var scrollyCoolOne:FlxSprite = new FlxSprite(-2080, -312).loadGraphic(stagePath + 'scarie/bg scrolly things back.png');
				scrollyCoolOne.scrollFactor.set(1.5);
				add(scrollyCoolOne);

				var scrollyCoolTwo:FlxSprite = new FlxSprite(-1763, -256).loadGraphic(stagePath + 'scarie/bg scrolly things front.png');
				scrollyCoolTwo.scrollFactor.set(1.3);
				add(scrollyCoolTwo);

				var buttCheek2:FlxSprite = new FlxSprite(-553, -1708).loadGraphic(stagePath + 'scarie/bg pylons.png');
				buttCheek2.scrollFactor.x = 1.2;
				buttCheek2.setGraphicSize(Std.int(buttCheek2.width * 0.75));
				add(buttCheek2);

				var buttCheek3:FlxSprite = new FlxSprite(-553, -1708).loadGraphic(stagePath + 'scarie/bg pylons.png');
				buttCheek3.scrollFactor.x = 1.2;
				buttCheek3.setGraphicSize(Std.int(buttCheek2.width * 0.75));
				buttCheek3.color = FlxColor.BLACK;
				buttCheek3.alpha = 0.5;
				add(buttCheek3);

				remSwag = new FlxSprite(-3618, -1183);
				remSwag.frames = FlxAtlasFrames.fromSparrow(stagePath + 'scarie/remilia_swag_nice.png', stagePath + 'scarie/remilia_swag_nice.xml');
				remSwag.animation.addByPrefix('idle', 'up and down woow', 24, true);
				remSwag.animation.play('idle');
				remSwag.setGraphicSize(Std.int(remSwag.width / 1.15));
				remSwag.antialiasing = true;
				remSwag.y -= 60;
				add(remSwag);

				var buttCheek:FlxSprite = new FlxSprite(-753, -1708).loadGraphic(stagePath + 'scarie/bg pylons.png');
				buttCheek.scrollFactor.x = 1.1;
				add(buttCheek);

				var poopInTheSand:FlxSprite = new FlxSprite(-2256, 627).loadGraphic(stagePath + 'scarie/bg ground.png');
				add(poopInTheSand);
			default:
				defaultCamZoom = 1;

				var iAmActuallyDunkingMyJunk:FlxSprite = new FlxSprite(-270, 50).loadGraphic(stagePath + 'office/STAGELAYER3.png');
				iAmActuallyDunkingMyJunk.setGraphicSize(1828);
				iAmActuallyDunkingMyJunk.updateHitbox();
				iAmActuallyDunkingMyJunk.antialiasing = true;
				iAmActuallyDunkingMyJunk.scrollFactor.set(0.8, 0.8);
				add(iAmActuallyDunkingMyJunk);

				var stageFront:FlxSprite = new FlxSprite(-270, 50).loadGraphic(stagePath + 'office/STAGELAYER2.png');
				stageFront.setGraphicSize(1828);
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				add(stageFront);

				var bg:FlxSprite = new FlxSprite(-270, 50).loadGraphic(stagePath + 'office/STAGELAYER1.png');
				bg.setGraphicSize(1828);
				bg.updateHitbox();
				bg.antialiasing = true;
				add(bg);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(stagePath + 'office/stagecurtains.png');
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
		}

		var gfVersion:String = 'gaming-speakers';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'invisible';
			case 'school' | 'schoolEvil':
				gfVersion = 'jack';
			case 'bustom':
				if (SONG.song == 'I-Didnt-Ask')
					gfVersion = 'namebe-speakers';
				else
					gfVersion = 'gaming-gunpoint';

			case 'namebe':
				gfVersion = 'gaming-namebe';
		}

		if (randomLevel)
		{
			gfVersion = Character.charArray[FlxG.random.int(0, Character.charArray.length - 1, [Character.charArray.indexOf('wow2')])]; // wow2 doesnt appear in random levels because lancey doesnt like it
			SONG.player1 = Character.charArray[FlxG.random.int(0, Character.charArray.length - 1, [Character.charArray.indexOf('wow2')])];
			SONG.player2 = Character.charArray[FlxG.random.int(0, Character.charArray.length - 1, [Character.charArray.indexOf('wow2')])];
			SONG.player3 = Character.charArray[FlxG.random.int(0, Character.charArray.length - 1, [Character.charArray.indexOf('wow2')])];
			SONG.player4 = Character.charArray[FlxG.random.int(0, Character.charArray.length - 1, [Character.charArray.indexOf('wow2')])];
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		gamingsOwnCoords = [gf.getMidpoint().x - 140, gf.getMidpoint().y - 150];

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		if (sheShed == 'chuckie') // ugly stupid
		{
			gf.visible = false;
			camZooming = true;
		}

		if (curStage == 'spookyscary' && isStoryMode)
		{
			add(ogBG);
			pogBabby.visible = false;
		}
			

        gspot = new Character(300, 100, SONG.player3);
		dad = new Character(100, 100, SONG.player2);
		gaming = new Character(1300, 9400, SONG.player4);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gaming-speakers':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "babbys":
				dad.y += 200;
				dad.x += 100;
			case 'skank-n-pronoun' | 'dawgee' | 'i-hate-you-lancey':
				dad.y += 200;
			case "skank":
				dad.y += 200;
				if (isWeekend)
					tweenCamIn();
			case "austin":
				dad.y += 200;
			case "monkey-sprite":
				dad.y += 60;
			case 'christmas-monkey':
				dad.y += 130;
			case 'interviewer':
				camPos.x += 400;
			case 'namebe':
				camPos.x += 600;
				dad.x -= 65;
				dad.y += 250;
			case 'parents-christmas':
				dad.x -= 500;
			case 'salted':
			    camPos.x += 600;
                dad.y += 300;
			case 'wow':
			    camPos.x += 600;
                dad.y += 300;
			case 'goomba' | 'pic-nick' | 'pc' | 'stick' | 'joe-bidens-dog':
				camPos.x += 600;
                dad.y += 300;
			case 'wow2':
			    camPos.x += 600;
                dad.y += 300;
            case 'nadalyn':
                camPos.x += 600;       
                dad.y += 300;
            case 'machine':
                dad.y += 300;
            case 'gaming':
                dad.y += 300;
            case 'bonbon':
                dad.y += 100;
			case 'senpai' | 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'four':
                dad.y += 100;
                dad.x -= 537;
            case 'x':
                dad.y += 230;
                dad.x -= 537;
			case 'pronun':
				dad.y += 320;
				dad.x -= 75;
			case 'charlie':
				dad.y += 275;
			case 'flandre-cool-awesome':
				dad.x -= 650;
				dad.y -= 80;
		}
		
		if (curStage == 'limo')
            dad.y -= 300;

        switch (SONG.player3)
		{
			case 'gaming-speakers':
				gspot.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "babbys":
				gspot.y += 200;
			case "monkey-sprite":
				gspot.y += 100;
			case 'christmas-monkey':
				gspot.y += 130;
			case 'interviewer':
				camPos.x += 400;
			case 'namebe':
				gspot.y += 300;
			case 'parents-christmas':
				gspot.x -= 500;
			case 'salted':
                gspot.y += 300;
			case 'wow':
                gspot.y += 300;
			case 'wow2':
                gspot.y += 300;
        	case 'nadalyn':
                gspot.y += 300;
            case 'machine':
                gspot.y += 300;
            case 'x':
                gspot.y += 230;
                gspot.x -= 237;
		}
		
		switch (SONG.player4)
		{
			case "babbys":
				gaming.y = 230;
				gaming.x = 1230;
			case "monkey-sprite":
				gaming.y = 230;
				gaming.x = 1230;
			case 'christmas-monkey':
				gaming.y = 230;
				gaming.x = 1230;
			case 'interviewer':
				gaming.y = 230;
				gaming.x = 1230;
			case 'namebe':
				gaming.y = 230;
				gaming.x = 1230;
			case 'parents-christmas':
				gaming.y = 230;
				gaming.x = 1230;
			case 'salted':
			    gaming.y = 230;
				gaming.x = 1230;
			case 'wow':
			    gaming.y = 230;
				gaming.x = 1230;
			case 'wow2':
			    gaming.y = 230;
				gaming.x = 1230;
            case 'nadalyn':
                gaming.y = 230;
				gaming.x = 1230;
            case 'machine':
                gaming.y = 230;
				gaming.x = 1230;
		}

		if (FlxG.save.data.outfit == 'Old Radical' || FlxG.save.data.outfit == 'Sussy Radical')
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		else
			boyfriend = new Boyfriend(770, 345, SONG.player1);

		if (FlxG.save.data.outfit == 'Sussy Radical' && !SONG.player1.startsWith('red-ball') && SONG.player1 != 'community-night-funkin') // SO MANY CONDITIONALS HELP
			boyfriend.y += 25;

		switch (SONG.player1)
		{
			case 'red-ball' | 'red-ball-dream':
				gf.visible = false;

				if (FlxG.save.data.outfit == 'Old Radical' || FlxG.save.data.outfit == 'Sussy Radical') // poop
					boyfriend.y -= 105;

			case 'community-night-funkin':
				if (FlxG.save.data.outfit != 'Old Radical' && FlxG.save.data.outfit != 'Sussy Radical') // poop v2
					boyfriend.y += 105;
		}

		//boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'nunjunk':
				gf.x -= 147;
				gf.y -= 50;
				boyfriend.y -= 50;
			case 'bustom':
				gf.x -= 155;
				boyfriend.x += 125;
			case 'susmeal':
				gf.visible = false;
			case 'namebe':
				gf.x += 56;
				gf.y += 92;
		}

		add(gf);
		add(gspot);
		add(dad);
		add(gaming);
		add(boyfriend);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		var darf:DialogueBubble = new DialogueBubble(false, dialogue);
		// darf.x += 70;
		darf.y = FlxG.height * 0.5;
		darf.scrollFactor.set();
		darf.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		otherStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic('assets/images/UI/healthBar.png');
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		if (sheShed != 'job-interview')
			add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(charColors[Character.charArray.indexOf(SONG.player2)], charColors[Character.charArray.indexOf(SONG.player1)]);
		// healthBar
		if (sheShed != 'job-interview')
			add(healthBar);

		var downscrollJunky:Int = 1;
		if (FlxG.save.data.downscroll) // STOLEN STRAIGHT FROM MASHUP LETS GOOOO :sunglasses:
			downscrollJunky = -1;

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 45 * downscrollJunky, 0, "", 20);
		scoreTxt.setFormat("assets/fonts/vcr.ttf", 20, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();

		var penis:FlxText = new FlxText(15, healthBarBG.y + 30 * downscrollJunky, 0, FlxG.save.data.inputSystem + ' Input', 20);
		penis.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		penis.scrollFactor.set();
		if (sheShed != 'job-interview')
			add(penis);
		
		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		if (sheShed != 'job-interview')
			add(iconP1);
		
		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		if (sheShed != 'job-interview')
			add(iconP2);

		if (FlxG.save.data.downscroll)
			iconP2.y = iconP1.y = iconP1.y + 10; // also stolen from mashup

		if (sheShed != 'job-interview')
		{
			add(missTxt);
			add(scoreTxt);
		}

		if (SONG.player1 == 'radical')
		{
			switch (FlxG.save.data.outfit)
			{
				case 'Old Radical':
					iconP1.loadIcon('racial');
				case 'RedBall':
					iconP1.loadIcon('radball');
				case 'Racial Pride':
					iconP1.loadIcon('racial-pride');
				case 'Sussy Radical':
					iconP1.loadIcon('sus');
				case 'Business Radical':
					iconP1.loadIcon('radical-suit');
			}
		}

		if (SONG.player2 == 'radical')
		{
			switch (FlxG.save.data.outfit)
			{
				case 'Old Radical':
					iconP2.loadIcon('racial');
				case 'RedBall':
					iconP2.loadIcon('radball');
				case 'Racial Pride':
					iconP2.loadIcon('racial-pride');
				case 'Sussy Radical':
					iconP2.loadIcon('sus');
				case 'Business Radical':
					iconP2.loadIcon('radical-suit');
			}
		}

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		darf.cameras = [camHUD];
		penis.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play('assets/sounds/Lights_Turn_On' + TitleState.soundExt);
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'north':
				    camFollow.x += 200;
                    schoolIntro(doof);
                case 'radical-vs-masked-babbys' | 'monkey-sprite' | 'namebe' | 'bouncy-drop' | 'bonnie-song' | 'bonbon-loool' | 'without-you':
                    schoolIntro(doof);
                case 'destructed':
                    camFollow.x -= 350;
                    camFollow.y += 100;
                    schoolIntro(doof);
				case 'job-interview':
					camFollow.x = 640;
					camFollow.y = 360;
					var cutsceneAudio:FlxSound = new FlxSound().loadEmbedded('assets/music/cut.ogg');
					Assets.loadLibrary('week1cutscene').onComplete(function(_) {
						var clip = Assets.getMovieClip('week1cutscene:');
						(cast (Lib.current.getChildAt(0), Main)).addChild(clip);

						cutsceneAudio.onComplete = function() {
							initJobInterview();
							(cast (Lib.current.getChildAt(0), Main)).removeChild(clip);
						}
						cutsceneAudio.play();
					});
				default:
					startCountdown();
			}
		}
		else if (isWeekend)
		{
			switch (curSong.toLowerCase())
			{
				case 'senpai' | 'thorns':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play('assets/sounds/ANGRY' + TitleState.soundExt);
					schoolIntro(doof);
				case 'the-backyardagains' | 'funny':
					flynetIntro(darf);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'job-interview':
					add(healthBarBG);
					add(healthBar);
					add(iconP1);
					add(iconP2);
					add(scoreTxt);
					add(penis);
					startCountdown();
				default:
					startCountdown();
			}
		}

                #if lime
		trace("LIME WILL BE REAL IN 30 SECONDS");
		#end

		super.create();
	}

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (curSection != SONG.notes[sectionNum])
		 	curSection = SONG.notes[sectionNum];

		super.update(elapsed);

		scoreTxt.text = 'Score: $songScore | Combo Breaks: $misses | Accuracy: ${FlxMath.roundDecimal((accurateNotes / totalNotes) * 100, 2)}%';
		scoreTxt.screenCenter(X);

		if (controls.RESET && startedCountdown)
			health = 0;

		stageSpecificUpdate(elapsed);

		iconJunk();

		checkNonGameplayButtons();

		checkFrames();

		cameraJunk();

		addQuickWatches();

		checkDeath();

		noteJunk();

		if (!inCutscene)
			keyShit();
	}

	var sectionStep:Int = 0;
	
	override function stepHit()
	{
		if (SONG.needsVoices)
		{
			if (vocals.time > Conductor.songPosition + 20 || vocals.time < Conductor.songPosition - 20)
				resyncVocals();
		}

		super.stepHit();

		sectionStep++;
		if (curSection != null)
		{
			if (sectionStep == curSection.lengthInSteps)
			{
				sectionNum++;
				sectionStep = 0;
			}
		}
	}

	override function beatHit()
	{
		if (curStage == 'schoolEvil')
			wiggleShit.update(Conductor.crochet);
		super.beatHit();

		if (generatedMusic)
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);

		if (SONG.notes[sectionNum] != null)
		{
			checkBpmChange(sectionNum);

			makeNpcsDance();

			if (totalBeats % 4 == 0 && SONG.notes[sectionNum].getComboSection && FlxG.save.data.ludumRating)
				showRating();
		}

		updateRichPresence();

		if (camZooming && FlxG.camera.zoom < 1.35 && totalBeats % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		tweenIcons();

		if (totalBeats % gfSpeed == 0)
			gf.dance();

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
			boyfriend.playAnim('idle');

		stageSpecificBeatHit();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;

		var babbys:Character = new Character(200, 285, 'babbys');

		if (sheShed == 'monkey-sprite')
		{
			var funnyMonkey:FlxSprite = new FlxSprite(1936, -424).loadGraphic(stagePath + 'babbys/swinger.png');
			funnyMonkey.setGraphicSize(605);
			funnyMonkey.updateHitbox();
			funnyMonkey.setGraphicSize(Std.int(funnyMonkey.width / 1.15));
			funnyMonkey.antialiasing = true;
			funnyMonkey.scrollFactor.set();

			add(babbys);
			add(funnyMonkey);
			babbys.playAnim('cutscene');
			dad.visible = false;

			camFollow.y += 30;
			new FlxTimer().start(0, function(tmr:FlxTimer){ // DEAR GOD WTF IS THIS
				if (babbys.animation.frameIndex == 50) // babbys looking scared frame
				{
					FlxG.sound.play('assets/sounds/monkey1.ogg');
					FlxTween.tween(funnyMonkey, {x: -724}, 0.7, {onComplete: function(twn:FlxTween){ // monkey swing from vine
						new FlxTimer().start(0, function(tmr:FlxTimer){
							if (babbys.animation.frameIndex == 73)
							{
								FlxG.sound.play('assets/sounds/monkey2.ogg');
								funnyMonkey.flipX = true;
								FlxTween.tween(funnyMonkey, {x: 1971}, 0.7, {onComplete: function(twn:FlxTween){ // monkey swing again
									new FlxTimer().start(0, function(visibilityTimer:FlxTimer){
										if (babbys.animation.frameIndex == 97) // babbys get hit by falling monkey
										{
											dad.playAnim('drop');
											dad.visible = true;
											new FlxTimer().start(0, function(tmr:FlxTimer){
												if (dad.animation.curAnim.curFrame == 4) // monkey hit ground frame
												{
													FlxG.sound.play('assets/sounds/monkey_land.ogg');
													new FlxTimer().start(0, function(tmr:FlxTimer){ // doin this cause the monkey drop animation goes invisible on the last frame for whatever reason
														if (dad.animation.curAnim.curFrame == 16)
															dad.playAnim('danceLeft');
														else
															tmr.reset();
													});
												}
												else
													tmr.reset();
											});
										}
										else
											visibilityTimer.reset();
									});
								}});
							}
							else
								tmr.reset();
						});
					}});
				}
				else
					tmr.reset();
			});
		}
		
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var blackOffice:FlxSprite = new FlxSprite(0, 0).loadGraphic('assets/images/theeseE.png');
		blackOffice.scrollFactor.set();
		if (sheShed ==  'job-interview')
			add(blackOffice);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = FlxAtlasFrames.fromSparrow(stagePath + 'weeb/senpaiCrazy.png', stagePath + 'weeb/senpaiCrazy.xml');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (sheShed == 'roses' || sheShed == 'thorns' || sheShed == 'radical-vs-masked-babbys')
		{
			remove(black);

			if (sheShed == 'thorns')
			{
				add(red);
			}
		}

		if (sheShed == 'destructed')
			gspot.visible = false;

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (sheShed == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.screenCenter();
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play('assets/sounds/Senpai_Dies' + TitleState.soundExt, 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else if (sheShed == 'monkey-sprite')
					{
						FlxG.sound.playMusic('assets/music/MonkeySprite.ogg');
						FlxG.sound.music.volume = 0;
						FlxG.sound.play('assets/sounds/ouch!.ogg');
						FlxG.sound.play('assets/sounds/electro.ogg');

						var whiteJunky:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
						whiteJunky.scrollFactor.set();
						whiteJunky.visible = false;
						add(whiteJunky);

						FlxFlicker.flicker(whiteJunky, 0.5, 0.05, false);

						new FlxTimer().start(0.3, function(tmr:FlxTimer){
							ogBG.alpha -= 0.15;
							FlxG.sound.music.volume += 0.25;

							if (ogBG.alpha > 0)
								tmr.reset();
							else
							{
								camFollow.x -= 300;
								new FlxTimer().start(0, function(tmr:FlxTimer){
									if (babbys.animation.curAnim.name == 'cutscene' && babbys.animation.curAnim.finished)
									{
										babbys.visible = false;
										pogBabby.visible = true;
										pogBabby.animation.play('pog', true);
										new FlxTimer().start(1.25, function(wow2:FlxTimer){
											camFollow.x += 300;
											camFollow.y -= 30;
											new FlxTimer().start(0.75, function(iLoveWow2SoMuch:FlxTimer){
												add(dialogueBox);
											});
										});
									}
									else
										tmr.reset();
								});
							}	
						});
					}
					else if (sheShed == 'destructed')
					{
						vans.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							vans.alpha += 0.15;
							if (vans.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
                                vans.visible = true;
								vans.animation.play('close');
								FlxG.sound.play('assets/sounds/CarFirst' + TitleState.soundExt, 1, false, null, true, function()
								{
                                    gspot.visible = true;
                                    FlxG.sound.play('assets/sounds/CarSecond' + TitleState.soundExt, 1, false, null, true, function()
          							{
          								add(dialogueBox);
          							});
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
                                    //hi
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function initJobInterview():Void
	{
		add(healthBarBG);
		add(scoreTxt);
		add(healthBar);
		add(iconP1);
		add(iconP2);
		startCountdown();
	}

	function flynetIntro(?dialogueBubble:DialogueBubble):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		switch (curSong.toLowerCase())
		{
			case 'the-backyardagains':
				dad.visible = false;
				camFollow.x = dad.getMidpoint().x + 100;
				camFollow.y += 100;
			case 'funny':
				camFollow.x = dad.getMidpoint().x + 100;
				camFollow.y += 60;
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBubble != null)
				{
					inCutscene = true;

					if (sheShed == 'the-backyardagains')
					{
						dad.playAnim('introSpin');
						dad.visible = true;
						new FlxTimer().start(1.35, function(swagTimer:FlxTimer)
						{
							add(dialogueBubble);
						});
					}
					else if (SONG.song == 'funny')
					{
						new FlxTimer().start(1.35, function(swagTimer:FlxTimer)
						{
							add(dialogueBubble);
						});
					}
					else
					{
						add(dialogueBubble);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;
		hasFocusedOnDudes = false;
		hasFocusedOnGaming = false;
		sectionNum = -1;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		if (curStage == 'flynets')
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			FlxG.camera.zoom = defaultCamZoom;
			FlxG.camera.focusOn(camFollow.getPosition());
		}

		if (SONG.notes[0].mustHitSection)
			camFollowBF();
		else
			camFollowDad(true);

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			gspot.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['UI/ready.png', "UI/set.png", "UI/go.png"]);
			introAssets.set('school', [
				'UI/pixelUI/ready-pixel.png',
				'UI/pixelUI/set-pixel.png',
				'UI/pixelUI/date-pixel.png'
			]);
			introAssets.set('schoolEvil', [
				'UI/pixelUI/ready-pixel.png',
				'UI/pixelUI/set-pixel.png',
				'UI/pixelUI/date-pixel.png'
			]);
			introAssets.set('freebeat', [
				'UI/red/ready.png',
				'UI/red/set.png',
				'UI/red/go.png'
			]);
			introAssets.set('junk', [
				'UI/red/ready.png',
				'UI/red/set.png',
				'UI/red/go.png'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					switch (value)
					{
						case 'school' | 'schoolEvil':
							altSuffix = '-pixel';
						case 'freebeat' | 'junk':
							altSuffix = '-red';
					}
					
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play('assets/sounds/intro3' + altSuffix + TitleState.soundExt, 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[0]);
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro2' + altSuffix + TitleState.soundExt, 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[1]);
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro1' + altSuffix + TitleState.soundExt, 0.6);
				case 3:
					var go:FlxSprite;

					if (curStage.startsWith('school'))
					{
						go = new FlxSprite().loadGraphic('assets/images/' + introAlts[2]);
						go.scrollFactor.set();
						go.setGraphicSize(Std.int(go.width * daPixelZoom));
					}
					else if (curStage.startsWith('freebeat') || curStage == 'junk')
					{
						go = new FlxSprite().loadGraphic('assets/images/' + introAlts[2]);
						go.scrollFactor.set();
					}
					else if (curStage.startsWith('flynets'))
					{
						go = new FlxSprite().loadGraphic('assets/images/UI/go.png');
						go.scrollFactor.set();
					}
					else
					{
						go = new FlxSprite(0, 0);
						go.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/goAnim.png', 'assets/images/UI/goAnim.xml');
						go.animation.addByPrefix('go', 'GO!!', 24, false);
						go.scrollFactor.set();
					}


					go.updateHitbox();

					go.screenCenter();
					add(go);
					switch (curStage)
					{
						case 'schoolEvil':
							FlxTween.tween(go, {"scale.x": 15, alpha: 0}, 25, {onComplete: function(twn:FlxTween){
								go.alpha = 1;
								go.setGraphicSize(25, 25);
								go.setPosition(boyfriend.x, boyfriend.y);
							}});
						case 'school' | 'freebeat' | 'junk':
							FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									go.destroy();
								}
							});
						case 'flynets':
							FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									go.destroy();
								}
							});
						default:
							go.animation.play('go');
							boyfriend.playAnim('hey', true);
					}
					FlxG.sound.play('assets/sounds/introGo' + altSuffix + TitleState.soundExt, 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic("assets/music/" + SONG.song + "_Inst" + TitleState.soundExt, 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();
	}

	var debugNum:Int = 0;
	var totalNotes:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded("assets/music/" + curSong + "_Voices" + TitleState.soundExt);
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4); // lol

			if (section.bustomMaps != null)
			{
				for (map in section.bustomMaps)
				{
					trace('bustom map: $map');
				}
			}

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic('assets/images/UI/pixelUI/arrows-pixels.png', true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16], 24, false);
					}
				case 'picnic' | 'junk' | 'freebeat':
					babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/red/NOTE_assets.png', 'assets/images/UI/red/NOTE_assets.xml');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'up confirm', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], '', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'right confirm', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], '', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'down confirm', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], '', 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'left confirm', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], '', 24, false);
					}

				default:
					babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/UI/NOTE_assets.png', 'assets/images/UI/NOTE_assets.xml');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'up confirm', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], '', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'right confirm', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], '', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'down confirm', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], '', 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'left confirm', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], '', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
				playerStrums.add(babyArrow);
			else
				otherStrums.add(babyArrow);

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null)
			{
				if (!startTimer.finished)
					startTimer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null)
			{
				if (!startTimer.finished)
					startTimer.active = true;
			}
			paused = false;
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	var iconJunky:Bool = false;
	var missTxt:FlxText;

	var lanceyJustYawned:String = 'nah';

	function animateCharacters(daNote:Note, altAnim:String, gspotAnim:String, dontplayAnim:String)
	{
		if (gspotAnim == '-gspot')
		{
			switch (Math.abs(daNote.noteData))
			{
				case 2:
					gspot.playAnim('singUP' + altAnim, true);
				case 3:
					gspot.playAnim('singRIGHT' + altAnim, true);
				case 1:
					gspot.playAnim('singDOWN' + altAnim, true);
				case 0:
					gspot.playAnim('singLEFT' + altAnim, true);
			}
		}
		else
		{
			switch (Math.abs(daNote.noteData))
			{
				case 2:
					dad.playAnim('singUP' + altAnim, true);
				case 3:
					dad.playAnim('singRIGHT' + altAnim, true);
				case 1:
					dad.playAnim('singDOWN' + altAnim, true);
				case 0:
					dad.playAnim('singLEFT' + altAnim, true);
			}
		}


		otherStrums.forEach(function(poop:FlxSprite)
		{
			if (poop.ID == Math.abs(daNote.noteData))
			{
				poop.animation.play('confirm', true);
				if (!curStage.startsWith('school'))
				{
					poop.centerOffsets();
					poop.offset.x -= 13;
					poop.offset.y -= 13;
				}
			}
		});
	}

	function endSong():Void
	{
		controls.setKeyboardScheme(KeyboardScheme.Solo, true);

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);

				FlxG.switchState(new StoryMenuState());

				trace(StoryMenuState.weekData);

				switch(storyWeek)
				{
					case 1:
						if (!FlxG.save.data.businessUnlock)
							StoryMenuState.justUnlockedSkin = true;
						StoryMenuState.skin2Unlock = 'Business Radical';
						FlxG.save.data.businessUnlock = true;
				}

				// if ()
				//StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				//FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('https://us.rule34.xxx//images/114/108917d22423b516f73a1ce0618d19cd90f01a9b.jpg');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (sheShed == 'eggnog' || sheShed == 'radical-vs-masked-babbys')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play('assets/sounds/Lights_Shut_off' + TitleState.soundExt);
				}

				if (sheShed == 'north')
				{
					transIn = null;
					transOut = null;
					prevCamFollow = camFollow;
				}

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				FlxG.switchState(new PlayState());

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
			}
		}
		else if (isWeekend)
		{
			weekendScore += songScore;

			weekendPlaylist.remove(weekendPlaylist[0]);

			if (weekendPlaylist.length <= 0)
			{
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);

				FlxG.switchState(new WeekendMenuState());

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekendScore(weekend, weekendScore);
				}
			}
			else
			{
				trace('https://lotus.paheal.net/_images/80322ae33480fa20c8ca4acf9ccc2ea2/4105279%20-%20Flandre_Scarlet%20Suika_Ibuki%20Touhou.jpg');
				trace(PlayState.weekendPlaylist[0].toLowerCase());

				if (sheShed == 'senpai')
				{
					transIn = null;
					transOut = null;
					prevCamFollow = camFollow;
				}

				var pooping = SONG;

				PlayState.SONG = Song.loadFromJson(PlayState.weekendPlaylist[0].toLowerCase(), PlayState.weekendPlaylist[0]);
				FlxG.sound.music.stop();

				if (pooping.song.toLowerCase() == 'dawgee-want-food')
				{
					var newCam:FlxCamera = new FlxCamera();
					FlxG.cameras.add(newCam);
					var audiblePlop:FlxSprite = new FlxSprite().loadGraphic('assets/images/cutscenes/redball/sleppy.png');
					audiblePlop.screenCenter();
					audiblePlop.setGraphicSize(0, FlxG.height);
					audiblePlop.cameras = [newCam];
					add(audiblePlop);
					var sfdj:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					sfdj.scrollFactor.set();
					sfdj.cameras = [newCam];
					add(sfdj);
					new FlxTimer().start(0.3, function(tmr:FlxTimer){
						sfdj.alpha -= 0.3;
						if (sfdj.alpha > 0)
							tmr.reset();
						else
							new FlxTimer().start(0, function(amongUsFartCompilation:FlxTimer)
								{
									if (FlxG.keys.justPressed.ANY)
										new FlxTimer().start(0.3, function(peinsPig:FlxTimer){
											sfdj.alpha += 0.3;
											if (sfdj.alpha < 1)
												peinsPig.reset();
											else
												FlxG.switchState(new PlayState());
										});
									else
										amongUsFartCompilation.reset();
								});
					});
				}
				else
					FlxG.switchState(new PlayState());

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
			}
		}
		else if (weekEndFreeplay)
		{
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			trace('https://lotus.paheal.net/_images/fe1373a376e1aeba78151320305fa2c4/3814219%20-%20LUNA_PRISMRIVER%20Suika_Ibuki%20Touhou.jpg');
			FlxG.switchState(new WeekendMenuState());
		}
		else if (randomLevel)
		{
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			trace('https://peach.paheal.net/_images/aa882218582e0ad6bdb1a6e99e52f1f6/1013705%20-%20Mamo_Williams%20Suika_Ibuki%20Touhou.png');
			FlxG.switchState(new MainMenuState());
		}
		else
		{
			trace('https://wimg.rule34.xxx//images/781/fc1d51f73ab6f44995a0a658a29140b238b2ec31.png?780429');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	var sicks:Int = 0;
	var goods:Int = 0;
	var bads:Int = 0;
	var shits:Int = 0;
	var curMisses:Int = 0;
	var accurateNotes:Float = 0;

	private function popUpScore(strumtime:Float):Void
	{
				var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
				// boyfriend.playAnim('hey');
				vocals.volume = 1;

				var placement:String = Std.string(combo);

				var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
				coolText.screenCenter();
				coolText.x = FlxG.width * 0.55;
				//

				var rating:FlxSprite = new FlxSprite();
				var score:Int = 350;

				var daRating:String = "sick";

				if (noteDiff > Conductor.safeZoneOffset * 1 || noteDiff < Conductor.safeZoneOffset * -1)
				{
					daRating = 'shit';
					score = 50;
					shits++;
					accurateNotes += 0.25;
				}
				else if (noteDiff > Conductor.safeZoneOffset * 0.85 || noteDiff < Conductor.safeZoneOffset * -0.85)
				{
					daRating = 'bad';
					score = 100;
					bads++;
					accurateNotes += 0.5;
				}
				else if (noteDiff > Conductor.safeZoneOffset * 0.3 || noteDiff < Conductor.safeZoneOffset * -0.3)
				{
					daRating = 'good';
					score = 200;
					goods++;
					accurateNotes += 0.75;
				}
				else
				{
					sicks++;
					accurateNotes += 1.0;
				}

				totalNotes++;

				songScore += score;

				/* if (combo > 60)
						daRating = 'sick';
					else if (combo > 12)
						daRating = 'good'
					else if (combo > 4)
						daRating = 'bad';
				*/

				var pixelShitPart1:String = "";
				var pixelShitPart2:String = '';

				if (curStage.startsWith('school'))
				{
					pixelShitPart1 = 'pixelUI/';
					pixelShitPart2 = '-pixel';
				}

				rating.loadGraphic('assets/images/UI/' + pixelShitPart1 + daRating + pixelShitPart2 + ".png");
				rating.screenCenter();
				rating.x = boyfriend.x;
				rating.y -= 60;
				rating.acceleration.y = 550;
				rating.velocity.y -= FlxG.random.int(140, 175);
				rating.velocity.x -= FlxG.random.int(0, 10);

				var comboSpr:FlxSprite = new FlxSprite().loadGraphic('assets/images/UI/' + pixelShitPart1 + 'combo' + pixelShitPart2 + '.png');
				comboSpr.screenCenter();
				comboSpr.x = boyfriend.x;
				comboSpr.acceleration.y = 600;
				comboSpr.velocity.y -= 150;

				comboSpr.velocity.x += FlxG.random.int(1, 10);

				if (!FlxG.save.data.ludumRating)
					add(rating);

				if (!curStage.startsWith('school'))
				{
					rating.setGraphicSize(Std.int(rating.width * 0.7));
					rating.antialiasing = true;
					comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
					comboSpr.antialiasing = true;
				}
				else
				{
					rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
					comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
				}

				comboSpr.updateHitbox();
				rating.updateHitbox();

				var seperatedScore:Array<Int> = [];

				seperatedScore.push(Math.floor(combo / 100));
				seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
				seperatedScore.push(combo % 10);

				var daLoop:Int = 0;
				for (i in seperatedScore)
				{
					var numScore:FlxSprite = new FlxSprite().loadGraphic('assets/images/UI/' + pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2 + '.png');
					numScore.screenCenter();
					numScore.x = coolText.x + (43 * daLoop) - 90;
					numScore.y += 80;

					if (!curStage.startsWith('school'))
					{
						numScore.antialiasing = true;
						numScore.setGraphicSize(Std.int(numScore.width * 0.5));
					}
					else
					{
						numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
					}
					numScore.updateHitbox();

					numScore.acceleration.y = FlxG.random.int(200, 300);
					numScore.velocity.y -= FlxG.random.int(140, 160);
					numScore.velocity.x = FlxG.random.float(-5, 5);

					if (combo >= 10 || combo == 0)
						add(numScore);

					FlxTween.tween(numScore, {alpha: 0}, 0.2, {
						onComplete: function(tween:FlxTween)
						{
							numScore.destroy();
						},
						startDelay: Conductor.crochet * 0.002
					});

					daLoop++;
				}
				/* 
					trace(combo);
					trace(seperatedScore);
				*/

				coolText.text = Std.string(seperatedScore);
				// add(coolText);

				FlxTween.tween(rating, {alpha: 0}, 0.2, {
					startDelay: Conductor.crochet * 0.001
				});

				FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						coolText.destroy();
						comboSpr.destroy();

						rating.destroy();
					},
					startDelay: Conductor.crochet * 0.001
				});
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;	

	private function keyShit():Void
	{
		switch (whatInputSystem)
		{
			case 'RadicalOne':
				// HOLDING
				var up = controls.UP;
				var right = controls.RIGHT;
				var down = controls.DOWN;
				var left = controls.LEFT;

				var upP = controls.UP_P;
				var rightP = controls.RIGHT_P;
				var downP = controls.DOWN_P;
				var leftP = controls.LEFT_P;

				var upR = controls.UP_R;
				var rightR = controls.RIGHT_R;
				var downR = controls.DOWN_R;
				var leftR = controls.LEFT_R;

				var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

				// FlxG.watch.addQuick('asdfa', upP);
				if ((upP || rightP || downP || leftP) && generatedMusic)
				{
					boyfriend.holdTimer = 0;

					var possibleNotes:Array<Note> = [];

					var ignoreList:Array<Int> = [];

					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
						{
							// the sorting probably doesn't need to be in here? who cares lol
							possibleNotes.push(daNote);
							possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

							ignoreList.push(daNote.noteData);
						}
					});

					if (possibleNotes.length > 0)
					{
						var daNote = possibleNotes[0];

						if (perfectMode)
							noteCheckOG([true, true, true, true], daNote);

						// Jump notes
						if (possibleNotes.length >= 2)
						{
							var isPooping:Bool = false;
							var lastStrumTime:Float = 0;
							for (thisNote in possibleNotes)
							{
								if (thisNote.strumTime == lastStrumTime)
									isPooping = true;
								lastStrumTime = thisNote.strumTime;
							}

							var isPissing:Bool = false;
							var lastNoteData:Int = 1337;
							for (poop in possibleNotes)
							{
								if (poop.noteData == lastNoteData)
									isPissing = true;
								lastNoteData = poop.noteData;
							}

							if (isPooping)
							{
								for (coolNote in possibleNotes)
								{
									if (controlArray[coolNote.noteData])
										goodNoteHit(coolNote);
									else
									{
										var inIgnoreList:Bool = false;
										for (shit in 0...ignoreList.length)
										{
											if (controlArray[ignoreList[shit]])
												inIgnoreList = true;
										}
										if (!inIgnoreList)
											badNoteCheck();
									}
								}
							}
							else if (isPissing)
							{
								noteCheckOG(controlArray, daNote);
							}
							else
							{
								noteCheckSimple(controlArray, possibleNotes);
								trace("SIMPLE NOTE CHECK");
							}
						}
						else // regular notes?
						{
							noteCheckOG(controlArray, daNote);
						}
						/* 
							if (controlArray[daNote.noteData])
								goodNoteHit(daNote);
						*/
						// trace(daNote.noteData);
						/* 
							switch (daNote.noteData)
							{
								case 2: // NOTES YOU JUST PRESSED
									if (upP || rightP || downP || leftP)
										noteCheck(upP, daNote);
								case 3:
									if (upP || rightP || downP || leftP)
										noteCheck(rightP, daNote);
								case 1:
									if (upP || rightP || downP || leftP)
										noteCheck(downP, daNote);
								case 0:
									if (upP || rightP || downP || leftP)
										noteCheck(leftP, daNote);
							}
						*/
						if (daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
					}
					else
					{
						badNoteCheck();
					}
				}

				if ((up || right || down || left) && generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
						{
							switch (daNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 2:
									if (up)
										goodNoteHit(daNote);
								case 3:
									if (right)
										goodNoteHit(daNote);
								case 1:
									if (down)
										goodNoteHit(daNote);
								case 0:
									if (left)
										goodNoteHit(daNote);
							}
						}
					});
				}

				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.playAnim('idle');
					}
				}

				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 2:
							if (upP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (upR)
								spr.animation.play('static');
						case 3:
							if (rightP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (rightR)
								spr.animation.play('static');
						case 1:
							if (downP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (downR)
								spr.animation.play('static');
						case 0:
							if (leftP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (leftR)
								spr.animation.play('static');
					}

					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			case 'Kade Engine':
				var up = controls.UP;
				var right = controls.RIGHT;
				var down = controls.DOWN;
				var left = controls.LEFT;

				var upP = controls.UP_P;
				var rightP = controls.RIGHT_P;
				var downP = controls.DOWN_P;
				var leftP = controls.LEFT_P;

				var upR = controls.UP_R;
				var rightR = controls.RIGHT_R;
				var downR = controls.DOWN_R;
				var leftR = controls.LEFT_R;

				var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

				// FlxG.watch.addQuick('asdfa', upP);
				if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
					{
						boyfriend.holdTimer = 0;
			
						var possibleNotes:Array<Note> = [];
			
						var ignoreList:Array<Int> = [];
			
						notes.forEachAlive(function(daNote:Note)
						{
							if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
							{
								// the sorting probably doesn't need to be in here? who cares lol
								possibleNotes.push(daNote);
								possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			
								ignoreList.push(daNote.noteData);
							}
						});
			
						
						if (possibleNotes.length > 0)
						{
							var daNote = possibleNotes[0];

							var youAreImpostor:Bool = possibleNotes.length == 1;

							if (youAreImpostor) youAreSus();
			
							// Jump notes
							if (possibleNotes.length >= 2)
							{
								if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
								{
									for (coolNote in possibleNotes)
									{
										if (controlArray[coolNote.noteData])
											goodNoteHit(coolNote);
										else
										{
											var inIgnoreList:Bool = false;
											for (shit in 0...ignoreList.length)
											{
												if (controlArray[ignoreList[shit]])
													inIgnoreList = true;
											}
										}
									}
								}
								else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
								{
									noteCheckKade(controlArray, daNote);
								}
								else
								{
									for (coolNote in possibleNotes)
									{
										noteCheckKade(controlArray, coolNote);
									}
								}
							}
							else // regular notes?
								noteCheckKade(controlArray, daNote);

							if (daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						}
							
						}

						if ((up || right || down || left) && generatedMusic)
							{
								notes.forEachAlive(function(daNote:Note)
								{
									if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
									{
										switch (daNote.noteData)
										{
											// NOTES YOU ARE HOLDING
											case 2:
												if (up || upHold)
													goodNoteHitKade(daNote);
											case 3:
												if (right || rightHold)
													goodNoteHitKade(daNote);
											case 1:
												if (down || downHold)
													goodNoteHitKade(daNote);
											case 0:
												if (left || leftHold)
													goodNoteHitKade(daNote);
										}
									}
								});
							}
					
							if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
							{
								if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
								{
									boyfriend.playAnim('idle');
								}
							}
					
							playerStrums.forEach(function(spr:FlxSprite)
							{
								switch (spr.ID)
								{
									case 2:
										if (upP && spr.animation.curAnim.name != 'confirm')
										{
											spr.animation.play('pressed');
										}
										if (upR)
										{
											spr.animation.play('static');
										}
									case 3:
										if (rightP && spr.animation.curAnim.name != 'confirm')
											spr.animation.play('pressed');
										if (rightR)
										{
											spr.animation.play('static');
										}
									case 1:
										if (downP && spr.animation.curAnim.name != 'confirm')
											spr.animation.play('pressed');
										if (downR)
										{
											spr.animation.play('static');
										}
									case 0:
										if (leftP && spr.animation.curAnim.name != 'confirm')
											spr.animation.play('pressed');
										if (leftR)
										{
											spr.animation.play('static');
										}
								}
								
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
			case 'FNF Pre Week 5':
				// HOLDING
				var up = controls.UP;
				var right = controls.RIGHT;
				var down = controls.DOWN;
				var left = controls.LEFT;

				var upP = controls.UP_P;
				var rightP = controls.RIGHT_P;
				var downP = controls.DOWN_P;
				var leftP = controls.LEFT_P;

				var upR = controls.UP_R;
				var rightR = controls.RIGHT_R;
				var downR = controls.DOWN_R;
				var leftR = controls.LEFT_R;

				// FlxG.watch.addQuick('asdfa', upP);
				if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
				{
					boyfriend.holdTimer = 0;

					var possibleNotes:Array<Note> = [];

					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
						{
							possibleNotes.push(daNote);
						}
					});

					if (possibleNotes.length > 0)
					{
						for (daNote in possibleNotes)
						{
							if (perfectMode)
								noteCheck(true, daNote);

							switch (daNote.noteData)
							{
								case 2: // NOTES YOU JUST PRESSED
									if (upP || rightP || downP || leftP)
										noteCheck(upP, daNote);
								case 3:
									if (upP || rightP || downP || leftP)
										noteCheck(rightP, daNote);
								case 1:
									if (upP || rightP || downP || leftP)
										noteCheck(downP, daNote);
								case 0:
									if (upP || rightP || downP || leftP)
										noteCheck(leftP, daNote);
							}

							if (daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						}
					}
					else
					{
						badNoteCheck();
					}
				}

				if ((up || right || down || left) && !boyfriend.stunned && generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
						{
							switch (daNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 2:
									if (up && daNote.prevNote.wasGoodHit)
										goodNoteHit(daNote);
								case 3:
									if (right && daNote.prevNote.wasGoodHit)
										goodNoteHit(daNote);
								case 1:
									if (down && daNote.prevNote.wasGoodHit)
										goodNoteHit(daNote);
								case 0:
									if (left && daNote.prevNote.wasGoodHit)
										goodNoteHit(daNote);
							}
						}
					});
				}

				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.playAnim('idle');
					}
				}

				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 2:
							if (upP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (upR)
								spr.animation.play('static');
						case 3:
							if (rightP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (rightR)
								spr.animation.play('static');
						case 1:
							if (downP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (downR)
								spr.animation.play('static');
						case 0:
							if (leftP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (leftR)
								spr.animation.play('static');
					}

					if (spr.animation.curAnim.name == 'confirm')
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			case 'FPS Plus':
				// HOLDING
				var up = controls.UP;
				var right = controls.RIGHT;
				var down = controls.DOWN;
				var left = controls.LEFT;

				var upP = controls.UP_P;
				var rightP = controls.RIGHT_P;
				var downP = controls.DOWN_P;
				var leftP = controls.LEFT_P;

				var upR = controls.UP_R;
				var rightR = controls.RIGHT_R;
				var downR = controls.DOWN_R;
				var leftR = controls.LEFT_R;

				var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

				// FlxG.watch.addQuick('asdfa', upP);
				if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
				{
					boyfriend.holdTimer = 0;

					var possibleNotes:Array<Note> = [];

					var ignoreList:Array<Int> = [];

					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
						{
							// the sorting probably doesn't need to be in here? who cares lol
							possibleNotes.push(daNote);
							possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

							ignoreList.push(daNote.noteData);
						}

					});

					if (possibleNotes.length > 0)
					{
						var daNote = possibleNotes[0];

						if (perfectMode)
							noteCheck(true, daNote);

						// Jump notes
						if (possibleNotes.length >= 2)
						{
							if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
							{
								for (coolNote in possibleNotes)
								{
									if (controlArray[coolNote.noteData])
										goodNoteHitPlus(coolNote);
									else
									{
										var inIgnoreList:Bool = false;
										for (shit in 0...ignoreList.length)
										{
											if (controlArray[ignoreList[shit]])
												inIgnoreList = true;
										}
										if (!inIgnoreList)
											badNoteCheck();
									}
								}
							}
							else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
							{
								noteCheck(controlArray[daNote.noteData], daNote);
							}
							else
							{
								for (coolNote in possibleNotes)
								{
									noteCheck(controlArray[coolNote.noteData], coolNote);
								}
							}
						}
						else // regular notes?
						{
							noteCheck(controlArray[daNote.noteData], daNote);
						}
						/* 
							if (controlArray[daNote.noteData])
								goodNoteHit(daNote);
						*/
						// trace(daNote.noteData);
						/* 
							switch (daNote.noteData)
							{
								case 2: // NOTES YOU JUST PRESSED
									if (upP || rightP || downP || leftP)
										noteCheck(upP, daNote);
								case 3:
									if (upP || rightP || downP || leftP)
										noteCheck(rightP, daNote);
								case 1:
									if (upP || rightP || downP || leftP)
										noteCheck(downP, daNote);
								case 0:
									if (upP || rightP || downP || leftP)
										noteCheck(leftP, daNote);
							}
						*/
						if (daNote.wasGoodHit)
						{
							daNote.destroy();
						}
					}
					else
					{
						badNoteCheck();
					}
				}

				if ((up || right || down || left) && !boyfriend.stunned && generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
						{
							switch (daNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 2:
									if (up)
										goodNoteHitPlus(daNote);
								case 3:
									if (right)
										goodNoteHitPlus(daNote);
								case 1:
									if (down)
										goodNoteHitPlus(daNote);
								case 0:
									if (left)
										goodNoteHitPlus(daNote);
							}
						}
					});
				}

				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing'))
						boyfriend.idleEnd();
				}

				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 2:
							if (upP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (!up)
								spr.animation.play('static');
						case 3:
							if (rightP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (!right)
								spr.animation.play('static');
						case 1:
							if (downP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (!down)
								spr.animation.play('static');
						case 0:
							if (leftP && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (!left)
								spr.animation.play('static');
					}

					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}
		}

	var misses:Int = 0;

	function noteMissWrongPress(direction:Int = 1, ?healthLoss:Float = 0.0475):Void
		{
			if (!startingSong && !boyfriend.invuln)
			{
				health -= healthLoss;
				if (combo > 5)
				{
					gf.playAnim('sad');
				}
				combo = 0;
				misses++;
	
				songScore -= 25;
				
				if (FlxG.save.data.missNoise)
					FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));
				
				// FlxG.sound.play('assets/sounds/missnote1' + TitleState.soundExt, 1, false);
				// FlxG.log.add('played imss note');
	
				setBoyfriendInvuln(0.04);
	
					switch (direction)
					{
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
					}
			}
		}

	function setBoyfriendInvuln(time:Float = 5 / 60){

		invulnCount++;
		var invulnCheck = invulnCount;

		boyfriend.invuln = true;

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			if(invulnCount == invulnCheck){

				boyfriend.invuln = false;

			}
			
		});

	}

	function noteMissPlus(direction:Int = 1, ?healthLoss:Float = 0.04, ?playAudio:Bool = true, ?skipInvCheck:Bool = false):Void
	{
		if (!boyfriend.stunned && !startingSong && (!boyfriend.invuln || skipInvCheck) )
		{
			health -= healthLoss;
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 100;
			
			if(playAudio && FlxG.save.data.missNoise){
				FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));
			}
			// FlxG.sound.play('assets/sounds/missnote1' + TitleState.soundExt, 1, false);
			// FlxG.log.add('played imss note');

			setBoyfriendInvuln(0.08);

				switch (direction)
				{
					case 2:
						boyfriend.playAnim('singUPmiss', true);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
				}
		}
	}

	function goodNoteHitPlus(note:Note):Void
	{

		//Guitar Hero Styled Hold Notes
		if(note.isSustainNote && !note.prevNote.wasGoodHit){
			noteMissPlus(note.noteData, 0.05, true, true);
			note.prevNote.tooLate = true;
			note.prevNote.destroy();
			vocals.volume = 0;
		}

		else if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}

			var amongUs:NoteSplash = new NoteSplash((FlxG.width / 2) + 50 + (Note.swagWidth * note.noteData), strumLine.y, note.noteData);
			amongUs.cameras = [camHUD];
			if (Math.abs(note.strumTime - Conductor.songPosition) <= Conductor.safeZoneOffset * 0.3)
				add(amongUs);

			if (note.noteData >= 0){
						health += 0.015;
				}
			else{
						health += 0.0015;
				}
				
				switch (note.noteData)
				{
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 0:
						boyfriend.playAnim('singLEFT', true);
				}

			if(!note.isSustainNote){
				setBoyfriendInvuln(0.02);
			}
			

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.destroy();
		}
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			combo = 0;
			if (!justMissed)
			{
				misses++;
				justMissed = true;
			}

			songScore -= 10;

			if (FlxG.save.data.missNoise)
				FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play('assets/sounds/missnote1' + TitleState.soundExt, 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
			}
		}
	}

	function noteMissOld(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			if (FlxG.save.data.missNoise)
				FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play('assets/sounds/missnote1' + TitleState.soundExt, 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
			}
		}
	}

	function noteMissKade(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;

			if (FlxG.save.data.missNoise)
				FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play('assets/sounds/missnote1' + TitleState.soundExt, 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
			}
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (whatInputSystem == 'FNF Pre Week 5')
		{
			if (leftP)
				noteMissOld(0);
			if (upP)
				noteMissOld(2);
			if (rightP)
				noteMissOld(3);
			if (downP)
				noteMissOld(1);
		}
		else if (whatInputSystem == 'FPS Plus')
		{
			if (leftP)
				noteMissWrongPress(0);
			if (upP)
				noteMissWrongPress(2);
			if (rightP)
				noteMissWrongPress(3);
			if (downP)
				noteMissWrongPress(1);
		}
		else
		{
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
		}
	}

	function missAllDirections():Void
	{
		for (dir in 0...4) noteMiss(dir);
	}

	function noteCheckSimple(keyArray:Array<Bool>, possibleNotes:Array<Note>):Void
	{
		for (curKey in 0...4)
		{
			var poop:Array<String> = []; // mashing junk

			for (junk in keyArray)
			{
				if (junk)
					poop.push('yo mama');
			}
			
			if (poop.length > possibleNotes.length) // blatant mashing
			{
				missAllDirections();
				break;
			}
			else if (keyArray[curKey])
			{
				for (coolNote in possibleNotes)
				{
					if (coolNote.noteData == curKey)
					{
						goodNoteHit(coolNote);
					}
				}
			}
		}
	}

	function noteCheckOG(keyArray:Array<Bool>, note:Note):Void
	{
		keyArray[note.noteData] ? goodNoteHit(note) : badNoteCheck();
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		keyP ? {
			whatInputSystem == 'FPS Plus' ? goodNoteHitPlus(note) : goodNoteHit(note);
		} : badNoteCheck();	
	}

	var mashing:Int = 0;
	var mashViolations:Int = 0;

	function noteCheckKade(controlArray:Array<Bool>, note:Note):Void
	{
		if (controlArray[note.noteData])
		{
			for (b in controlArray) {
				if (b)
					mashing++;
			}

			// ANTI MASH CODE FOR THE BOYS

			if (mashing <= getKeyPresses(note) && mashViolations < 2)
			{
				mashViolations++;
				goodNoteHitKade(note, (mashing <= getKeyPresses(note)));
			}
			else
			{
				playerStrums.members[note.noteData].animation.play('static');
				trace('mash ' + mashing);
			}

			if (mashing != 0)
				mashing = 0;
		}
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}

			var amongUs:NoteSplash = new NoteSplash((FlxG.width / 2) + 50 + (Note.swagWidth * note.noteData), strumLine.y, note.noteData);
			amongUs.cameras = [camHUD];
			if (Math.abs(note.strumTime - Conductor.songPosition) <= Conductor.safeZoneOffset * 0.3)
				add(amongUs);

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			switch (note.noteData)
			{
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 0:
					boyfriend.playAnim('singLEFT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			justMissed = false;

			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	private var justMissed:Bool = false;

	function goodNoteHitKade(note:Note, resetMashViolation = true):Void
		{

			if (resetMashViolation)
				mashViolations--;

			if (!note.wasGoodHit)
			{
				if (!note.isSustainNote)
				{
					popUpScore(note.strumTime);
					combo += 1;
				}

				if (note.noteData >= 0)
					health += 0.023;
				else
					health += 0.004;

				var amongUs:NoteSplash = new NoteSplash((FlxG.width / 2) + 50 + (Note.swagWidth * note.noteData), strumLine.y, note.noteData);
				amongUs.cameras = [camHUD];
				if (Math.abs(note.strumTime - Conductor.songPosition) <= Conductor.safeZoneOffset * 0.3)
					add(amongUs);


				switch (note.noteData)
				{
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 0:
						boyfriend.playAnim('singLEFT', true);
				}
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.animation.play('confirm', true);
					}
				});
	
				note.wasGoodHit = true;
				vocals.volume = 1;
	
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play('assets/sounds/carPass' + FlxG.random.int(0, 1) + TitleState.soundExt, 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play('assets/sounds/thunder_' + FlxG.random.int(1, 2) + TitleState.soundExt);
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var monkeyCoolDown:Int = 0;

	function showRating()
	{
		var daRating:String = '';

		if (sicks > goods + bads + shits + curMisses)
			daRating = 'sick';
		else if (goods > bads + shits + curMisses)
			daRating = 'good';
		else if (bads > shits + curMisses || sicks == goods && goods == bads && bads == shits && shits == curMisses)
			daRating = 'bad';
		else
			daRating = 'shit';
		var rating:FlxSprite = new FlxSprite();

		rating.loadGraphic('assets/images/$daRating.png');
		rating.screenCenter();
		rating.x -= 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		add(rating);

		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = true;
		rating.updateHitbox();

		var comboSpr:FlxSprite;
		comboSpr = new FlxSprite().loadGraphic('assets/images/UI/combo.png');
		comboSpr.screenCenter();
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);

		comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		comboSpr.antialiasing = true;

		comboSpr.updateHitbox();

		add(comboSpr);

		if (daRating == 'sick')
		{
			new FlxTimer().start(Conductor.crochet * 0.001, function(tmr:FlxTimer){
				boyfriend.playAnim('hey', true);
			});
		}

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				comboSpr.destroy();
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
		curMisses = shits = goods = bads = sicks = 0;
	}

	var remCoolDown:Int = 0;
	var remMoving:Bool = false;

	function moveRem()
	{
		remSwag.x = -3618;
		remMoving = true;
		new FlxTimer().start(0.9, function(tmr:FlxTimer){
			gf.playAnim('scared', true);
		});
		FlxTween.tween(remSwag, {x: 2752}, 2.25, {onComplete: function(twn:FlxTween){
			remMoving = false;
			remCoolDown = 0;
		}});
	}

	function setDialogue(diaPath:String)
	{
		dialogue = CoolUtil.coolTextFile('assets/data/dialogue/' + diaPath + '.txt');
	}

	static public function zoomIntoGaming()
	{
		if (!hasFocusedOnGaming)
		{	
			hasFocusedOnDudes = false;
			hasFocusedOnGaming = true;
			var daCamPos:FlxObject = new FlxObject(0, 0, 1, 1);
			daCamPos.setPosition(Std.int(gamingsOwnCoords[0]), Std.int(gamingsOwnCoords[1]));
			FlxG.camera.follow(daCamPos, NO_DEAD_ZONE, 0.04);
			FlxG.camera.zoom = 1.85;
			FlxG.camera.focusOn(daCamPos.getPosition());
		}
		else
		{
			trace('Already focused on gaming?');
		}
	}

	static public function focusOnTheDudes()
	{
		if (!hasFocusedOnDudes)
		{
			hasFocusedOnGaming = false;
			hasFocusedOnDudes = true;
			var daCamPos:FlxObject = new FlxObject(0, 0, 1, 1);
			daCamPos.setPosition(640, 570);
			FlxG.camera.follow(daCamPos, NO_DEAD_ZONE, 0.04);
			FlxG.camera.zoom = 1.45;
			FlxG.camera.focusOn(daCamPos.getPosition());
		}
	}

	static public function initModes()
	{
		randomLevel = false;
		isStoryMode = false;
		isWeekend = false;
		weekEndFreeplay = false;
	}

	function youAreSus()
	{
		var amongUs:String = 'sus';
		if (FlxG.keys.justPressed.H)
			trace(amongUs.toUpperCase());
	}

	function camFollowDad(forceDad:Bool = false):Void
	{
		if (forceDad){
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100); return;}
		if (!curSection.gspotAnim)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210); LCUKY?!? ???! !??!?eddsgbgjmhjl;;i

			follow(dad);
			gspotTurn = false;
		}
		else
		{
			camFollow.setPosition(gspot.getMidpoint().x + 150, gspot.getMidpoint().y - 100);
			gspotCamZoom = defaultCamZoom;

			follow(gspot);

			gspotTurn = true;
		}

		if (dad.curCharacter == 'bonbon')
			vocals.volume = 1;

		if (sheShed == 'tutorial' || sheShed == 'interrogation')
		{
			tweenCamIn();
		}
	}

	function camFollowBF():Void
	{
		camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

		switch (curStage)
		{
			case 'limo':
				camFollow.x = boyfriend.getMidpoint().x - 300;
			case 'mall':
				camFollow.y = boyfriend.getMidpoint().y - 200;
			case 'school' | 'schoolEvil':
				camFollow.x = boyfriend.getMidpoint().x - 200;
				camFollow.y = boyfriend.getMidpoint().y - 200;
			case 'iAmJUNKING':
				camFollow.y = boyfriend.getMidpoint().y - 230;
		}

		if (sheShed == 'tutorial' || sheShed == 'interrogation')
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}

		gspotTurn = false;
	}

	function follow(spr:Character):Void
	{
		switch (spr.curCharacter)
		{
			case 'gandhi':
				camFollow.setPosition(spr.getMidpoint().x + 30, spr.getMidpoint().y - 50);
				gspotCamZoom = 1.3;
			case 'bonbon':
				camFollow.y = spr.getMidpoint().y + 200;
			case 'senpai' | 'senpai-angry':
				camFollow.y = spr.getMidpoint().y - 430;
				camFollow.x = spr.getMidpoint().x - 100;
			case 'namebe':
				camFollow.x = spr.getMidpoint().x + 300;
			case 'babbys':
				camFollow.setPosition(spr.getMidpoint().x - 320, spr.getMidpoint().y - 195);
			case 'monkey-sprite':
				camFollow.setPosition(spr.getMidpoint().x, spr.getMidpoint().y - 200);
			case 'pronun':
				camFollow.y = spr.getMidpoint().y - 105;
			case 'flandre-cool-awesome':
				camFollow.y = spr.getMidpoint().y - 175;
		}
	}

	function updateRichPresence():Void
	{
		paly2 = SONG.player2;
		paly3 = SONG.player3;

		if (paly2 == '')
			paly2 = 'null';
		if (paly3 == '')
			paly3 = 'null';

		if (SONG.player3 == 'invisible')
		{
			if (healthBar.percent < 20)
				DiscordClient.changePresence("LOSING TO " + paly2.toUpperCase() + "; LAUGH AT THIS PERSON (oh yea btw " + sheShed + " is playing in the background)", null, 'sussy', 'racialdiversity');
			else if (healthBar.percent > 80)
				DiscordClient.changePresence("Winning in a racial arguement against " + paly2 + " to the tune of " + sheShed + "!", null, 'sussy', 'racialdiversity');
			else
				DiscordClient.changePresence("Discussing racial things with " + paly2 + " to the tune of " + sheShed, null, 'sussy', 'racialdiversity');
		}		
		else if (SONG.player3 == SONG.player2)
		{
			if (healthBar.percent < 20)
				DiscordClient.changePresence("LOSING TO TWICE THE " + paly2.toUpperCase() + "; LAUGH AT THIS PERSON (oh yea btw " + sheShed + " is playing in the background)", null, 'sussy', 'racialdiversity');
			else if (healthBar.percent > 80)
				DiscordClient.changePresence("Winning in a racial arguement against twice the " + paly2 + " to the tune of " + sheShed + "!", null, 'sussy', 'racialdiversity');
			else
				DiscordClient.changePresence("Discussing racial things with twice the " + paly2 + " to the tune of " + sheShed, null, 'sussy', 'racialdiversity');
		}
		else
		{
			if (healthBar.percent < 20)
				DiscordClient.changePresence("LOSING TO " + paly2.toUpperCase() + " AND " + paly3.toUpperCase() + "; LAUGH AT THIS PERSON (oh yea btw " + sheShed + " is playing in the background)", null, 'sussy', 'racialdiversity');
			else if (healthBar.percent > 80)
				DiscordClient.changePresence("Winning in a racial arguement against " + paly2 + " and " + paly3 + " to the tune of " + sheShed + "!", null, 'sussy', 'racialdiversity');
			else
				DiscordClient.changePresence("Discussing racial things with " + paly2 + " and " + paly3 + " to the tune of " + sheShed, null, 'sussy', 'racialdiversity');
		}
	}

	private function tweenIcons():Void
	{
		FlxTween.cancelTweensOf(iconP1);
		iconP1.scale.set(1.3, 1.3);
		FlxTween.tween(iconP1, {"scale.x": 1, "scale.y": 1}, Conductor.stepCrochet / 500, {ease: FlxEase.cubeOut});

		FlxTween.cancelTweensOf(iconP2);
		iconP2.scale.set(1.3, 1.3);
		FlxTween.tween(iconP2, {"scale.x": 1, "scale.y": 1}, Conductor.stepCrochet / 500, {ease: FlxEase.cubeOut});
	}

	private function checkBpmChange(secNum:Int)
	{
		if (SONG.notes[secNum].changeBPM)
		{
			Conductor.changeBPM(SONG.notes[secNum].bpm);
			FlxG.log.add('CHANGED BPM!');
		}
		else
			Conductor.changeBPM(SONG.bpm);
	}

	private function makeNpcsDance():Void
	{
		// Dad doesnt interupt his own notes
		if (SONG.notes[sectionNum].mustHitSection)
		{
			if (SONG.player2 == 'monkey-sprite')
			{
				if (FlxG.random.bool(10) && dad.animation.curAnim.name != 'spin' && monkeyCoolDown > 8)
				{
					dad.playAnim('spin', true);
					monkeyCoolDown = 0;
				}	
				else if (dad.animation.curAnim.name == 'spin' && dad.animation.curAnim.finished || dad.animation.curAnim.name != 'spin')
				{
					dad.dance();
					monkeyCoolDown++;
				}
			}
			else
				dad.dance();
			gspot.dance();
			gaming.dance();
		}
		else
		{
			if (SONG.notes[sectionNum].gspotAnim)
			{
				dad.dance();
				gaming.dance();
			}
			else
				gspot.dance();
		}
	}

	private function stageSpecificBeatHit():Void
	{
		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'bonbon-loool' && curBeat >= 168 && curBeat <= 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (sheShed == 'chuckie' && curBeat > 243 && curBeat < 299 && camZooming && FlxG.camera.zoom < 1.35) // im so tired rn lol i literally cannot be asked to code good
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (totalBeats % 8 == 7 && curSong == 'Job-Interview')
		{
			boyfriend.playAnim('hey', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gaming')
			{
				dad.playAnim('cheer', true);
			}
		}

		switch (curStage)
		{
			case 'schoolEvil':
				for (bf in sway)
				{
					bf.animation.play(Std.string(totalBeats % 2 == 0));
					if (FlxG.random.bool(5))
						FlxTween.tween(bf, {x: FlxG.random.int(0, FlxG.width), y: FlxG.random.int(0, FlxG.height)}, Conductor.crochet * 0.001, {ease: FlxEase.circOut});
				}
			case 'school':
				bgGirls.dance();

			case 'your-stage':
				if (theBoolYouMade == true)
				{
					// bopping code here
				}
				theBoolYouMade = !theBoolYouMade;

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'spookyscary':
                pogBabby.animation.play('pog',true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
				gamingBop.animation.play('bop');
            case 'nadalyn':
                grpLimoNadders.forEach(function(dancerNad:BackgroundNadders)
				{
					dancerNad.danceNad();
				});
			case 'flynets':
				if (areTheirDogs)
				{
					grpGuardDogs.forEach(function(dog:GuardDogs)
					{
						dog.dance(sheShed);
					});
				}
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (totalBeats % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'namebe':
				if (sheShed == 'namebe' || sheShed == 'bouncy-drop')
                    sun.y += 0.35;
				else
				{
					wolves.forEach(function(wolfyWannaCry:FlxSprite){
						wolfyWannaCry.animation.play(totalBeats % 2 == 0 ? 'danceRIGHT' : 'danceLEFT');
					});
				}
			case 'bustom':
				if (sheShed == 'bustom-source')
				{
					switch (curBeat)
					{
						case 15 | 111 | 131 | 207:
							new FlxTimer().start(0.001, function(tmr:FlxTimer)
							{
								dad.playAnim('weird');
							});
					}
				}
			case 'iAmJUNKING':
				if (!remMoving)
					remCoolDown++;

				if (totalBeats % 8 == 4 && FlxG.random.bool(10) && !remMoving && remCoolDown > 10)
				{
					moveRem();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	function iconJunk():Void
	{
		if (FlxG.keys.justPressed.NINE)
		{
			if (iconJunky)
				iconP1.loadIcon(SONG.player1);
			else
				iconP1.loadIcon('bf-old');

			iconJunky = !iconJunky;
		}

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.play('losing');
		else
			iconP1.animation.play('normal');

		if (healthBar.percent > 80)
			iconP2.animation.play('losing');
		else
			iconP2.animation.play('normal');
	}

	function checkNonGameplayButtons():Void
	{
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new ChartingState());

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));

		if (FlxG.keys.justPressed.SIX)
			FlxG.switchState(new AnimationDebug(SONG.player1));

		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function addQuickWatches():Void
	{
		FlxG.watch.addQuick("beatShit", totalBeats);
		FlxG.watch.addQuick("curSection", sectionNum);
		FlxG.watch.addQuick("sectionInfo", curSection);
		if (curSection != null)
			FlxG.watch.addQuick("sectionLength", curSection.lengthInSteps);
		FlxG.watch.addQuick("stepInSection", sectionStep);
	}

	function checkFrames():Void
	{
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
				{
					sectionNum = 0;
					startSong();
				}
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}
	}

	function cameraJunk():Void
	{
		if (generatedMusic && curSection != null && !inCutscene)
		{
			if (camFollow.x != dad.getMidpoint().x + 150 && !curSection.mustHitSection)
				camFollowDad();

			if (curSection.mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
				camFollowBF();
		}

		if (camZooming)
		{
			if (!gspotTurn)
			{
				FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.975);
				camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.975);
			}
			else
			{
				FlxG.camera.zoom = FlxMath.lerp(gspotCamZoom, FlxG.camera.zoom, 0.975);
				camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.975);
			}
		}
	}

	function stageSpecificUpdate(elapsed:Float):Void
	{
		if (curStage == 'water')
			wiggleShit.update(elapsed);

		if (sheShed == 'destructed' && stars != null)
			stars.x -= 0.05/(120/60);

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		if (curSong == 'Fresh')
		{
			switch (totalBeats)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (totalBeats)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit
	}

	function noteJunk():Void
	{
		otherStrums.forEach(function(poop:FlxSprite)
		{
			if (poop.animation.curAnim.name == 'confirm' && poop.animation.curAnim.curFrame >= 6 && !curStage.startsWith('school') ||
				poop.animation.curAnim.name == 'confirm' && poop.animation.curAnim.curFrame >= 3 && curStage.startsWith('school'))
			{
				poop.animation.play('static', true);
				poop.centerOffsets();
			}
		});

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
				if (whatInputSystem == 'RadicalOne')
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.tooLate)
						{
							daNote.active = false;
							daNote.visible = false;
						}
						else
						{
							daNote.visible = true;
							daNote.active = true;
						}

						if (!daNote.mustPress && daNote.wasGoodHit)
						{
							if (SONG.song != 'Tutorial' && SONG.song != 'Interrogation')
								camZooming = true;

							var altAnim:String = "";
							var gspotAnim:String = "";
							var dontplayAnim:String = "";

							if (SONG.notes[sectionNum] != null)
							{
								if (SONG.notes[sectionNum].altAnim)
									altAnim = '-alt';
								if (SONG.notes[sectionNum].gspotAnim)
									gspotAnim = '-gspot';
								if (SONG.notes[sectionNum].dontplayAnim)
									dontplayAnim = '-dontplay';
							}

							//trace("DA ALT THO?: " + SONG.notes[sectionNum].altAnim);

							animateCharacters(daNote, altAnim, gspotAnim, dontplayAnim);

							dad.holdTimer = 0;
							gspot.holdTimer = 0;

							if (SONG.needsVoices)
								vocals.volume = 1;

							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}

						if (FlxG.save.data.downscroll)
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));

						// WIP interpolation shit? Need to fix the pause issue
						// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

						if (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll)
						{
							if (daNote.tooLate || !daNote.wasGoodHit)
							{
								health -= 0.0475;
								vocals.volume = 0;
								if (combo > 5)
									gf.playAnim('sad');
								combo = 0;
								if (!justMissed)
								{
									misses++;
									justMissed = true;
								}	
							}

							daNote.active = false;
							daNote.visible = false;

							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
							if (!daNote.isSustainNote)
								totalNotes++;
						}
					});
				}
				else if (whatInputSystem == 'Kade Engine')
				{
					notes.forEachAlive(function(daNote:Note)
					{	
						if (daNote.y > FlxG.height)
						{
							daNote.active = false;
							daNote.visible = false;
						}
						else
						{
							daNote.visible = true;
							daNote.active = true;
						}
		
						if (!daNote.mustPress && daNote.wasGoodHit)
						{
							if (SONG.song != 'Tutorial' && SONG.song != 'Interrogation')
								camZooming = true;
		
							var altAnim:String = "";
							var gspotAnim:String = "";
							var dontplayAnim:String = "";

							if (SONG.notes[sectionNum] != null)
							{
								if (SONG.notes[sectionNum].altAnim)
									altAnim = '-alt';
								if (SONG.notes[sectionNum].gspotAnim)
									gspotAnim = '-gspot';
								if (SONG.notes[sectionNum].dontplayAnim)
									dontplayAnim = '-dontplay';
							}
		
							animateCharacters(daNote, altAnim, gspotAnim, dontplayAnim);
		
							dad.holdTimer = 0;
							gspot.holdTimer = 0;
		
							if (SONG.needsVoices)
								vocals.volume = 1;
		
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
		
						if (FlxG.save.data.downscroll)
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						//trace(daNote.y);
						// WIP interpolation shit? Need to fix the pause issue
						// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
		
						if (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll)
						{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								noteMissKade(daNote.noteData);
							}
		
							daNote.active = false;
							daNote.visible = false;
		
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
							if (!daNote.isSustainNote)
								totalNotes++;
						}
					});
				}
				else if (whatInputSystem == 'FNF Pre Week 5')
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.y > FlxG.height)
						{
							daNote.active = false;
							daNote.visible = false;
						}
						else
						{
							daNote.visible = true;
							daNote.active = true;
						}

						if (!daNote.mustPress && daNote.wasGoodHit)
						{
							if (SONG.song != 'Tutorial' && SONG.song != 'Interrogation')
								camZooming = true;

							var altAnim:String = "";
							var gspotAnim:String = "";
							var dontplayAnim:String = "";

							if (SONG.notes[sectionNum] != null)
							{
								if (SONG.notes[sectionNum].altAnim)
									altAnim = '-alt';
								if (SONG.notes[sectionNum].gspotAnim)
									gspotAnim = '-gspot';
								if (SONG.notes[sectionNum].dontplayAnim)
									dontplayAnim = '-dontplay';
							}
		
							animateCharacters(daNote, altAnim, gspotAnim, dontplayAnim);

							dad.holdTimer = 0;
							gspot.holdTimer = 0;

							if (SONG.needsVoices)
								vocals.volume = 1;

							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}

						if (FlxG.save.data.downscroll)
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						// WIP interpolation shit? Need to fix the pause issue
						// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

						if (daNote.y < -daNote.height)
						{
							if (daNote.tooLate || !daNote.wasGoodHit)
							{
								health -= 0.045;
								vocals.volume = 0;
								misses++;
							}

							daNote.active = false;
							daNote.visible = false;

							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
							if (!daNote.isSustainNote)
								totalNotes++;
						}
					});
				}
				else if (whatInputSystem == 'FPS Plus')
				{
					notes.forEachAlive(function(daNote:Note)
						{
							/*if (daNote.y > FlxG.height)
							{
								daNote.active = false;
								daNote.visible = false;
							}
							else
							{
								daNote.visible = true;
								daNote.active = true;
							}*/
			
							if (!daNote.mustPress && daNote.wasGoodHit)
							{
								if (SONG.song != 'Tutorial' && SONG.song != 'Interrogation')
									camZooming = true;
	
								var altAnim:String = "";
								var gspotAnim:String = "";
								var dontplayAnim:String = "";
	
								if (SONG.notes[sectionNum] != null)
								{
									if (SONG.notes[sectionNum].altAnim)
										altAnim = '-alt';
									if (SONG.notes[sectionNum].gspotAnim)
										gspotAnim = '-gspot';
									if (SONG.notes[sectionNum].dontplayAnim)
										dontplayAnim = '-dontplay';
								}
			
								animateCharacters(daNote, altAnim, gspotAnim, dontplayAnim);
	
								dad.holdTimer = 0;
								gspot.holdTimer = 0;
			
								if (SONG.needsVoices)
									vocals.volume = 1;
			
								daNote.destroy();
							}
			
							if(FlxG.save.data.downscroll){
								daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
							}
							else {
								daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
							}
			
							// WIP interpolation shit? Need to fix the pause issue
							// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
			
			
							//MOVE NOTE TRANSPARENCY CODE BECAUSE REASONS 
							if(daNote.tooLate){
			
								if (daNote.alpha > 0.3){
			
										noteMissPlus(daNote.noteData, 0.055, false, true);
										vocals.volume = 0;
			
									daNote.alpha = 0.3;
					
								}
			
							}
			
							//Guitar Hero Type Held Notes
							if(daNote.isSustainNote && daNote.mustPress){
			
								if(daNote.prevNote.tooLate){
									daNote.tooLate = true;
									daNote.destroy();
								}
				
								if(daNote.prevNote.wasGoodHit){
									
									var upP = controls.UP;
									var rightP = controls.RIGHT;
									var downP = controls.DOWN;
									var leftP = controls.LEFT;
				
									switch(daNote.noteData){
										case 0:
											if(!leftP){
												noteMissPlus(0, 0.03, true, true);
												vocals.volume = 0;
												daNote.tooLate = true;
												daNote.destroy();
											}
										case 1:
											if(!downP){
												noteMissPlus(1, 0.03, true, true);
												vocals.volume = 0;
												daNote.tooLate = true;
												daNote.destroy();
											}
										case 2:
											if(!upP){
												noteMissPlus(2, 0.03, true, true);
												vocals.volume = 0;
												daNote.tooLate = true;
												daNote.destroy();
											}
										case 3:
											if(!rightP){
												noteMissPlus(3, 0.03, true, true);
												vocals.volume = 0;
												daNote.tooLate = true;
												daNote.destroy();
											}
									}
								}
							}
			
							if (FlxG.save.data.downscroll ? (daNote.y > strumLine.y + daNote.height + 50) : (daNote.y < strumLine.y - daNote.height - 50))
							{
			
									if (daNote.tooLate){
											
										daNote.active = false;
										daNote.visible = false;
						
										daNote.destroy();
					
									}
			
								
							}
						});
				}
		}
	}

	function checkDeath():Void
	{
		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
	}

	function initVars():Void
	{
		trace(Controls.realControls);

		trace('https://www.youtube.com/watch?v=iik25wqIuFo');
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		whatInputSystem = FlxG.save.data.inputSystem;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		invulnCount = 0;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.changeBPM(SONG.bpm);

		sheShed = SONG.song.toLowerCase();

		/*			'limo', 
			'mall', 'mallEvil', 'nunjunk', 
			'bustom',*/

		var allThemStages:Array<String> = [
			'spooky', 'spookyscary', 
			'flynets', 
			'water', 
			'junk', 
			'3.4', 
			'nadalyn', 
			'philly', 
			'pit', 
			'freebeat', 
			'home', 
			'school', 'schoolEvil',  
			'iAmJUNKING', 
			'stage', 
			'scribble', 
			'junkers', 
			'picnic',
			'susmeal',
			'namebe',
			'rumble',
			'dreaming',
			'dawgee',
			'interview'
		];

		if (!randomLevel)
		{
			switch(sheShed)
			{
				case 'radical-vs-masked-babbys' | 'north':
					curStage = "spooky";
				case 'monkey-sprite':
					curStage = "spookyscary";
				case 'the-backyardagains' | 'funny':
					curStage = "flynets";
				case 'interrogation':
					curStage = 'water';
				case 'junkrus':
					curStage = 'junk';
				case 'dream':
					curStage = 'dreaming';
				case 'dawgee-want-food':
					curStage = 'dawgee';
				case '3.4':
					curStage = '3.4';
				case 'nadalyn-sings-spookeez' | 'nadbattle' | 'nadders':
					curStage = 'nadalyn';
				case 'namebe' | 'bouncy-drop' | 'destructed':
					curStage = 'namebe';
				case 'start-conjunction' | 'energy-lights' | 'telegroove':
					curStage = 'philly';
				case 'tha-biscoot':
					curStage = 'pit';
				case 'freebeat_1':
					curStage = 'freebeat';
				case 'bonbon-loool' | 'bonnie-song' | 'without-you':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'gamings-congrats' | 'tutorial' | 'chuckie':
					curStage = 'home';
				case 'color-my-bonbon':
					curStage = 'bonbon-prep';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'ceast':
					curStage = 'nunjunk';
				case 'bustom-source' | 'fl-keys' | 'i-didnt-ask':
					curStage = 'bustom';
				case 'scary-junk':
					curStage = 'iAmJUNKING';
				case 'scribble-street':
					curStage = 'scribble';
				case 'weird-junk-wtf':
					curStage = 'junkers';
				case 'picnic-rumble':
					curStage = 'picnic';
				case 'among-us-happy-meal':
					curStage = 'susmeal';
				case 'thanos-rumble':
					curStage = 'rumble';
				case 'job-interview':
					curStage = 'interview';
				case 'normal-ghost':
					curStage = 'blank';
				default:
					curStage = 'stage';
			}
		}
		else
			curStage = allThemStages[FlxG.random.int(0, allThemStages.length)];
	}

	function initDialog():Void
	{
		if (songsWithDialogue.contains(sheShed))
		{
			switch (sheShed)
			{
				case 'tutorial':
					dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
				case 'bopeebo':
					dialogue = [
						'HEY!',
						"You think you can just sing\nwith my daughter like that?",
						"If you want to date her...",
						"You're going to have to go \nthrough ME first!"
					];
				case 'fresh':
					dialogue = ["Not too shabby boy.", ""];
				case 'dadbattle':
					dialogue = [
						"gah you think you're hot stuff?",
						"If you can beat me here...",
						"Only then I will even CONSIDER letting you\ndate my daughter!"
					];
				case 'senpai':
					dialogue = CoolUtil.coolTextFile('assets/data/senpai/senpaiDialogue.txt');
				case 'roses':
					dialogue = CoolUtil.coolTextFile('assets/data/roses/rosesDialogue.txt');
				case 'thorns':
					dialogue = CoolUtil.coolTextFile('assets/data/thorns/thornsDialogue.txt');
				case 'radical-vs-masked-babbys':
					setDialogue('masked-babbys');
				case 'bouncy-drop':
					setDialogue('fnaf-philly');
				case 'the-backyardagains':
					setDialogue('flynets1');
				case 'funny':
					setDialogue('flynets2');
				default:
					setDialogue(sheShed);
			}
		}
	}

	var curLight:Int = 0;
	var gspotCamZoom:Float = 1;
	var gspotTurn:Bool = false;
}
