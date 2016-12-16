package text;

import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;

import openfl.Assets;

class PixelText
{
	private static var fontFile : String = "assets/fonts/nes";

	// System pixel font
	public static var font : FlxBitmapFont;
	
	static var initialized : Bool;

	public static function Init()
	{
		// if (!initialized)
		{
			// Load system font
			var textBytes = Assets.getText(fontFile + ".fnt");
			var XMLData = Xml.parse(textBytes);
			font = FlxBitmapFont.fromAngelCode(Assets.getBitmapData(fontFile + "_0.png"), XMLData);	
			
			initialized = true;
		}
	}
	
	public static function New(X : Float, Y : Float, Text : String, ?Color : Int = 0xFFFFFFFF, ?Width : Int = -1) : FlxBitmapText
	{
		Init();
		
		var text : FlxBitmapText = new FlxBitmapText(font);
		text.x = X;
		text.y = Y - 4;
		text.text = Text;
		text.color = Color;
		text.useTextColor = false;
		
		if (Width > 0)
		{
			text.wordWrap = true;
			text.autoSize = true;
			text.width = Width;
			text.multiLine = true;
			// text.lineSpacing = -154;
		}
		
		return text;
	}
}
