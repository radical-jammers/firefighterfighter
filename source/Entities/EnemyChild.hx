package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;

class EnemyChild extends Enemy
{
	public static inline var ATTACK_VALUE: Int = 1;
	public static inline var HP_VALUE: Int = 5;

	private static inline var JumpingTime : Float = 0.65;
	private static inline var STEP_DISTANCE: Int = 16;
	private static inline var StunKnockbackSpeed : Int = 30;

	private var status: Int;
	private var roamTimer: FlxTimer;

	public function new(x: Float, y: Float, graph : String, world: World)
	{
		super(x, y, world);

		loadGraphic(graph, true, 12, 32);

		animation.add("idle", [0, 1, 2, 2, 1, 0], 5);
		animation.add("walk", [3, 3, 0, 4, 5, 6, 7, 7, 6, 5, 4, 0, 3, 3], 18, false);
		animation.add("stunned", [4, 5], 4);

		animation.play("walk");

		setSize(8, 16);
		offset.set(2, 16);

		hp = HP_VALUE;
		atk = ATTACK_VALUE;

		brain.transition(statusStunned, "stunned");
		roamTimer = new FlxTimer();
	}

	public function statusIdle() : Void
	{
		animation.play("idle");
		velocity.set();
	}

	public function statusRoam(): Void
	{

	}

	override public function update(): Void
	{
		super.update();
	}

	public override function onCollisionWithPlayer(): Void
	{
		brain.transition(statusIdle, "idle");
		new FlxTimer(JumpingTime, function(_t:FlxTimer){
			brain.transition(statusRoam, "roam");
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
			brain.transition(statusStunned);
			isStunned = true;
		}
		return true;
	}

	override public function statusStunned(): Void
	{
		if (timer == null)
		{
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
		roamTimer.start(1.0, doRoam, 0);
		brain.transition(statusRoam, "roam");
		timer = null;
	}

	private function doRoam(timer: FlxTimer): Void
	{
		var dir : Float = Math.random();

		if ( dir < 0.25 )
		{
			velocity.x = -STEP_DISTANCE/JumpingTime;
			velocity.y = 0;
			facing = FlxObject.LEFT;
			flipX = true;
		} else if ( dir > 0.25 && dir < 0.5) 
		{
			velocity.x = STEP_DISTANCE/JumpingTime;
			velocity.y = 0;
			facing = FlxObject.RIGHT;
			flipX = false;
		} else if ( dir > 0.5 && dir < 0.75) 
		{
			velocity.x = 0;
			velocity.y = -STEP_DISTANCE/JumpingTime;
		} else if ( dir > 0.75) 
		{
			velocity.x = 0;
			velocity.y = STEP_DISTANCE/JumpingTime;
		}

		animation.play("walk", true);
		brain.transition(statusRoam, "roam");

		new FlxTimer(JumpingTime, function(_t:FlxTimer){
			brain.transition(statusIdle, "idle");
		});
	}

	override public function onDefeat(): Void
    {
    	roamTimer.cancel();
        super.onDefeat();
    }

}
