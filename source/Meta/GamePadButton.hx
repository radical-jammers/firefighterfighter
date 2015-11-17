package;

import openfl.display.Sprite;
import openfl.geom.Rectangle;

import flixel.util.FlxColorUtil;

class GamePadButton extends Sprite
{
	public var id : Int;
	public var color : Int;
	
	public var bounds : Rectangle;
	
	public function new(Id : Int, X : Float, Y : Float, Width : Float, Height : Float)
	{
		super();
		
		x = X;
		y = Y;
		width = Width;
		height = Height;
		
		id = Id;
		bounds = new Rectangle(X, Y, Width, Height);
		
		color = FlxColorUtil.getRandomColor(0x75, 0xFF, 0x00);
		
		graphics.beginFill(color, 0.3);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
	}
}