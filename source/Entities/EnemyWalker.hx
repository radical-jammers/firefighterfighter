package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;

class EnemyWalker extends Enemy
{

    public static inline var STATUS_ROAM: Int = 1;
    public static inline var STATUS_FETCH: Int = 2;
    private static inline var STEP_DISTANCE: Int = 8;
    private static inline var WARN_DISTANCE: Int = 32;

    private var status: Int;
    private var roamTimer: FlxTimer;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
        status = STATUS_ROAM;
        roamTimer = new FlxTimer();
        roamTimer.start(1.0, doRoam, 0);
        makeGraphic(16, 16);
    }

    override public function update(): Void
    {
        switch (status)
        {
            case STATUS_ROAM:

                if (playerIsNear())
                {
                    status = STATUS_FETCH;
                    roamTimer.cancel();
                }
            case STATUS_FETCH:
                if (!playerIsNear())
                {
                    status = STATUS_ROAM;
                    roamTimer.start(1.0, doRoam, 0);
                } else
                {
                    FlxVelocity.moveTowardsPoint(this, getPlayer().getMidpoint(), STEP_DISTANCE * 2);
                }
        }

        super.update();
    }

    public function collideWithPlayer(): Void
    {
        FlxG.collide(this, getPlayer(), onCollisionWithPlayer);
    }

    private function onCollisionWithPlayer(self: Dynamic, player: Dynamic): Void
    {
        // Hurts player
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
