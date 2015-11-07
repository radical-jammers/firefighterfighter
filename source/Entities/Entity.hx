package;

import flixel.FlxSprite;

class Entity extends FlxSprite
{
	public var world : World;

	public var shadow : FlxSprite;

	public function new(X : Float, Y : Float, World : World)
	{
		super(X,Y);

		world = World;
		world.entities.add(this);

		shadow = new FlxSprite(x, y).loadGraphic("assets/images/shadow.png");
		shadow.alpha = 0.5;
		shadow.solid = false;

		positionShadow();
	}

	override public function destroy() : Void
	{
		world.entities.remove(this);
		super.destroy();
	}

	override public function update() : Void
	{
		super.update();

		positionShadow();
		shadow.update();
	}

	override public function draw() :  Void
	{
		shadow.draw();

		super.draw();
	}

	public function positionShadow()
	{
		shadow.x = x + width/2 - shadow.width/2;
		shadow.y = y + height - shadow.height/2;
	}
}