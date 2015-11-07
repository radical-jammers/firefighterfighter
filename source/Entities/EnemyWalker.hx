package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;

class EnemyWalker extends Enemy
{
	public static inline var ATTACK_VALUE: Int = 1;
	public static inline var HP_VALUE: Int = 20;

	private static inline var AttackIdleTime : Float = 1;
	private static inline var STEP_DISTANCE: Int = 8;
	private static inline var WARN_DISTANCE: Int = 32;
	private static inline var StunKnockbackSpeed : Int = 30;

	private var status: Int;
	private var roamTimer: FlxTimer;

	public function new(x: Float, y: Float, world: World)
	{
		super(x, y, world);

		loadGraphic("assets/images/walker-sheet.png", true, 24, 24);

		animation.add("walk", [0, 1, 2, 3, 3, 2, 1, 0], 6);
		animation.add("charge", [0, 1, 2, 3, 3, 2, 1, 0], 8);
		animation.add("stunned", [4, 5], 4);

		animation.play("walk");

		setSize(12, 8);
		offset.set(6, 14);

		hp = HP_VALUE;
		atk = ATTACK_VALUE;

		brain.transition(statusRoam, "roam");
		roamTimer = new FlxTimer();
		roamTimer.start(1.0, doRoam, 0);
	}

	public function statusIdle() : Void
	{
		// lalala
		animation.play("walk");
		velocity.set();
	}

	public function statusRoam(): Void
	{
		if (playerIsNear())
		{
			roamTimer.cancel();
			brain.transition(statusFetch, "fetch");
		}
	}

	public function statusFetch(): Void
	{
		if (!playerIsNear())
		{
			roamTimer.start(1.0, doRoam, 0);
			brain.transition(statusRoam, "roam");
		} else
		{
			FlxVelocity.moveTowardsPoint(this, getPlayer().getMidpoint(), STEP_DISTANCE * 2);
			animation.play("charge");
			handleFacing();
		}
	}

	override public function update(): Void
	{
		super.update();
	}

	public override function onCollisionWithPlayer(): Void
	{
		brain.transition(statusIdle, "idle");
		new FlxTimer(AttackIdleTime, function(_t:FlxTimer){
			brain.transition(statusRoam);
		});
	}

	public override function onPunched(punchMask: FlxObject) : Bool
	{
		if (isStunned)
			return false;

		receiveDamage(getPlayer().atk);

		if (punchMask.getMidpoint().x < getMidpoint().x)
			flipX = true;
		else
			flipX = false;

		if (hp > 0)
		{
			/*if (punchMask.getMidpoint().x > getMidpoint().x)
					velocity.x = -StunKnockbackSpeed;
				else
					velocity.x = StunKnockbackSpeed;*/

			brain.transition(stunned);
			isStunned = true;
		}
		return true;
	}

	public override function stunned(): Void
	{
		if (timer == null)
		{
			trace("timer");
			timer = new FlxTimer(StunnedTime, onStunnedEnd);
		}

		roamTimer.cancel();

		isStunned = true;
		velocity.set();

		animation.play("stunned");
	}

	public override function onStunnedEnd(_t : FlxTimer): Void
	{
		isStunned = false;
		brain.transition(statusFetch, "fetch");
		timer = null;
	}

	private function doRoam(timer: FlxTimer): Void
	{
		if (Math.random() > 0.5) {
			var angle: Float = Math.random() * 2 * Math.PI;
			var deltaX: Float = STEP_DISTANCE * Math.cos(angle);
			var deltaY: Float = STEP_DISTANCE * Math.sin(angle);
			var dest: FlxPoint = new FlxPoint(this.getMidpoint().x + deltaX, this.getMidpoint().y + deltaY);
			FlxVelocity.moveTowardsPoint(this, dest, STEP_DISTANCE);
		} else {
			velocity.x = 0;
			velocity.y = 0;
		}

		animation.play("walk");

		handleFacing();
	}

	private function handleFacing()
	{
		flipX = (velocity.x < 0);
	}

	private function playerIsNear(): Bool
	{
		var playerPos: FlxPoint = getPlayer().getMidpoint();
		return Math.abs(x - playerPos.x) <= WARN_DISTANCE && Math.abs(y - playerPos.y) <= WARN_DISTANCE;
	}
}
