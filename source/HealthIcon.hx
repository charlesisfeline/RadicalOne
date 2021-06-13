package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public function new(char:String = 'radical', isPlayer:Bool = false)
	{
		super();

		loadIcon(char);
		antialiasing = true;

		animation.play('normal');

		flipX = isPlayer;

		scrollFactor.set();
	}

	public function loadIcon(char:String)
	{
		switch (char)
		{
			case 'wow2':
				loadGraphic(Character.charPath + 'icons/wow.png', true, 150, 150);
			case 'gaming-speakers' | 'pc' | 'gaming-gunpoint':
				loadGraphic(Character.charPath + 'icons/gaming.png', true, 150, 150);
			case 'christmas-monkey' | 'senpai' | 'senpai-angry':
				loadGraphic(Character.charPath + 'icons/monkey-sprite.png', true, 150, 150);
			case 'spirit':
				loadGraphic(Character.charPath + 'icons/failure.png', true, 150, 150);
			case 'racial-pride':
				loadGraphic(Character.charPath + 'icons/pride.png', true, 150, 150);
			case 'red-ball':
				loadGraphic(Character.charPath + 'icons/redball.png', true, 150, 150);
			case 'sussy':
				loadGraphic(Character.charPath + 'icons/sus.png', true, 150, 150);
			case 'bf-pixel':
				loadGraphic(Character.charPath + 'icons/junkers.png', true, 150, 150);
			default:
				loadGraphic(Character.charPath + 'icons/' + char + '.png', true, 150, 150);
		}

		animation.add('normal', [0], 0, false);
		animation.add('losing', [1], 0, false);
	}
}
