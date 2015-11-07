package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;

class EnemySpreadingFire extends Enemy
{
    private static inline var SPREAD_DISTANCE: Int = 16;

    private var spreadTimer: FlxTimer;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
        immovable = true;
        //Animation needed
        makeGraphic(16, 16);
    }

    override public function update(): Void
    {
        super.update();
    }

    override public function onCollisionWithPlayer(): Void
    {
        // Hurts player
    }

}
