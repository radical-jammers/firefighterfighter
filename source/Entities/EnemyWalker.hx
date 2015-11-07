package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;

class EnemyWalker extends Entity
{

    public static inline var STATUS_ROAM: Int = 1;
    public static inline var STATUS_FETCH: Int = 2;
    private static inline var STEP_DISTANCE: Int = 8;

    private var status: Int;
    private var roamTimer: FlxTimer;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
        status = STATUS_ROAM;
        roamTimer = new FlxTimer(1.0, doRoam, 0);
        makeGraphic(16, 16);
    }

    override public function update(): Void
    {
        switch (status)
        {
            case STATUS_ROAM:
            case STATUS_FETCH:
        }

        super.update();
    }

    private function doRoam(timer: FlxTimer): Void
    {
        if (Math.random() > 0.5) {
            var angle: Float = Math.random() * 2 * Math.PI;
            var deltaX: Float = STEP_DISTANCE * Math.cos(angle);
            var deltaY: Float = STEP_DISTANCE * Math.sin(angle);

            trace("angle = " + angle);
            trace("deltaX = " + deltaX);
            trace("deltaY = " + deltaY);

            var dest: FlxPoint = new FlxPoint(this.getMidpoint().x + deltaX, this.getMidpoint().y + deltaY);

            trace("midpoint = " + this.getMidpoint());
            trace("newX = " + dest.x);
            trace("newY = " + dest.y);

            FlxVelocity.moveTowardsPoint(this, dest, STEP_DISTANCE);
        } else {
            velocity.x = 0;
            velocity.y = 0;
        }
    }
}
