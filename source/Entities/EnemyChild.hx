package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;

class EnemyMother extends Enemy
{
	public static inline var ATTACK_VALUE: Int = 1;
	public static inline var HP_VALUE: Int = 5;

	private static inline var JumpIdleTime : Float = 1;
	private static inline var STEP_DISTANCE: Int = 8;
	private static inline var StunKnockbackSpeed : Int = 30;

	private var status: Int;
	private var roamTimer: FlxTimer;

	public function new(x: Float, y: Float, world: World)
	{
		super(x, y, world);

		loadGraphic("assets/images/walker-sheet.png", true, 8, 8);

		animation.add("idle", [0, 1, 2, 3, 3, 2, 1, 0], 6);
		animation.add("walk", [0, 1, 2, 3, 3, 2, 1, 0], 6);
		animation.add("stunned", [4, 5], 4);

		animation.play("walk");

		setSize(8, 8);
		offset.set(0, 0);

		hp = HP_VALUE;
		atk = ATTACK_VALUE;

		brain.transition(statusRoam, "roam");
		roamTimer = new FlxTimer();
		roamTimer.start(2.0, doRoam, 0);
	}

	public function statusIdle() : Void
	{
		animation.play("idle");
		velocity.set();
	}

	public function statusRoam(): Void
	{
		animation.play("walk");
	}

	override public function update(): Void
	{
		super.update();
	}

	public override function onCollisionWithPlayer(): Void
	{
		brain.transition(statusIdle, "idle");
		new FlxTimer(JumpIdleTime, function(_t:FlxTimer){
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
		brain.transition(statusRoam, "roam");
		timer = null;
	}

	private function doRoam(timer: FlxTimer): Void
	{
		trace("doRoam");
		var dir : Float = Math.random();

		if ( dir < 0.25 )
		{
			velocity.x = -STEP_DISTANCE;
			velocity.y = 0;
			facing = FlxObject.LEFT;
			flipX = true;
		} else if ( dir > 0.25 && dir < 0.5) 
		{
			velocity.x = STEP_DISTANCE;
			velocity.y = 0;
			facing = FlxObject.RIGHT;
			flipX = false;
		} else if ( dir > 0.5 && dir < 0.75) 
		{
			velocity.x = 0;
			velocity.y = -STEP_DISTANCE;
		} else if ( dir > 0.75) 
		{
			velocity.x = 0;
			velocity.y = STEP_DISTANCE;
		}

		brain.transition(statusRoam, "roam");

		new FlxTimer(JumpIdleTime, function(_t:FlxTimer){
			brain.transition(statusIdle, "idle");
		});
	}

	override public function onDefeat(): Void
    {
    	roamTimer.cancel();
    	
    	
        super.onDefeat();
    }

}
