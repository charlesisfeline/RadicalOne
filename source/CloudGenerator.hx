package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;

using StringTools;

class CloudGenerator extends FlxGroup
{
    var clouds:FlxTypedGroup<FlxSprite>;
    var stupidUglyArray:Array<Float> = [];

    var startX:Float;
    var endX:Float;

    public function new(startX:Float, startY:Float, endX:Float, endY:Float, imagePath:String, scrollAmount:Float = 1, density:Int = 20)
    {
        super();

        this.startX = startX;
        this.endX = endX;

        clouds = new FlxTypedGroup<FlxSprite>();
        add(clouds);

        var globalStoppingPoint:Int = 0;

        for (i in 0...density)
        {
            var bunchOJunk:Int = FlxG.random.int(100, 250);
            var cloud:FlxSprite = new FlxSprite(FlxG.random.float(startX, endX), FlxG.random.float(startY, endY)).loadGraphic(imagePath);
            cloud.setGraphicSize(bunchOJunk);
            cloud.updateHitbox();
            cloud.scrollFactor.set(scrollAmount + (bunchOJunk / 1000 - 0.05), scrollAmount + (bunchOJunk / 1000 - 0.05));
            cloud.ID = i;
            stupidUglyArray.push((bunchOJunk * 2) / 10);
            clouds.add(cloud);
        }
    }

    override function update(elapsed:Float)
    {
        clouds.forEach(function(cloud:FlxSprite){
            cloud.x -= stupidUglyArray[cloud.ID] / 60;
            if (cloud.x < startX)
                cloud.x = endX;
        });
        super.update(elapsed);
    }
}