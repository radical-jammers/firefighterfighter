package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Player extends Entity
{
	/* Static variables */
	public var XSPEED : Int = 60;
	public var YSPEED : Int = 60;
	private static inline var ATTACK_VALUE = 5;
	private static inline var HP_VALUE = 100;

	/* Status vars */
	var attacking : Bool;
	var currentAttack : Int;

	var punchMask : FlxObject;

	public var hp: Int;
	public var atk: Int;

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

		punchMask = new FlxObject(x, y, 6, 6);
		punchMask.immovable = true;
		punchMask.kill();

		hp = HP_VALUE;
		atk = ATTACK_VALUE;
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

				positionPunchMask();
			}
		}
		else
		{
			if (animation.finished)
			{
				attacking = false;
				punchMask.kill();
			}
			else
			{
				FlxG.overlap(punchMask, world.enemies, onPunched);
			}
		}

		/* Handle animation */
		if (!attacking)
		{
			if (velocity.x != 0 || velocity.y != 0)
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

	function positionPunchMask()
	{
		punchMask.revive();

		switch (facing)
		{
			case FlxObject.LEFT:
				punchMask.x = getMidpoint().x - 8 - punchMask.width;
			case FlxObject.RIGHT:
				punchMask.x = getMidpoint().x + 8;
		}

		punchMask.y = y + 4;

		punchMask.update();
	}

	function handleMovement()
	{
		if (GamePad.checkButton(GamePad.Left))
		{
			velocity.x = -XSPEED;
			velocity.y = 0;
			facing = FlxObject.LEFT;
			flipX = true;
		}
		if (GamePad.checkButton(GamePad.Right))
		{
			velocity.x = XSPEED;
			velocity.y = 0;
			facing = FlxObject.RIGHT;
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

	function onPunched(punch : FlxObject, enemy : Enemy)
	{
		FlxObject.separate(this, enemy);
		var success : Bool = enemy.onPunched(punch);
		if (success)
		{
			// ?
		}
	}

	public function onCollisionWithEnemy(enemy: Enemy): Void
	{

	}

	public function receiveDamage(damage: Int): Void
	{
		hp = Std.int(Math.max(0, hp - damage));
	}

	public function onDefeat(): Void
	{
		FlxTween.tween(this.scale, {
			x: 0,
			y: 1.5
		}, 0.15, {
			complete: function(tween: FlxTween) {
			}
		});
	}

	override public function draw() :  Void
	{
		super.draw();
		if (punchMask.alive)
			punchMask.draw();
	}
}
