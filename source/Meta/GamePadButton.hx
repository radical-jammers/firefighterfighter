package;

import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import flixel.util.FlxColorUtil;

class GamePadButton extends Sprite
{
	public var id : Int;
	public var color : Int;
	
	public var bounds : Rectangle;
	
	public var pressed : Bool;
	
	public function new(Id : Int, X : Float, Y : Float, Width : Float, Height : Float)
	{
		super();
		
		x = X;
		y = Y;
		width = Width;
		height = Height;
		
		id = Id;
		bounds = new Rectangle(X, Y, Width, Height);
		
		pressed = false;
		
		color = FlxColorUtil.getRandomColor(0x75, 0xFF, 0x00);
		
		draw();
	}
	
	public function isPressed(touches : Map<Int, Point>) : Bool
	{
		pressed = false;
		
		for (point in touches.iterator())
		{
			if (bounds.contains(point.x, point.y))
			{
				pressed = true;
				break;
			}
		}
		
		draw();
		
		return pressed;
	}
	
	public function draw()
	{
		#if (mobile || vpad)
		graphics.clear();
		
		if (pressed)
		{
			graphics.beginFill(color, 0.6);
			graphics.drawRect(0, 0, bounds.width, bounds.height);
			graphics.endFill();
		}
		else
		{
			graphics.beginFill(color, 0.3);
			graphics.drawRect(0, 0, bounds.width, bounds.height);
			graphics.endFill();
		}
		#end
	}
}