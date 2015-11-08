package;

import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.FlxObject;
import flixel.FlxG;

class EnemyBoxer extends Enemy
{
    public static inline var ATTACK_VALUE = 1;
    public static inline var HP_VALUE = 20;
    public static inline var SIGHT_DISTANCE = 32;
    public static inline var REACH_DISTANCE = 24;

    public var punchMask : FlxObject;
    public var attacking: Bool;
    public var currentAttack: Int;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);

        hp = HP_VALUE;
        atk = ATTACK_VALUE;
        immovable = true;
        attacking = false;
        isStunned = false;
        currentAttack = 0;
        facing = FlxObject.RIGHT;

        brain.transition(statusIdle, "idle");
        timer = new FlxTimer();
        timer.start(2.0, doFlip, 0);

        loadGraphic("assets/images/fighter-walk-sheet.png", true, 32, 24);
        setSize(8, 16);
        offset.set(12, 4);

        animation.add("idle", [0]);
        animation.add("attack-0", [2, 2], 8, false);
		animation.add("attack-1", [3, 3], 8, false);
		animation.add("stunned", [4]);

        animation.play("idle");

        punchMask = new FlxObject(x, y, 6, 8);
        punchMask.immovable = true;
        punchMask.kill();
    }

    public function statusIdle(): Void
    {
        if (playerIsOnSight())
        {
            timer.cancel();
            brain.transition(statusAlert, "alert");
            animation.play("idle");
        }
    }

    public function statusAlert(): Void
    {
        if (!playerIsOnSight())
        {
            attacking = false;
            brain.transition(statusIdle, "idle");
            timer.start(2.0, doFlip, 0);
            animation.play("idle");
        } else if (playerIsReachable() && !isStunned)
        {
            performAttack();
        } else if (!playerIsReachable()) {
            attacking = false;
            animation.play("idle");
        }
    }

    override public function statusStunned(): Void
	{
		isStunned = true;
	}

    public function doFlip(timer: FlxTimer): Void
    {
        if (facing == FlxObject.LEFT) {
            facing = FlxObject.RIGHT;
            flipX = false;
        }
        else {
            facing = FlxObject.LEFT;
            flipX = true;
        }
    }

    private function performAttack(): Void
    {
        if (!attacking)
        {
            attacking = true;
            animation.play("attack-" + currentAttack);
            currentAttack = (currentAttack + 1) % 2;
            positionPunchMask();
        }
        else
        {
            if (animation.finished)
            {
                attacking = false;
                punchMask.kill();
            } else
            {
                FlxG.overlap(punchMask, world.player, function onPunch(punch: FlxObject, player: Player) {
                    FlxObject.separate(this, player);
                    player.onCollisionWithEnemy(this);
                });
            }
        }
    }

    private function positionPunchMask(): Void
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

    private function playerIsOnSight(): Bool
	{
		var playerPos: FlxPoint = getPlayer().getMidpoint();
		return Math.abs(getMidpoint().x - playerPos.x) <= SIGHT_DISTANCE &&
            Math.abs(getMidpoint().y - playerPos.y) <= SIGHT_DISTANCE &&
            ((facing == FlxObject.LEFT && getMidpoint().x > playerPos.x) ||
            (facing == FlxObject.RIGHT && getMidpoint().x < playerPos.x));
	}

    private function playerIsReachable(): Bool
    {
        var playerPos: FlxPoint = getPlayer().getMidpoint();
        return Math.abs(getMidpoint().x - playerPos.x) <= REACH_DISTANCE &&
            Math.abs(getMidpoint().y - playerPos.y) <= REACH_DISTANCE &&
            ((facing == FlxObject.LEFT && getMidpoint().x > playerPos.x) ||
            (facing == FlxObject.RIGHT && getMidpoint().x < playerPos.x));
    }

    public override function onPunched(punchMask: FlxObject) : Bool
	{
		if (isStunned)
			return false;

		receiveDamage(getPlayer().atk);

		if (punchMask.getMidpoint().x < getMidpoint().x) {
            flipX = true;
            facing = FlxObject.LEFT;
        }
		else
        {
            flipX = false;
            facing = FlxObject.RIGHT;
        }

		if (hp > 0)
		{
			brain.transition(statusStunned);
            attacking = false;

            timer.start(StunnedTime, function onStunnedEnd(stunnedTimer: FlxTimer) {
                isStunned = false;
                brain.transition(statusIdle, "idle");
                timer.start(2.0, doFlip, 0);
                animation.play("idle");
            });

			isStunned = true;
            animation.play("stunned");
		}
		return true;
    }
}
