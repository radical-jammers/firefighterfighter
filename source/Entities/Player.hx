package;


class Player extends Entity
{
	/* Static variables */
	public var XSPEED : Int = 60;
	public var YSPEED : Int = 60;

	/* Status vars */
	var attacking : Bool;
	var currentAttack : Int;

	public function new(X : Float, Y : Float, World : World)
	{
		super(X,Y,World);
		
		loadGraphic("assets/images/figther-walk-sheet.png", true, 32, 24);
		
		animation.add("idle", [0]);
		animation.add("walk", [1, 0], 8);
		animation.add("attack-0", [2, 2], 8, false);
		animation.add("attack-1", [3, 3], 8, false);
		
		replaceColor(0xFFFF00FF,0x00000000);

		setSize(16, 16);
		offset.set(8, 8);
		
		attacking = false;
		currentAttack = 0;
	}

	override public function update() : Void
	{

		velocity.x = 0;
		velocity.y = 0;

		if (!attacking)
		{
			handleMovement();

			// Attacking!
			if (GamePad.justPressed(GamePad.B))
			{
				attacking = true;
				animation.play("attack-" + currentAttack);
				currentAttack = (currentAttack + 1) % 2;
			}
		}
		else
		{
			if (animation.finished)
			{
				attacking = false;
			}
		}
		
		/* Handle animation */

		if (!attacking)
		{
			if (velocity.x !=0 || velocity.y != 0)
			{
				animation.play("walk");
			}
			else
			{
				animation.play("idle");
			}
		}

		super.update();
	}

	function handleMovement()
	{
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
	}

	override public function draw() :  Void
	{
		super.draw();
	}



}