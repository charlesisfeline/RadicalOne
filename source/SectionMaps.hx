package;

typedef CoolMappings =
{
	var sectionMappings:Array<Dynamic>;
	var lengthInSteps:Int;
	var typeOfSection:Int;
	var bpm:Int;
	var changeBPM:Bool;
}

class SectionMaps
{
	public var sectionMappings:Array<Dynamic> = [];

	public var lengthInSteps:Int = 16;
	public var typeOfSection:Int = 0;

	/**
	 *	Copies the first section into the second section!
	 */
	public static var COPYCAT:Int = 0;

	public function new(lengthInSteps:Int = 16)
	{
		this.lengthInSteps = lengthInSteps;
	}
}
