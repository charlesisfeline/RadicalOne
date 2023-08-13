package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Controls.Control;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
// import openfl.utils.AssetManifest;
// import lime.utils.Assets;
// import openfl.utils.AssetType;
// import openfl.utils.AssetLibrary;
import flash.display.BitmapData;

using StringTools;

class CharacterMenu extends MusicBeatState
{
	var swagArray:Array<FlxSprite> = [];
	var curSelected:Int = 0;
	var coolText:FlxText;
	var lvlList:FlxText;
	var desc:FlxText;

	var names:Array<String>;
	var descs:Array<String> = CoolUtil.coolTextFile('assets/images/characterMenu/descs.txt');
	var buttocks:Array<Array<String>> = [];
	var swagGoodArray:Array<Array<Float>> = [];

	override function create()
	{
		var spritesToAdd:Array<String> = CoolUtil.coolTextFile('assets/images/characterMenu/images.txt');
		names = CoolUtil.coolTextFile('assets/images/characterMenu/names.txt');
		var theToilet:Array<String> = CoolUtil.coolTextFile('assets/images/characterMenu/lvls.txt');
		add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFE9575C));
		trace(theToilet);

		for (i in 0...spritesToAdd.length)
		{
			swagGoodArray.push([]);
			// Assets.registerLibrary('poop', new AssetLibrary());
			var pooping:FlxSprite = new FlxSprite().loadGraphic(BitmapData.fromFile('assets/images/characterMenu/${spritesToAdd[i]}.png'));
			swagGoodArray[i].push((576 / 1.5) / pooping.height);
			pooping.scale.set(swagGoodArray[i][0], swagGoodArray[i][0]);
			pooping.x = (350 / 1.5) - ((swagGoodArray[i][0] * pooping.width) / 2);
			pooping.y += 25;
			swagGoodArray[i].push(pooping.x);
			swagGoodArray[i].push(pooping.y);
			pooping.updateHitbox();
			swagArray.push(pooping);
			add(pooping);

			descs[i] = descs[i].replace('\\n', '\n');
		}

		for (poop in theToilet) // literally only put this in a seperate loop so i could do this
		{
			buttocks.push(poop.split(':'));
		}
		trace(buttocks);

		add(new FlxSprite(470).makeGraphic(FlxG.width - 470, FlxG.height, 0xFFE9575C));
		add(new FlxSprite().makeGraphic(5, FlxG.height, 0xFFE9575C));
		add(new FlxSprite(5, 5).makeGraphic(12, 410, FlxColor.BLACK));
		add(new FlxSprite(465, 5).makeGraphic(12, 410, FlxColor.BLACK));
		add(new FlxSprite(5, 5).makeGraphic(460, 12, FlxColor.BLACK));
		add(new FlxSprite(5, 410).makeGraphic(472, 12, FlxColor.BLACK));

		for (i in [[500, 5, 730, 110], [500, 155, 730, 267], [5, 430, 1225, 275]])
		{
			add(new FlxSprite(i[0], i[1]).makeGraphic(i[2], i[3], FlxColor.BLACK));
			add(new FlxSprite(i[0] + 12, i[1] + 12).makeGraphic(i[2] - 24, i[3] - 24, 0xFFE9575C));
		}

		coolText = new FlxText(845, 30, 0, "", 65);
		coolText.setFormat("VCR OSD Mono", 65, FlxColor.BLACK, CENTER);
		add(coolText);

		lvlList = new FlxText(530, 170, 0, "", 60);
		lvlList.setFormat("VCR OSD Mono", 60, FlxColor.BLACK);
		add(lvlList);

		desc = new FlxText(25, 440, 0, "", 45);
		desc.setFormat("VCR OSD Mono", 45, FlxColor.BLACK);
		add(desc);

		changeSelection();

		super.create();
	}

	override function update(d:Float)
	{
		if (controls.LEFT_P)
			changeSelection(-1);
		if (controls.RIGHT_P)
			changeSelection(1);
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		super.update(d);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = swagArray.length - 1;
		if (curSelected >= swagArray.length)
			curSelected = 0;

		updateJunk();
	}

	function updateJunk()
	{
		coolText.text = names[curSelected];
		coolText.screenCenter(X);
		coolText.x += 205;

		lvlList.text = 'Levels:\n';
		for (cakedPoop in buttocks[curSelected])
		{
			lvlList.text += cakedPoop + '\n';
		}

		desc.text = descs[curSelected];

		for (i in 0...swagArray.length)
		{
			FlxTween.cancelTweensOf(swagArray[i]);
			FlxTween.tween(swagArray[i], {
				x: swagGoodArray[i][1] - 350 * (curSelected - i),
				"scale.x": swagGoodArray[i][0] - Math.abs(0.1 * (curSelected - i)),
				"scale.y": swagGoodArray[i][0] - Math.abs(0.1 * (curSelected - i))
			}, 0.3, {ease: FlxEase.quintOut});
		}
	}
}
