package;

class SwagEase
{
    public static function swagEase(t:Float):Float
    {
        return Math.round((-t * (t - 2)) * 5) / 5;
    }

    public static function swaggierEase(t:Float):Float
    {
        return Math.round(((t = t - 1) * t * t * t * t + 1) * 5) / 5;
    }
}