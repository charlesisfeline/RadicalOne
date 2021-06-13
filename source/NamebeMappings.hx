package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

// WHAT IS THIS LOOL I HAVE NO MEMORY OF ADDING THSI

typedef NameMap =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var sections:Int;
	var sectionLengths:Array<Dynamic>;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var player3:String;
	var player4:String;
	var validScore:Bool;
}

class NamebeMappings
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var sections:Int;
	public var sectionLengths:Array<Dynamic> = [];
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var player3:String = 'pico';
	public var player4:String = 'invisible';

	public function new(song, notes, bpm, sections)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
		this.sections = sections;

		for (i in 0...notes.length)
		{
			this.sectionLengths.push(notes[i]);
		}
	}

	public static function loadMapsFromJson(jsonInput:String, ?folder:String):NameMap
	{
		var rawJson = Assets.getText('assets/data/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase() + '-mappings.json').trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		// FIX THE CASTING ON WINDOWS/NATIVE
		// Windows???
		// trace(songData);

		// trace('LOADED FROM JSON: ' + songData.notes);
		/* 
			for (i in 0...songData.notes.length)
			{
				trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
				// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
			}

				daNotes = songData.notes;
				daSong = songData.song;
				daSections = songData.sections;
				daBpm = songData.bpm;
				daSectionLengths = songData.sectionLengths; */

		return parseJSONjunk(rawJson);
	}

	public static function parseJSONjunk(rawJson:String):NameMap
	{
		var swagShit:NameMap = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}


/* OLD JUNK
package;

import SectionMaps.CoolMappings;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef NameMap =
{
	var song:String;
	var maps:Array<CoolMappings>;
	var bpm:Int;
	var sections:Int;
	var sectionLengths:Array<Dynamic>;
}

class Song
{
	public var song:String;
	public var maps:Array<CoolMappings>;
	public var bpm:Int;
	public var sections:Int;
	public var sectionLengths:Array<Dynamic> = [];

	public function new(song, maps, bpm, sections)
	{
		this.song = song;
		this.maps = maps;
		this.bpm = bpm;
		this.sections = sections;

		for (i in 0...maps.length)
		{
			this.sectionLengths.push(maps[i]);
		}
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):NameMap
	{
		var rawJson = Assets.getText('assets/data/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase() + '-mappings.json').trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		// FIX THE CASTING ON WINDOWS/NATIVE
		// Windows???
		// trace(songData);

		// trace('LOADED FROM JSON: ' + songData.maps);
		/* 
			for (i in 0...songData.maps.length)
			{
				trace('LOADED FROM JSON: ' + songData.maps[i].sectionmaps);
				// songData.maps[i].sectionmaps = songData.maps[i].sectionmaps
			}

				damaps = songData.maps;
				daSong = songData.song;
				daSections = songData.sections;
				daBpm = songData.bpm;
				daSectionLengths = songData.sectionLengths; * / PUT THIS BACK

                return parseJSONjunk(rawJson);
            }
        
            public static function parseJSONjunk(rawJson:String):NameMap
            {
                var swagShit:NameMap = cast Json.parse(rawJson).song;
                return swagShit;
            }
        }*/
        