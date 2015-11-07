package;


class Player extends Entity
{

	public var XSPEED : Int = 60;
	public var YSPEED : Int = 60;


	public function new(X : Float, Y : Float, World : World)
	{
		super(X,Y,World);
		makeGraphic(16,16);

	}

	override public function update() : Void
	{

		velocity.x = 0;
		velocity.y = 0;

		if (GamePad.checkButton(GamePad.Left))
		{
			velocity.x = -XSPEED;
			velocity.y = 0;
		}
		if (GamePad.checkButton(GamePad.Right)) 
		{
			velocity.x = XSPEED;
			velocity.y = 0;
		}
		if (GamePad.checkButton(GamePad.Up))
		{
			velocity.x = 0;
			velocity.y = -YSPEED;
		}
		if (GamePad.checkButton(GamePad.Down)) 
		{
			velocity.x = 0;
			velocity.y = YSPEED;
		}

		if (FlxG.worldBounds)
		{
			
			
			
		}
		super.update();
	}


	override public function draw() :  Void
	{
		super.draw();


	}



}