package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	var isPaly:Bool = false;
	public function new(char:String = 'radical', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Character.charPath + '_iconGrid.png', true, 150, 150);
		this.isPaly = isPlayer;

		antialiasing = true;
		addIcon('radical', 0);
		addIcon('bf-pixel', 0);
		addIcon('babbys', 2);
		addIcon('namebe', 4);
		addIcon('bonbon', 6);
		addIcon('old-racial', 8);
		addIcon('face', 10);
		addIcon('interviewer', 12);
		addIcon('bf-old', 14);
		addIcon('gaming-speakers', 16);
		addIcon('monkey-sprite', 18);
		animation.add('monkey-sprite', [18, 19], 0, false, isPlayer); // too lazy to convert the rest lol
		animation.add('christmas-monkey', [18, 19], 0, false, isPlayer);
		animation.add('wow', [22, 23], 0, false, isPlayer);
		animation.add('wow2', [22, 23], 0, false, isPlayer);
		animation.add('salted', [24, 25], 0, false, isPlayer);
		animation.add('machine', [26, 27], 0, false, isPlayer);
		animation.add('nadalyn', [20, 21], 0, false, isPlayer);
		animation.add('invisible', [10, 11], 0, false, isPlayer);
		animation.add('gandhi', [10, 11], 0, false, isPlayer);
		animation.add('gaming', [16, 17], 0 , false, isPlayer);
		animation.add('senpai', [18, 19], 0, false, isPlayer);
		animation.add('senpai-angry', [18, 19], 0, false, isPlayer);
		animation.add('spirit', [0, 1], 0, false, isPlayer);
		animation.add('four', [28, 29], 0, false, isPlayer);
		animation.add('x', [36, 37], 0, false, isPlayer);
		animation.add('racial', [0, 1], 0, false, isPlayer);
		animation.add('austin', [40, 41], 0, false, isPlayer);
		animation.add('pronun', [42, 43], 0, false, isPlayer);
		animation.add('charlie', [44, 45], 0, false, isPlayer);
		animation.add('skank', [46, 47], 0, false, isPlayer);
		animation.add('goomba', [48, 49], 0, false, isPlayer);
		animation.add('dadamono', [52, 53], 0, false, isPlayer);
		animation.add('red-ball', [54, 55], 0, false, isPlayer);
		animation.add('failure', [56, 57], 0, false, isPlayer);
		animation.add('flandre-cool-awesome', [58, 59], 0, false, isPlayer);
		animation.add('3.4', [60, 61], 0, false, isPlayer);
		addIcon('stick', 62);
		addIcon('racial-pride', 64);
		addIcon('gandhi', 66);
		addIcon('skank-n-pronoun', 68);
		animation.play('radical');
		animation.play(char);
		scrollFactor.set();
	}

	function addIcon(char:String, startingFrame:Int)
	{
		animation.add(char, [startingFrame, startingFrame + 1], 0, false, isPaly);
	}
}
