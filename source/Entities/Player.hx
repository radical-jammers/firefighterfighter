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
	public static inline var ATTACK_VALUE = 5;
	public static inline var MAX_HP_VALUE = 5;
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
	public var punchMask : FlxObject;
	public var punched : Bool;

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

		punched = false;

		timer = new FlxTimer();

		atk = ATTACK_VALUE;
	}

	override public function update(elapsed:Float) : Void
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

						FlxG.sound.play(Reg.getRandomSfx(Reg.sfxPunches), 0.35);

						positionPunchMask();

						punched = false;
					}
				}
				else
				{
					// After one successfull punch frame, don't hit anymore
					if (punched)
						punchMask.kill();

					// When the animation has finished, return to idle
					if (animation.finished)
					{
						attacking = false;
						punchMask.kill();
					}
					else // Punch the shit out of those bastards
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


		super.update(elapsed);
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

		punchMask.update(0);
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
			FlxG.sound.play(Reg.getRandomSfx(Reg.sfxHits));
			punched = true;
		}
	}

	public function onCollisionWithEnemy(enemy: Enemy): Void
	{
		if (!stunned && !invulnerable)
		{
			receiveDamage(enemy.atk);

			var dir : Int = FlxObject.RIGHT;
			if (enemy.getMidpoint().x > getMidpoint().x)
			{
				dir = FlxObject.LEFT;
			}

			FlxG.sound.play(Reg.getSfx(Reg.sfxFireHit));

			applyKnockback(dir);
		}
	}

	public function applyKnockback(dir : Int) {
			if (dir == FlxObject.LEFT)
				velocity.x = -StunKnockbackSpeed;
			else
				velocity.x = StunKnockbackSpeed;

			attacking = false;
			punchMask.kill();
			stunned = true;
			invulnerable = true;

			new FlxTimer().start(StunnedTime, function onStunEnd(_t:FlxTimer) {
				stunned = false;
			});

			new FlxTimer().start(KnockbackTime, function onKnockbackEnd(_t:FlxTimer) {
				velocity.set();
			});

			this.flicker(InvulnerabilityTime);
			new FlxTimer().start(InvulnerabilityTime, function onInvulnerableEnd(_t:FlxTimer) {
				invulnerable = false;
			});
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
			onComplete: function(tween: FlxTween) {
				GameStatus.lives--;
				if (GameStatus.lives < 0)
				{
					GameController.GameOver();
				}
				else
				{
					GameStatus.currentHp = MAX_HP_VALUE;
					GameController.RestartScene();
				}
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
