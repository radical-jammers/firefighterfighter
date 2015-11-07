package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;

class EnemySpreadingFire extends Enemy
{
    private static inline var ATTACK_VALUE: Int = 5;
    private static inline var HP_VALUE: Int = 10;

    private var spreadTimer: FlxTimer;
    private var spreadFireFather : GroupSpreadingFire;

    public function new(x: Float, y: Float, world: World, spreadFireFather : GroupSpreadingFire)
    {
        this.spreadFireFather = spreadFireFather;
        super(x, y, world);
        immovable = true;

        //Animation needed
        makeGraphic(16, 16);
        setSize(16, 16);

        hp = HP_VALUE;
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

        if (punchMask.getMidpoint().x < getMidpoint().x)
            flipX = true;
        else
            flipX = false;

        if (hp > 0)
        {
            brain.transition(stunned);
            isStunned = true;
        }
        return true;
    }


    override public function onDefeat(): Void
    {
        super.onDefeat();
    }

    override public function destroy(): Void
    {
        trace("EnemySpreadingFire destroy");
        spreadFireFather.remove(this);
        super.destroy();
    }

}
