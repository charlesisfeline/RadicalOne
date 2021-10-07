package;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'radical';
	var radicalChar = FreeplayState.curChar;

	public var holdTimer:Float = 0;

	public static var charPath:String = 'assets/images/characters/';

	/*public static var charArray:Array<String> = [
		'radical', 'gaming-speakers',
		'interviewer', 'machine',
		'babbys', 'monkey-sprite', 
		'namebe', 'gandhi', 
		'bonbon', 'gaming', 
		'four', 'x', 'christmas-monkey', 
		'invisible', '',
		'salted', 
		'wow', 'wow2',
		'austin', 
		'senpai', 'senpai-angry', 
		'pronun', 
		'charlie', 
		'skank', 'goomba', 'flandre-cool-awesome', 'nadalyn', 'failure', 'red-ball', 'dadamono', '3.4', 'stick', 'skank-n-pronoun', 'junkers', 'pic-nick', 'pc', 'thanos-dad', 'community-night-funkin'
	];*/

	public static var charArray:Array<String> = [
		'radical', 'gaming-speakers',
		'interviewer', 'machine',
		'babbys', 'monkey-sprite', 
		'namebe', 'namebe-piss', 'gandhi', 'gaming-namebe', 
		'gaming',
		'invisible', '',
		'salted', 
		'wow', 'wow2',
		'austin', 
		'senpai', 'senpai-angry',  
		'skank', 'goomba', 'flandre-cool-awesome', // jo junk
		'nadalyn', 'failure', 'red-ball', 
		'dadamono', '3.4', 'stick', 
		'skank-n-pronoun', 'junkers', 'pic-nick', 
		'pc', 'thanos-dad', 'community-night-funkin', // end jo junk
		'i-hate-you-lancey', 'red-ball-dream', 'failure-dream', 
		'dawgee', 'joe-bidens-dog', 'nerd', 'spoar-man' // yeah no jo junk is still going on im NOT moving these over
	];

	public function new(x:Float, y:Float, ?character:String = "radical", ?isPlayer:Bool = false)
	{
		animOffsets = new Map<String, Array<Dynamic>>();
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;
		trace(curCharacter);

		if (curCharacter == '')
			curCharacter = 'radical';

		switch (curCharacter)
		{
			case 'gaming-speakers':
				// GIRLFRIEND CODE
				tex = FlxAtlasFrames.fromSparrow(charPath + 'Gaming_assets.png', charPath + 'Gaming_assets.xml');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 18, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 18, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 50, 71);
				addOffset('danceRight', 50, 71);

				addOffset("singUP", 48, 106);
				addOffset("singRIGHT", 48, 71);
				addOffset("singLEFT", 48, 75);
				addOffset("singDOWN", 48, 71);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'gaming-namebe':
				getFrames(switch (PlayState.sheShed) {
					case 'namebe':
						'Gaming_Sunny_Day';
					case 'destructed':
						'Gaming_Night_Time';
					default:
						'Gaming_Summer_Mood';
				});
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 18, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 18, false);

				playAnim('danceRight');

				if (PlayState.sheShed == 'destructed')
					y += 27 + 52;

			case 'gaming-gunpoint':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'Gaming_Gunpoint.png', charPath + 'Gaming_Gunpoint.xml');
				frames = tex;
				animation.addByIndices('danceLeft', 'Gaming GROOVING?!?', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Gaming GROOVING?!?', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');
			case 'namebe-speakers':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'Namebe_Speakers.png', charPath + 'Namebe_Speakers.xml');
				frames = tex;
				animation.addByIndices('danceLeft', 'Namebe Speakers Twirl', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Namebe Speakers Twirl', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				playAnim('danceRight');
			case 'jack':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'jack.png', charPath + 'jack.xml');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'interviewer':
				// DAD ANIMATION LOADING CODE
				tex = FlxAtlasFrames.fromSparrow(charPath + 'Interviewer.png', charPath + 'Interviewer.xml');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'thanos-dad':
				// DAD ANIMATION LOADING CODE
				getFrames('THANOS_DAD');
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
            case 'gaming':
                frames = FlxAtlasFrames.fromSparrow(charPath + 'gamingChar.png', charPath + 'gamingChar.xml');
                animation.addByPrefix('idle', 'gamingLeft', 24, false);
                animation.addByPrefix('singUP', 'upAnim', 24, false);
                animation.addByPrefix('singDOWN', 'downAnim', 24, false);
                animation.addByPrefix('singLEFT', 'leftAnim', 24, false);
                animation.addByPrefix('singRIGHT', 'rightAnim', 24, false);
                                
                addOffset('idle');
				addOffset('singUP', 100, 75);
				addOffset('singRIGHT', -10, 0);
				addOffset('singLEFT');
				addOffset('singDOWN');
				
				if (!isPlayer)
					flipX = true;
			case 'invisible':
            	tex = FlxAtlasFrames.fromSparrow('assets/data/ridge/sus_books.png', charPath + 'sus.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				visible = false;
				addOffset('idle', 9048753, 329847);
				playAnim('idle');
            case 'nadalyn':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'nadalyn.png', charPath + 'nadalyn.xml');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft', -20, 0);
				addOffset('danceRight', -20, 0);

				addOffset("singUP", -20, 0);
				addOffset("singRIGHT", -20, 0);
				addOffset("singLEFT", -20, 0);
				addOffset("singDOWN", -20, 0);

				playAnim('danceRight');
            case 'machine':
                    tex = FlxAtlasFrames.fromSparrow(charPath + 'machine_assets.png', charPath + 'machine_assets.xml');
                    frames = tex;
                                
                    animation.addByPrefix('idle', "idle", 24, false);
                    animation.addByPrefix('singUP', "up", 24, false);
                    animation.addByPrefix('singDOWN', "down", 24, false);
                    animation.addByPrefix('singLEFT', "left", 24, false);
                    animation.addByPrefix('singRIGHT', "right", 24, false);
                                
                    playAnim('idle');
                                
 					addOffset('idle');
					addOffset("singUP", -10, 4);
					addOffset("singRIGHT", -9, 21);
					addOffset("singLEFT", 44, 23);
					addOffset("singDOWN", -5, -129);

            case 'salted':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'Beans.png', charPath + 'Beans.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				playAnim('idle');
				addOffset('idle');
				addOffset("singUP", 89, 54);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 580, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				if (!isPlayer)
					flipX = true;

            case 'wow2':
				tex = FlxAtlasFrames.fromSparrow('assets/data/ridge/sus_books.png', charPath + 'sus.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

                /*animation.addByPrefix('singLEFT-gspot', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT-gspot', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);  */

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				playAnim('idle');
				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				if (!isPlayer)
					flipX = true;
					
			case 'wow':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'sus.png', charPath + 'sus.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
					
					animation.addByPrefix('singLEFT-gspot', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT-gspot', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singUP-gspot', 'pico Up note0', 24, false);
					animation.addByPrefix('singDOWN-gspot', 'Pico Down Note0', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				playAnim('idle');
				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUP-gspot", -29, 27);
				addOffset("singRIGHT-gspot", -68, -7);
				addOffset("singLEFT-gspot", 65, 9);
				addOffset("singDOWN-gspot", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				if (!isPlayer)
					flipX = true;
			case 'goomba':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'goomba_dude.png', charPath + 'goomba_dude.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					
				}

				playAnim('idle');
				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);

				if (!isPlayer)
					flipX = true;
			case 'stick':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'Stick_Man.png', charPath + 'Stick_Man.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
					{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				}
				else
					{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					
				}
				
				playAnim('idle');
				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				
				if (!isPlayer)
					flipX = true;
			case 'pic-nick':
				getFrames('Pic-Nick');
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
					{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				}
				else
					{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					
				}
				
				playAnim('idle');
				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				
				if (!isPlayer)
					flipX = true;
			case 'pc':
				getFrames('pc');
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
					{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				}
				else
					{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					
				}
				
				playAnim('idle');
				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				
				if (!isPlayer)
					flipX = true;
            case 'gandhi':
				// DAD ANIMATION LOADING CODE
				tex = FlxAtlasFrames.fromSparrow(charPath + 'G_Spot.png', charPath + 'G_Spot.xml');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'dadamono':
				// DAD ANIMATION LOADING CODE
				getFrames('Dadamono');
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'junkers':
				// DAD ANIMATION LOADING CODE
				getFrames('JUNKERS');
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case '3.4':
				// DAD ANIMATION LOADING CODE
				getFrames('3.4');
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'babbys':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'MINECRAFT_BABBYS.png', charPath + 'MINECRAFT_BABBYS.xml');
				frames = tex;
				animation.addByPrefix('singUP', 'babby up', 24, false);
				animation.addByPrefix('singDOWN', 'babby down', 24, false);
				animation.addByPrefix('singLEFT', 'babby left', 24, false);
				animation.addByPrefix('singRIGHT', 'babby right', 24, false);
				animation.addByIndices('danceLeft', 'babby idle', [6, 0, 2, 4], "", 12, false);
				animation.addByIndices('danceRight', 'babby idle', [14, 8, 10, 12], "", 12, false);
				animation.addByPrefix('cutscene', 'babby cutscene', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", 28, 37);
				addOffset("singRIGHT", -11, 9);
				addOffset("singLEFT", 172, 14);
				addOffset("singDOWN", 54, -95);
				addOffset('cutscene', 931, 82);

				playAnim('danceRight');

			case 'skank-n-pronoun':
				getFrames('Skank_and_Pronoun');
				spookyCharacter();
			case 'skank':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'skank_himself.png', charPath + 'skank_himself.xml');
				frames = tex;
				spookyCharacter();
			case 'i-hate-you-lancey':
				getFrames('spooky_kids_assets', 'Skank_and_Pronoun');
				spookyCharacter();
			case 'dawgee':
				getFrames('dawgee', 'Skank_and_Pronoun');
				spookyCharacter();
			case 'austin':
					tex = FlxAtlasFrames.fromSparrow(charPath + 'austin.png', charPath + 'austin.xml');
					frames = tex;
					animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
					animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
					animation.addByPrefix('singLEFT', 'note sing left', 24, false);
					animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
					animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
					animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);
					animation.addByPrefix('introSpin', 'spinny intro', 24, false);
	
					addOffset('danceLeft');
					addOffset('danceRight');
	
					addOffset("singUP", 9, 50);
					addOffset("singRIGHT", -28, 20);
					addOffset("singLEFT", 187, 54);
					addOffset("singDOWN", 170, -270);
					addOffset('introSpin', 2065, 1637);
	
					playAnim('danceRight');
			case 'bonbon':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'Red_Bon.png', charPath + 'Red_Bon.xml');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monkey-sprite':
				getFrames('Monkey_Sprite');
				setNormalAnimsLeftRight([
					'monkey idle ooh ooh aah aah',
					'MONKEY SCREAMING WOOWAHAHA',
					'MONKEY DOWN',
					'mokey left',
					'monkey is right ya know'
				], [
					[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 
					[15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
				]);

				animation.addByPrefix('spin', 'MONKEY GO SPEEEEN', 24, false);
				animation.addByPrefix('drop', 'monkey drop full', 24, false);

				setOffsets([
					[0, 0],
					[0, 0],
					[100, 70],
					[102, 172],
					[16, 55],
					[16, 32],
				], true);

				addOffset('spin', -22, 43);
				addOffset('drop', 108, 772);

				playAnim('danceRight');
			case 'failure':
				getFrames('Spoar_Man');

				setNormalAnims([
					'monster idle',
					'monster up note',
					'monster down',
					'Monster left note',
					'Monster Right note'
				], false);

				setOffsets([
					[0, 0],
					[-20, 50],
					[-30, -40],
					[-30, 0],
					[-51, 0]
				]);

				playAnim('idle');
			case 'failure-dream':
				getFrames('glow_failure', 'Spoar_Man');

				setNormalAnims([
					'monster idle',
					'monster up note',
					'monster down',
					'Monster left note',
					'Monster Right note'
				], false);

				setOffsets([
					[0, 0],
					[-20, 50],
					[-30, -40],
					[-30, 0],
					[-51, 0]
				]);

				playAnim('idle');
			case 'christmas-monkey':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'monsterChristmas.png', charPath + 'monsterChristmas.xml');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'joe-bidens-dog':
				getFrames('TGOJBDD');
				picoCharacter();
			case 'namebe':
				tex = FlxAtlasFrames.fromSparrow(charPath + 'Namebe.png', charPath + 'Namebe.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				}


				addOffset('idle', 0, 23);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", 2, -87);
				addOffset("singLEFT", 81, 9);
				addOffset("singDOWN", 0, -85);

				playAnim('idle');

				flipX = true;
			case 'namebe-piss':
				getFrames('Namebe_Pissy_Mood');

				setNormalAnims([
					'pissy idle',
					'namebe up',
					'namebe down',
					'namebe left',
					'namebe right'
				], false);

				animation.remove('idle');
				animation.addByPrefix('idle', 'pissy idle', 24, false, true);

				setOffsets([
					[0, 0],
					[-60, 120],
					[0, -50],
					[90, -20],
					[-40, -130]
				]);

				playAnim('idle');
			case 'radical':
			        if (0 == 0) // too lazy to reindent everything LOOL
			        {
            			        switch (FlxG.save.data.outfit)
								{
									case 'Old Radical':
										var tex = FlxAtlasFrames.fromSparrow(charPath + 'OgRacial.png', charPath + 'OgRacial.xml');
										frames = tex;
										animation.addByPrefix('idle', 'BF idle dance', 24, false);
										animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
										animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
										animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
										animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
										animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
										animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
										animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
										animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
										animation.addByPrefix('hey', 'BF HEY', 24, false);

										animation.addByPrefix('firstDeath', "BF dies", 24, false);
										animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
										animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

										animation.addByPrefix('scared', 'BF idle shaking', 24);

										addOffset('idle', -5);
										addOffset("singUP", -29, 27);
										addOffset("singRIGHT", -38, -7);
										addOffset("singLEFT", 12, -6);
										addOffset("singDOWN", -10, -50);
										addOffset("singUPmiss", -29, 27);
										addOffset("singRIGHTmiss", -30, 21);
										addOffset("singLEFTmiss", 12, 24);
										addOffset("singDOWNmiss", -11, -19);
										addOffset("hey", 7, 4);
										addOffset('firstDeath', 37, 11);
										addOffset('deathLoop', 37, 5);
										addOffset('deathConfirm', 37, 69);
										addOffset('scared', -4);

										playAnim('idle');

										flipX = true;
									case 'RedBall':
										var coolOffset:Array<Int> = [124, 236];
										getFrames('radicalball');
										animation.addByPrefix('idle', 'Dad idle dance', 24, false);
										animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
										animation.addByPrefix('singLEFT', 'Dad Sing Note RIGHT', 24, false);
										animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
										animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24, false);

										addOffset('idle', coolOffset[0], coolOffset[1]);
										addOffset("singUP", 6 + coolOffset[0], 50 + coolOffset[1]);
										addOffset("singLEFT", 0 + coolOffset[0], 27 + coolOffset[1]);
										addOffset("singRIGHT", 10 + coolOffset[0], 10 + coolOffset[1]);
										addOffset("singDOWN", 0 + coolOffset[0], -30 + coolOffset[1]);

										playAnim('idle');

										//y -= 215;
										//x -= 57;
									case 'Radical':
										frames = FlxAtlasFrames.fromSparrow(charPath + 'racial.png', charPath + 'racial.xml');
										animation.addByPrefix('idle', 'Racial Spiteful Jig', 24, false);
										animation.addByPrefix('singUP', 'Racial sing UP', 24, false);
										animation.addByPrefix('singDOWN', 'Racial sing DOWN', 24, false);
										animation.addByPrefix('singLEFT', 'Racial sing LEFT', 24, false);
										animation.addByPrefix('singRIGHT', 'Racial sing RIGHT', 24, false);
										animation.addByPrefix('singUPmiss', 'Racial miss UP', 24, false);
										animation.addByPrefix('singDOWNmiss', 'Racial miss DOWN', 24, false);
										animation.addByPrefix('singLEFTmiss', 'Racial miss LEFT', 24, false);
										animation.addByPrefix('singRIGHTmiss', 'Racial miss RIGHT', 24, false);
										animation.addByPrefix('hey', 'Racial Approveds', 24, false);

										animation.addByPrefix('firstDeath', 'RACIAL DEAD??!?!??', 24, false);
										animation.addByPrefix('deathLoop', 'Racial Dead...', 24, true);

										addOffset('idle', 0, 0);
										addOffset('singUP', -17, 99);
										addOffset('singDOWN', 27, -13);
										addOffset('singLEFT', -1, 12);
										addOffset('singRIGHT', -17, 4);
										addOffset('singUPmiss', -17, 99);
										addOffset('singDOWNmiss', 27, -13);
										addOffset('singLEFTmiss', -1, 12);
										addOffset('singRIGHTmiss', -17, 4);
										addOffset("hey", 31, 4);
										addOffset('firstDeath', 34, 22);
										addOffset('deathLoop', 34, 22);

										playAnim('idle');

										flipX = true;
									case 'Business Radical':
										frames = FlxAtlasFrames.fromSparrow(charPath + 'racial-buisiness.png', charPath + 'racial-buisiness.xml');
										animation.addByPrefix('idle', 'Racial Spiteful Jig', 24, false);
										animation.addByPrefix('singUP', 'Racial sing UP', 24, false);
										animation.addByPrefix('singDOWN', 'Racial sing DOWN', 24, false);
										animation.addByPrefix('singLEFT', 'Racial sing LEFT', 24, false);
										animation.addByPrefix('singRIGHT', 'Racial sing RIGHT', 24, false);
										animation.addByPrefix('singUPmiss', 'Racial miss UP', 24, false);
										animation.addByPrefix('singDOWNmiss', 'Racial miss DOWN', 24, false);
										animation.addByPrefix('singLEFTmiss', 'Racial miss LEFT', 24, false);
										animation.addByPrefix('singRIGHTmiss', 'Racial miss RIGHT', 24, false);
										animation.addByPrefix('hey', 'Racial Approveds', 24, false);

										animation.addByPrefix('firstDeath', 'RACIAL DEAD??!?!??', 24, false);
										animation.addByPrefix('deathLoop', 'Racial Dead...', 24, true);

										addOffset('idle', 0, 0);
										addOffset('singUP', -17, 99);
										addOffset('singDOWN', 27, -13);
										addOffset('singLEFT', -1, 12);
										addOffset('singRIGHT', -17, 4);
										addOffset('singUPmiss', -17, 99);
										addOffset('singDOWNmiss', 27, -13);
										addOffset('singLEFTmiss', -1, 12);
										addOffset('singRIGHTmiss', -17, 4);
										addOffset("hey", 31, 4);
										addOffset('firstDeath', 34, 22);
										addOffset('deathLoop', 34, 22);

										playAnim('idle');

										flipX = true;
									case 'Racial Pride':
										frames = FlxAtlasFrames.fromSparrow(charPath + 'racial.png', charPath + 'racial.xml');
										animation.addByPrefix('idle', 'Pride Racial Spiteful Jig', 24, false);
										animation.addByPrefix('singUP', 'Pride Racial sing UP', 24, false);
										animation.addByPrefix('singDOWN', 'Pride Racial sing DOWN', 24, false);
										animation.addByPrefix('singLEFT', 'Pride Racial sing LEFT', 24, false);
										animation.addByPrefix('singRIGHT', 'Pride Racial sing RIGHT', 24, false);
										animation.addByPrefix('singUPmiss', 'Pride Racial miss UP', 24, false);
										animation.addByPrefix('singDOWNmiss', 'Pride Racial miss DOWN', 24, false);
										animation.addByPrefix('singLEFTmiss', 'Pride Racial miss LEFT', 24, false);
										animation.addByPrefix('singRIGHTmiss', 'Pride Racial miss RIGHT', 24, false);

										animation.addByPrefix('firstDeath', 'RACIAL DEAD??!?!??', 24, false);
										animation.addByPrefix('deathLoop', 'Racial Dead...', 24, true);

										addOffset('idle', 0, 0);
										addOffset('singUP', -17, 99);
										addOffset('singDOWN', 27, -13);
										addOffset('singLEFT', -1, 12);
										addOffset('singRIGHT', -17, 4);
										addOffset('singUPmiss', -17, 99);
										addOffset('singDOWNmiss', 27, -13);
										addOffset('singLEFTmiss', -1, 12);
										addOffset('singRIGHTmiss', -17, 4);
										addOffset("hey", 31, 4);
										addOffset('firstDeath', 34, 22);
										addOffset('deathLoop', 34, 22);

										playAnim('idle');

										flipX = true;
									case 'RadiFAIL': 
										frames = FlxAtlasFrames.fromSparrow(charPath + 'racial.png', charPath + 'racial.xml');
										animation.addByPrefix('idle', 'Racial Spiteful Jig', 24, false);
										animation.addByPrefix('singUPmiss', 'Racial sing UP', 24, false);
										animation.addByPrefix('singDOWNmiss', 'Racial sing DOWN', 24, false);
										animation.addByPrefix('singLEFTmiss', 'Racial sing LEFT', 24, false);
										animation.addByPrefix('singRIGHTmiss', 'Racial sing RIGHT', 24, false);
										animation.addByPrefix('singUP', 'Racial miss UP', 24, false);
										animation.addByPrefix('singDOWN', 'Racial miss DOWN', 24, false);
										animation.addByPrefix('singLEFT', 'Racial miss LEFT', 24, false);
										animation.addByPrefix('singRIGHT', 'Racial miss RIGHT', 24, false);
										animation.addByPrefix('hey', 'Racial Approveds', 24, false);

										animation.addByPrefix('firstDeath', 'RACIAL DEAD??!?!??', 24, false);
										animation.addByPrefix('deathLoop', 'Racial Dead...', 24, true);

										addOffset('idle', 0, 0);
										addOffset('singUPmiss', -17, 99);
										addOffset('singDOWNmiss', 27, -13);
										addOffset('singLEFTmiss', -1, 12);
										addOffset('singRIGHTmiss', -17, 4);
										addOffset('singUP', -17, 99);
										addOffset('singDOWN', 27, -13);
										addOffset('singLEFT', -1, 12);
										addOffset('singRIGHT', -17, 4);
										addOffset("hey", 31, 4);
										addOffset('firstDeath', 34, 22);
										addOffset('deathLoop', 34, 22);

										playAnim('idle');

										flipX = true;
									case 'Sussy Radical':
										getFrames('SUSSY_RACIAL');
										setNormalAnims([
											'SUSSY RACIAL0',
											'SUSSY RACIAL UP',
											'SUSSY RACIAL DOWN',
											'SUSSY RACIAL LEFT',
											'SUSSY RACIAL RIGHT'
										], false, true, 'MISS');

										setOffsets([
											[0, 0],
											[-36, 39],
											[-14, -7],
											[4, 4],
											[-33, 4],
											[-29, 73],
											[9, 15],
											[4, 23],
											[-33, 15]
										], false, true);

										flipX = true;
									case 'Radical Babby':
										getFrames('babRad');
										setNormalAnims([
											'idle',
											'up',
											'down',
											'left',
											'right'
										], false);

										setOffsets([
											[0, 0],
											[-45, 45],
											[60, -70],
											[74, -17],
											[-67, -15]
										]);

										flipX = true;
								}    
					}
					else
					{
						frames = FlxAtlasFrames.fromSparrow(charPath + 'racial.png', charPath + 'racial.xml');
						animation.addByPrefix('idle', 'Racial Spiteful Jig', 24);
						animation.addByPrefix('singUP', 'Racial sing UP', 24, false);
						animation.addByPrefix('singDOWN', 'Racial sing DOWN', 24, false);
						animation.addByPrefix('singLEFT', 'Racial sing LEFT', 24, false);
						animation.addByPrefix('singRIGHT', 'Racial sing RIGHT', 24, false);
						animation.addByPrefix('singUPmiss', 'Racial miss UP', 24, false);
						animation.addByPrefix('singDOWNmiss', 'Racial miss DOWN', 24, false);
						animation.addByPrefix('singLEFTmiss', 'Racial miss LEFT', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'Racial miss RIGHT', 24, false);
						animation.addByPrefix('hey', 'Racial Approveds', 24, false);

						animation.addByPrefix('firstDeath', 'RACIAL DEAD??!?!??', 24, false);
						animation.addByPrefix('deathLoop', 'Racial Dead...', 24, true);

						addOffset('idle', 0, 0);
						addOffset('singUP', -17, 99);
						addOffset('singDOWN', 27, -13);
						addOffset('singLEFT', -1, 12);
						addOffset('singRIGHT', -17, 4);
						addOffset('singUPmiss', -17, 99);
						addOffset('singDOWNmiss', 27, -13);
						addOffset('singLEFTmiss', -1, 12);
						addOffset('singRIGHTmiss', -17, 4);
						addOffset("hey", 31, 4);
						addOffset('firstDeath', 34, 22);
						addOffset('deathLoop', 34, 22);

						playAnim('idle');

						flipX = true;
					}
			case 'bf-pixel':
				frames = FlxAtlasFrames.fromSparrow(charPath + 'bfPixel.png', charPath + 'bfPixel.xml');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = FlxAtlasFrames.fromSparrow(charPath + 'bfPixelsDEAD.png', charPath + 'bfPixelsDEAD.xml');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = FlxAtlasFrames.fromSparrow(charPath + 'senpai_wow.png', charPath + 'senpai_wow.xml');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = FlxAtlasFrames.fromSparrow(charPath + 'senpai_wow.png', charPath + 'senpai_wow.xml');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = FlxAtlasFrames.fromSpriteSheetPacker(charPath + 'spirit.png', charPath + 'spirit.txt');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

            	case 'four':
                    frames = FlxAtlasFrames.fromSparrow(charPath + 'Four_Assets.png', charPath + 'Four_Assets.xml');
                    animation.addByPrefix('idle', 'Four Grroovy Idle', 24);
                    animation.addByPrefix('singUP', 'Four Sing UP', 24, false);
                    animation.addByPrefix('singDOWN', 'Four Sing DOWN', 24, false);
                    animation.addByPrefix('singLEFT', 'Four Sing LEFT', 24, false);
                    animation.addByPrefix('singRIGHT', 'Four Sing RIGHT', 24, false);

                    addOffset('idle', 0, 0);
                    addOffset('singUP', -117, -8);
                    addOffset('singDOWN', -38, 237);
                    addOffset('singLEFT', -66, -88);
                    addOffset('singRIGHT', -121, -22);

                    playAnim('idle');

                case 'x':
                	frames = FlxAtlasFrames.fromSparrow(charPath + 'X.png', charPath + 'X.xml');
                	animation.addByPrefix('idle', 'X Lovely Idle', 24);
                    animation.addByPrefix('singUP-alt', 'X Sing UP', 24, false);
                    animation.addByPrefix('singDOWN-alt', 'X Sing DOWN', 24, false);
                    animation.addByPrefix('singLEFT-alt', 'X Sing LEFT', 24, false);
                    animation.addByPrefix('singRIGHT-alt', 'X Sing RIGHT', 24, false);

                    addOffset('idle', 0, 4);
                    addOffset('singUP-alt', 13, 78);
                    addOffset('singDOWN-alt', -28, 7);
                    addOffset('singLEFT-alt', 214, 144);
                    addOffset('singRIGHT-alt', -71, 61);

                    playAnim('idle');

                case 'racial':
                    frames = FlxAtlasFrames.fromSparrow(charPath + 'racial.png', charPath + 'racial.xml');
                    animation.addByPrefix('idle', 'Racial Spiteful Jig', 24);
                    animation.addByPrefix('singUP', 'Racial sing UP', 24, false);
                    animation.addByPrefix('singDOWN', 'Racial sing DOWN', 24, false);
                    animation.addByPrefix('singLEFT', 'Racial sing LEFT', 24, false);
                    animation.addByPrefix('singRIGHT', 'Racial sing RIGHT', 24, false);
                    animation.addByPrefix('hey', 'Racial Approveds', 24, false);

                    animation.addByPrefix('firstDeath', 'RACIAL DEAD??!?!??', 24, false);
                    animation.addByPrefix('deathLoop', 'Racial Dead...', 24, false);

                    addOffset('idle', 0, 0);
                    addOffset('singUP', -17, 99);
                    addOffset('singDOWN', 27, -13);
                    addOffset('singLEFT', -1, 12);
                    addOffset('singRIGHT', -17, 4);
                    addOffset("hey", 31, 4);
                	addOffset('firstDeath', 34, 22);
                	addOffset('deathLoop', 34, 22);

                    playAnim('idle');

				case 'pronun':
					frames = FlxAtlasFrames.fromSparrow(charPath + 'Pronun_Assets.png', charPath + 'Pronun_Assets.xml');
					animation.addByPrefix('idle', 'pronun idle', 24);
					animation.addByPrefix('singUP', 'pronun up', 24, false);
					animation.addByPrefix('singDOWN', 'pronun down', 24, false);
					animation.addByPrefix('singLEFT', 'pronun left', 24, false);
					animation.addByPrefix('singRIGHT', 'pronun right', 24, false);

					addOffset('idle');
					addOffset('singUP', 0, 236);
					addOffset('singDOWN', -9, 16);
					addOffset('singLEFT', 19, 10);
					addOffset('singRIGHT', 10, 31);

					playAnim('idle');

				case 'charlie':
					frames = FlxAtlasFrames.fromSparrow(charPath + 'Charlie_DM.png', charPath + 'Charlie_DM.xml');
					animation.addByPrefix('idle', 'Chawlay Idle', 24, false);
					animation.addByPrefix('singDOWN', 'Chawlay Note DOWN', 24, false);
					animation.addByPrefix('singLEFT', 'Chawlay Sing LEFT', 24, false);
					animation.addByPrefix('singUP', 'Chawlay Sing Note UP', 24, false);
					animation.addByPrefix('singRIGHT', 'Chawlay Sing RIGHT', 24, false);
					animation.addByPrefix('weird', 'Chawlay Weird', 24, false);

					addOffset('idle');
					addOffset('singDOWN', 64, -92);
					addOffset('singLEFT', 110, 54);
					addOffset('singUP', 84, -15);
					addOffset('singRIGHT', 77, -69);
					addOffset('weird', 191, 31);

				case 'flandre-cool-awesome':
					getFrames('Flan_But_Awesome');
					setNormalAnims([
						'super awesome idle dance', 
						'up (the movie)', 
						'IM DOWN BAD', 
						'the LEFT NOTE (swagger note)', 
						'thats right'
					], false);
					setOffsets([
						[-150, 300], 
						[-146, 644], 
						[27, 208], 
						[-108, 364], 
						[-181, 329]]);

					playAnim('idle');

				case 'red-ball':
					getFrames('REDBALL');
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
					
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
					
					animation.addByPrefix('scared', 'BF idle shaking', 24);
					
					addOffset('idle', -5);
					addOffset("singUP", 0, 12);
					addOffset("singRIGHT", -1, -67);
					addOffset("singLEFT", -1, -66);
					addOffset("singDOWN", 7, -34);
					addOffset("singUPmiss", 1, 12);
					addOffset("singRIGHTmiss", -2, -68);
					addOffset("singLEFTmiss", -1, -65);
					addOffset("singDOWNmiss", 9, -35);
					addOffset("hey", -35, 3);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', -44, -211);
					addOffset('deathConfirm', -17, 2);
					
					playAnim('idle');

					setGraphicSize(Std.int(this.width * 1.3));
					updateHitbox();
					
					flipX = true;
				case 'red-ball-dream':
					getFrames('glow_redball', 'REDBALL');
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
					
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
					
					animation.addByPrefix('scared', 'BF idle shaking', 24);
					
					addOffset('idle', -5);
					addOffset("singUP", 0, 12);
					addOffset("singRIGHT", -1, -67);
					addOffset("singLEFT", -1, -66);
					addOffset("singDOWN", 7, -34);
					addOffset("singUPmiss", 1, 12);
					addOffset("singRIGHTmiss", -2, -68);
					addOffset("singLEFTmiss", -1, -65);
					addOffset("singDOWNmiss", 9, -35);
					addOffset("hey", -35, 3);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', -44, -211);
					addOffset('deathConfirm', -17, 2);
					
					playAnim('idle');

					setGraphicSize(Std.int(this.width * 1.3));
					updateHitbox();
					
					flipX = true;
				case 'community-night-funkin':
					getFrames('Community_Night_Funkin');
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
					
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
					
					animation.addByPrefix('scared', 'BF idle shaking', 24);
					
					addOffset('idle', -5);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
					addOffset('scared', -4);
					
					playAnim('idle');
					
					flipX = true;
				case 'nerd':
					getFrames('nerd');
					spookyCharacter();
				case 'spoar-man':
					getFrames('Real_Spoar_Man');
					setNormalAnims(['idlee', 'up', 'down', 'left', 'right'], false);
					setOffsets([
						[0, 0],
						[-20, 420],
						[-30, -140],
						[60, 0],
						[-80, 20]
					]);
					playAnim('idle');
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('radical') && !curCharacter.startsWith('bf') && !curCharacter.startsWith('red-ball') && !(curCharacter == 'gandhi') && !(curCharacter == 'gaming-speakers') && curCharacter != 'invisible')
			{
				// var animArray
				if (animation.getByName('singRIGHT') != null)
				{
					var oldRight = animation.getByName('singRIGHT').frames;
					animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
					animation.getByName('singLEFT').frames = oldRight;
				}

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;
			var gspotVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
			
			if (curCharacter == 'gspot')
				gspotVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * gspotVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gaming-speakers':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			if (isSpooky)
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');
			}
			else
			{
				switch (curCharacter)
				{
					case 'gaming-speakers' | 'jack' | 'gaming-gunpoint' | 'namebe-speakers' | 'gaming-namebe':
						if (!animation.curAnim.name.startsWith('hair'))
						{
							danced = !danced;

							if (danced)
								playAnim('danceRight');
							else
								playAnim('danceLeft');
						}
					case 'babbys' | 'nadalyn' | 'austin' | 'skank' | 'skank-n-pronoun' | 'monkey-sprite':
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					default:
							playAnim('idle');
				}
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (curCharacter == 'christmas-monkey')
			animation.play(AnimName);
        else
            animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(animation.curAnim.name);
		if (animOffsets.exists(animation.curAnim.name))
		{
			if (curCharacter == 'red-ball' || curCharacter == 'red-ball-dream')
				offset.set(daOffset[0] * 1.3, daOffset[1] * 1.3);
			else
				offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gaming-speakers')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function getFrames(daPath:String, ?xmlName:String = '')
	{
		frames = FlxAtlasFrames.fromSparrow(charPath + daPath + '.png', (xmlName != '') ? charPath + xmlName + '.xml' : charPath + daPath + '.xml');
	}

	public function setNormalAnims(daNamesBro:Array<String>, loopIdle:Bool, hasMissAnims:Bool = false, missThing:String = 'miss')
	{
		trace(daNamesBro);
		animation.addByPrefix('idle', daNamesBro[0], 24, loopIdle);

		if (hasMissAnims)
		{
			animation.addByPrefix('singUP', daNamesBro[1] + '0', 24, false);
			animation.addByPrefix('singDOWN', daNamesBro[2] + '0', 24, false);
			animation.addByPrefix('singLEFT', daNamesBro[3] + '0', 24, false);
			animation.addByPrefix('singRIGHT', daNamesBro[4] + '0', 24, false);

			animation.addByPrefix('singUPmiss', daNamesBro[1] + ' ' + missThing, 24, false);
			animation.addByPrefix('singDOWNmiss', daNamesBro[2] + ' ' + missThing, 24, false);
			animation.addByPrefix('singLEFTmiss', daNamesBro[3] + ' ' + missThing, 24, false);
			animation.addByPrefix('singRIGHTmiss', daNamesBro[4] + ' ' + missThing, 24, false);
		}
		else
		{
			animation.addByPrefix('singUP', daNamesBro[1], 24, false);
			animation.addByPrefix('singDOWN', daNamesBro[2], 24, false);
			animation.addByPrefix('singLEFT', daNamesBro[3], 24, false);
			animation.addByPrefix('singRIGHT', daNamesBro[4], 24, false);
		}
	}

	public function setNormalAnimsLeftRight(daNamesBro:Array<String>, idleFrames:Array<Dynamic>)
	{
		trace(daNamesBro);
		var firstArray:Array<Int> = idleFrames[0];
		var secondArray:Array<Int> = idleFrames[1];
		animation.addByIndices('danceLeft', daNamesBro[0], firstArray, '', 24, false);
		animation.addByIndices('danceRight', daNamesBro[0], secondArray, '', 24, false);
		animation.addByPrefix('singUP', daNamesBro[1], 24, false);
		animation.addByPrefix('singDOWN', daNamesBro[2], 24, false);
		animation.addByPrefix('singLEFT', daNamesBro[3], 24, false);
		animation.addByPrefix('singRIGHT', daNamesBro[4], 24, false);
	}

	function getDaAnims(daNamesBro:Array<String>) // help i dont remember making this
	{
		var leg:Array<String> = [];
		for (i in daNamesBro)
		{
			leg.push('~' + i);
		}
		return leg;
	}

	public function setOffsets(zanyOffsetsBro:Array<Array<Int>>, isLeftRight:Bool = false, hasMissAnims:Bool = false)
	{
		if (isLeftRight)
		{
			trace(zanyOffsetsBro.length);
			var thingsToAddOffsetsTo:Array<String> = ['danceLeft', 'danceRight', 'singUP', 'singDOWN', 'singLEFT', 'singRIGHT'];
			if (hasMissAnims)
			{
				for (i in ['singUPmiss', 'singDOWNmiss', 'singLEFTmiss', 'singRIGHTmiss']) // bruh
				{
					thingsToAddOffsetsTo.push(i);
				}
			}
			for (i in 0...zanyOffsetsBro.length)
			{
				var coolOffset:Array<Int> = zanyOffsetsBro[i];
				addOffset(thingsToAddOffsetsTo[i], Std.int(coolOffset[0]), Std.int(coolOffset[1]));
			}
		}
		else
		{
			trace(zanyOffsetsBro.length);
			var thingsToAddOffsetsTo:Array<String> = ['idle', 'singUP', 'singDOWN', 'singLEFT', 'singRIGHT'];
			if (hasMissAnims)
			{
				for (i in ['singUPmiss', 'singDOWNmiss', 'singLEFTmiss', 'singRIGHTmiss']) // bruh v2
				{
					thingsToAddOffsetsTo.push(i);
				}
			}
			for (i in 0...zanyOffsetsBro.length)
			{
				var coolOffset:Array<Int> = zanyOffsetsBro[i];
				addOffset(thingsToAddOffsetsTo[i], Std.int(coolOffset[0]), Std.int(coolOffset[1]));
			}
		}
	}

	var isSpooky:Bool = false;

	function spookyCharacter()
	{
		animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
		animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
		animation.addByPrefix('singLEFT', 'note sing left', 24, false);
		animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
		animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
		animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);
		
		addOffset('danceLeft');
		addOffset('danceRight');
		
		addOffset("singUP", -20, 26);
		addOffset("singRIGHT", -130, -14);
		addOffset("singLEFT", 130, -10);
		addOffset("singDOWN", -50, -130);
		
		playAnim('danceRight');
		isSpooky = true;
	}

	function picoCharacter()
	{
		animation.addByPrefix('idle', "Pico Idle Dance", 24);
		animation.addByPrefix('singUP', 'pico Up note0', 24, false);
		animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
		if (isPlayer)
		{
			animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
			animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
		}
		else
		{
			// Need to be flipped! REDO THIS LATER!
			animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
			animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
			
		}
				
		playAnim('idle');
		addOffset('idle');
		addOffset("singUP", -29, 27);
		addOffset("singRIGHT", -68, -7);
		addOffset("singLEFT", 65, 9);
		addOffset("singDOWN", 200, -70);
				
		if (!isPlayer)
			flipX = true;
	}
}
