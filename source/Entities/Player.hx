package;


class Player extends Entity
{

	public var XSPEED : Int = 60;
	public var YSPEED : Int = 60;


	public function new(X : Float, Y : Float, World : World)
	{
		super(X,Y,World);
		loadGraphic("assets/images/figther-walk-sheet.png", true, 32, 24);
		animation.add("idle", [0]);
		animation.add("walk", [0,1], 4);
		replaceColor(0xFFFF00FF,0x00000000);
		
	}

	override public function update() : Void
	{

		velocity.x = 0;
		velocity.y = 0;

		if (GamePad.checkButton(GamePad.Left))
		{
			velocity.x = -XSPEED;
			velocity.y = 0;
			flipX = true;
		}
		if (GamePad.checkButton(GamePad.Right)) 
		{
			velocity.x = XSPEED;
			velocity.y = 0;
			flipX = false;
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
		if (velocity.x !=0 || velocity.y != 0)
		{
			animation.play("walk");
		}
		else
		{
			animation.play("idle");
		}

		super.update();
	}


	override public function draw() :  Void
	{
		super.draw();


	}



}