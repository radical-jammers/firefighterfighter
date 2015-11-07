package;

import flixel.FlxSprite;

class Entity extends FlxSprite
{
	public var world : World;

	public function new(X : Float, Y : Float, World : World)
	{
		super(X,Y);

		world = World;
	}

	override public function update() : Void
	{
		super.update();
	}

	override public function draw() :  Void
	{
		super.draw();
	}

}