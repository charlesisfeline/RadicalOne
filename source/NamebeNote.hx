package;

import flixel.tweens.FlxTween;
import flixel.FlxG;

class NamebeNote extends Note
{
    public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
    {
        super(strumTime, noteData, prevNote, sustainNote);
        loadGraphic('assets/images/UI/namebeNotes.png', true, 150, 150);
        for (i in ['green', 'red', 'blue', 'purple']) animation.remove(i + 'Scroll');
        animation.add('greenScroll', [2]);
		animation.add('redScroll', [3]);
		animation.add('blueScroll', [1]);
		animation.add('purpleScroll', [0]);
        animation.add('ball', [4]);
        scale.set(0.7, 0.7);
        updateHitbox();
        antialiasing = true;

        randomNoteData = FlxG.random.int(0, 3);

        while(randomNoteData == noteData) randomNoteData = FlxG.random.int(0, 3);
        // trace(randomNoteData);

        playFunnyAnim(randomNoteData);

        x -= Note.swagWidth * noteData;
        x += Note.swagWidth * randomNoteData;
    }

    function playFunnyAnim(data:Int)
    {
        switch (data)
		{
			case 0:
				animation.play('purpleScroll');
			case 1:
				animation.play('blueScroll');
			case 2:
				animation.play('greenScroll');
			case 3:
				animation.play('redScroll');
		}
    }

    public var hasDunked:Bool = false;
    public var randomNoteData:Int = 0;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Conductor.songPosition - strumTime > -475 && !hasDunked) {
            hasDunked = true;
            animation.play('ball');
            FlxTween.tween(this, {x: (x - Note.swagWidth * randomNoteData) + Note.swagWidth * noteData}, 0.05, {onComplete: function(twn:FlxTween){
                playFunnyAnim(noteData);
            }});
        }
    }
}