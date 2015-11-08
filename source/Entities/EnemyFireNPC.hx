package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class EnemyFireNPC extends Enemy
{
	public static inline var ATTACK_VALUE: Int = 1;
	public static inline var HP_VALUE: Int = 20;

	private static inline var AttackIdleTime : Float = 1;
	private static inline var STEP_DISTANCE: Int = 16;
	private static inline var FIRE_DISTANCE: Int = 32;
	private static var RUN_DISTANCE: Int = 64;
	private static inline var StunKnockbackSpeed : Int = 30;

	private var status: Int;
	private var roamTimer: FlxTimer;
	private var onFire : Bool = false;
	private var velocityX : Float;
	private var velocityY : Float;

	public function new(x: Float, y: Float, world: World)
	{
		super(x, y, world);

		loadGraphic("assets/images/walker-sheet.png", true, 24, 24);

		animation.add("walk", [0, 1, 2, 3, 3, 2, 1, 0], 6);
		animation.add("run", [0, 1, 2, 3, 3, 2, 1, 0], 8);
		animation.add("onFire", [0, 1, 2, 3, 3, 2, 1, 0], 14);
		animation.add("stunned", [4, 5], 4);

		animation.play("walk");

		setSize(12, 8);
		offset.set(6, 14);

		hp = HP_VALUE;
		atk = ATTACK_VALUE;
		heat = 1;

		brain.transition(statusRoam, "roam");
		roamTimer = new FlxTimer();
		roamTimer.start(1.0, doRoam, 0);
	}

	public function statusIdle() : Void
	{
		animation.play("walk");
		velocity.set();
	}

	public function statusRoam(): Void
	{
		if (fireIsNear(world.enemies) != null)
		{
			roamTimer.cancel();
			brain.transition(statusFetch, "fetch");
		}
	}

	public function statusFetch(): Void
	{	
		var fire : Enemy = fireIsNear(world.enemies);
		if (fire == null)
		{
			roamTimer.start(1.0, doRoam, 0);
			brain.transition(statusRoam, "roam");
		} else
		{
			FlxVelocity.moveTowardsPoint(this, fire.getMidpoint(), STEP_DISTANCE);
			animation.play("run");
			handleFacing();
		}
	}

	public function statusOnFire(): Void
	{
		FlxG.collide(this, world.solids, changeWay);
		FlxG.collide(getPlayer(), this, onCollisionPlayerEnemy);
		FlxG.overlap(getPlayer().punchMask, this, onCollisionWithPUNCHO);
	}

	public function changeWay(itsMe : EnemyFireNPC, solid : Entity)
	{
		trace("colide!!!!!!!!!");
		trace("solid.x: " + solid.x);
		trace("solid.width: " + solid.width);
		trace("this.x: " + this.x);
		trace("this.width: " + this.width);
		trace("solid.y: " + solid.y);
		trace("solid.height: " + solid.height);
		trace("this.y: " + this.y);
		trace("this.height: " + this.height);
		if ((solid.x + solid.width) <= this.x) //At my left!
		{
			trace(this.velocity);
			this.velocity.set(-velocityX, velocityY);
			trace(this.velocity);
			trace("At my left!");
		}

		if (solid.x <= (this.x + this.width)) //At my right!
		{
			trace(this.velocity);
			this.velocity.set(-velocityX, velocityY);
			trace(this.velocity);
			trace("At my right!");
		}

		if ((solid.y + solid.height) <= this.y) //At my top!
		{
			trace(this.velocity);
			this.velocity.set(velocityX, -velocityY);
			trace(this.velocity);
			trace("At my top!");
		}

		if (solid.y >= (this.y + this.height)) //At my bottom!
		{
			trace(this.velocity);
			this.velocity.set(velocityX, -velocityY);
			trace(this.velocity);
			trace("At my bottom!");
		}
	}

	override public function update(): Void
	{
		velocityX = velocity.x;
		velocityY = velocity.y;
		super.update();
	}

	override public function onStateChange(nextState : String)
    {
    	if (nextState == "onFire")
    	{
    		onFire = true;
    		setOnFire();
    	}
    }

	private function setOnFire(): Void
	{
		trace("setOnFire");
		//Nos eliminamos de la lista de enemigos y enemigos collidables para autogestionarnos nuestras colisiones
		world.enemies.remove(this,true);
		world.collidableEnemies.remove(this,true);

		var succesfullTarget : Bool = false;
		while (!succesfullTarget) {
			var angle: Float = Math.random() * 2 * Math.PI;
			var deltaX: Float = RUN_DISTANCE * Math.cos(angle);
			var deltaY: Float = RUN_DISTANCE * Math.sin(angle);
			var dest: FlxPoint = new FlxPoint(this.getMidpoint().x + deltaX, this.getMidpoint().y + deltaY);
			if (!this.overlapsAt(dest.x, dest.y, world.solids))
			{
				FlxVelocity.moveTowardsPoint(this, dest, RUN_DISTANCE);
				succesfullTarget = true;
			}
		}

		animation.play("onFire");

		handleFacing();
	}

	public function onCollisionWithEnemy(): Void
	{
		brain.transition(statusIdle, "idle");
		new FlxTimer(AttackIdleTime/2, function(_t:FlxTimer){
			brain.transition(statusOnFire, "onFire");
		});
	}

	public function onCollisionPlayerEnemy(player: Player, enemy: Enemy): Void
	{
		player.onCollisionWithEnemy(enemy);
		enemy.onCollisionWithPlayer();
	}

	public override function onCollisionWithPlayer(): Void
	{
		brain.transition(statusIdle, "idle");
		isStunned = false;
		new FlxTimer(AttackIdleTime, function(_t:FlxTimer){
			brain.transition(statusOnFire, "onFire");
		});
	}

	public function onCollisionWithPUNCHO(punchMask: FlxObject, enemy: FlxObject)
	{
		onPunched(punchMask);
	}

	public override function onPunched(punchMask: FlxObject) : Bool
	{
		if (isStunned)
			return false;

		velocity.set();
		receiveDamage(getPlayer().atk);

		if (punchMask.getMidpoint().x < getMidpoint().x)
			flipX = true;
		else
			flipX = false;

		if (hp > 0)
		{
			brain.transition(statusStunned, "stunned");
			isStunned = true;
		}
		return true;
	}

	public override function statusStunned(): Void
	{

		if (onFire)
		{
			FlxG.collide(this, world.solids, changeWay);
			FlxG.collide(getPlayer(), this, onCollisionPlayerEnemy);
			FlxG.overlap(getPlayer().punchMask, this, onCollisionWithPUNCHO);
		}
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
		if (!onFire)
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

	private function doFireRoam(timer: FlxTimer): Void
	{
		var succesfullTarget : Bool = false;
		while (!succesfullTarget) {
			var angle: Float = Math.random() * 2 * Math.PI;
			var deltaX: Float = RUN_DISTANCE * Math.cos(angle);
			var deltaY: Float = RUN_DISTANCE * Math.sin(angle);
			var dest: FlxPoint = new FlxPoint(this.getMidpoint().x + deltaX, this.getMidpoint().y + deltaY);
			if (!this.overlapsAt(dest.x, dest.y, world.solids))
			{
				FlxVelocity.moveTowardsPoint(this, dest, RUN_DISTANCE);
				succesfullTarget = true;
			}
		}

		animation.play("onFire");

		handleFacing();
	}

	private function handleFacing()
	{
		flipX = (velocity.x < 0);
	}

	private function fireIsNear(obj: FlxBasic): Enemy
	{

		if (Std.is(obj, Enemy) && cast(obj, Enemy) != this)
		{
			var enemy: Enemy = cast(obj, Enemy);
			var firePos: FlxPoint = enemy.getMidpoint();
			if (Math.abs(x - firePos.x) <= FIRE_DISTANCE && Math.abs(y - firePos.y) <= FIRE_DISTANCE)
				return enemy;
		}else if (Std.is(obj, Enemy)){
			return null;
		}else
		{
			var enemies: FlxTypedGroup<Dynamic> = cast(obj, FlxTypedGroup<Dynamic>);
			for (enemy in enemies)
			{
				var fire : Enemy = fireIsNear(enemy);
				if (fire != null)
					return fire;
			}
		}
		return(null);
	}
}
