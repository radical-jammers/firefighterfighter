package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;

class EnemyWalker extends Enemy
{
    private static inline var STEP_DISTANCE: Int = 8;
    private static inline var WARN_DISTANCE: Int = 32;
    private static inline var ATTACK_VALUE: Int = 5;
    private static inline var HP_VALUE: Int = 20;

    private var status: Int;
    private var roamTimer: FlxTimer;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
        hp = HP_VALUE;
        brain.transition(statusRoam, "roam");
        roamTimer = new FlxTimer();
        roamTimer.start(1.0, doRoam, 0);
        makeGraphic(16, 16);
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
        }
    }

    override public function update(): Void
    {
        super.update();
    }

    public override function onCollisionWithPlayer(): Void
    {
        getPlayer().receiveDamage(ATTACK_VALUE);
    }

    public override function onPunched(punchMask: FlxObject) : Bool
    {
    	if (isStunned)
    		return false;

        receiveDamage(getPlayer().atk);

        if (hp > 0)
        {
            brain.transition(stunned);
            isStunned = true;
        }

    	return true;
    }

    public override function onStunnedEnd(_t : FlxTimer): Void
    {
    	color = 0xFFFFFFFF;
    	isStunned = false;
    	brain.transition(statusFetch, "fetch");
    	timer = null;
    }

    public override function onDefeat(): Void
    {
        world.enemies.remove(this);
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
    }

    private function playerIsNear(): Bool
    {
        var playerPos: FlxPoint = getPlayer().getMidpoint();
        return Math.abs(x - playerPos.x) <= WARN_DISTANCE && Math.abs(y - playerPos.y) <= WARN_DISTANCE;
    }
}
