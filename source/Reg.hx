package;

import flixel.util.FlxRandom;

class Reg
{
	public static var sfxPunches : Array<String> = ["Punch.wav", "Punch2.wav", "Punch3.wav", "Punch4.wav"];
	public static var sfxHits	: Array<String> = ["Hit.wav", "Hit2.wav", "Hit3.wav", "Hit4.wav"];
	public static inline var sfxFire	: String = "Fire.wav";

	public static inline function getRandomSfx(array : Array<String>) : String
	{
		return getSfx(FlxRandom.getObject(array));
	}

	public static inline function getSfx(name : String) : String 
	{
		return "assets/sounds/" + name;
	}
}