package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;

using flixel.util.FlxSpriteUtil;

class Player extends Entity
{
	/* Static variables */
	public var XSPEED : Int = 60;
	public var YSPEED : Int = 60;
	private static inline var ATTACK_VALUE = 5;
	private static inline var MAX_HP_VALUE = 5;
	public var StunKnockbackSpeed : Int = 50;
	public var StunnedTime : Float = 0.3;
	public var KnockbackTime : Float = 0.15;
	public var InvulnerabilityTime : Float = 1;

	/* Status vars */
	var attacking : Bool;
	var currentAttack : Int;

	var stunned : Bool;
	var invulnerable : Bool;

	var timer : FlxTimer;
	var punchMask : FlxObject;

	public var atk: Int;

	public function new(X : Float, Y : Float, World : World)
	{
		super(X,Y,World);

		loadGraphic("assets/images/fighter-walk-sheet.png", true, 32, 24);

		animation.add("idle", [0]);
		animation.add("walk", [1, 0], 8);
		animation.add("attack-0", [2, 2], 8, false);
		animation.add("attack-1", [3, 3], 8, false);
		animation.add("stunned", [4]);

		replaceColor(0xFFFF00FF,0x00000000);

		setSize(12, 12);
		offset.set(10, 12);

		attacking = false;
		currentAttack = 0;

		stunned = false;
		invulnerable = false;

		punchMask = new FlxObject(x, y, 8, 10);
		punchMask.immovable = true;
		punchMask.kill();

		timer = new FlxTimer();

		atk = ATTACK_VALUE;
	}

	override public function update() : Void
	{
		if (GameStatus.currentHp >= 0)
		{
			if (stunned)
			{
				animation.play("stunned");
			}
			else
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
			}

			/* Handle animation */
			if (!stunned)
			{
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
			}
		} else {
			onDefeat();
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

		punchMask.y = y + 2;

		punchMask.update();
	}

	function handleMovement()
	{
		if (GamePad.checkButton(GamePad.Left))
		{
			velocity.x = -XSPEED;
			//velocity.y = 0;
			facing = FlxObject.LEFT;
			flipX = true;
		}
		if (GamePad.checkButton(GamePad.Right))
		{
			velocity.x = XSPEED;
			//velocity.y = 0;
			facing = FlxObject.RIGHT;
			flipX = false;
		}
		if (GamePad.checkButton(GamePad.Up))
		{
			//velocity.x = 0;
			velocity.y = -YSPEED;
		}
		if (GamePad.checkButton(GamePad.Down))
		{
			//velocity.x = 0;
			velocity.y = YSPEED;
		}

		if (velocity.x != 0 && velocity.y != 0)
		{
			var sin45: Float = 0.707;
			velocity.x *= sin45;
			velocity.y *= sin45;
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
		if (!stunned && !invulnerable)
		{
			trace("HALP! I'm being hit!");
			if (enemy.getMidpoint().x > getMidpoint().x)
					velocity.x = -StunKnockbackSpeed;
				else
					velocity.x = StunKnockbackSpeed;

			attacking = false;
			punchMask.kill();
			stunned = true;
			invulnerable = true;

			receiveDamage(enemy.atk);

			new FlxTimer(StunnedTime, function onStunEnd(_t:FlxTimer) {
				stunned = false;
			});

			new FlxTimer(KnockbackTime, function onKnockbackEnd(_t:FlxTimer) {
				velocity.set();
			});

			this.flicker(InvulnerabilityTime);
			new FlxTimer(InvulnerabilityTime, function onInvulnerableEnd(_t:FlxTimer) {
				invulnerable = false;
			});
		}
	}

	public function onCollisionWithItem(item: Item): Void
	{
		item.onCollect(this);
	}

	public function receiveDamage(damage: Int): Void
	{
		GameStatus.currentHp -= damage;
	}

	public function recoverHp(hpToRecover: Int): Void
	{
		GameStatus.currentHp = Std.int(Math.min(MAX_HP_VALUE, GameStatus.currentHp + hpToRecover));
	}

	public function onDefeat(): Void
	{
		FlxTween.tween(this.scale, {
			x: 0,
			y: 1.5
		}, 0.15, {
			complete: function(tween: FlxTween) {
				GameStatus.lives--;
				GameStatus.currentHp = MAX_HP_VALUE;
				GameController.RestartStage();
			}
		});
	}

	override public function draw() :  Void
	{
		super.draw();
	}

	override public function positionShadow()
	{
		shadow.x = getMidpoint().x - shadow.width / 2;
		shadow.y = y + height - shadow.height / 2;
	}
}
