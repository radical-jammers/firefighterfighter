package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;

class EnemySpreadingFire extends Enemy
{
    public static inline var ATTACK_VALUE: Int = 1;
    public static inline var HP_VALUE: Int = 10;

    private var spreadTimer: FlxTimer;
    private var spreadFireFather : GroupSpreadingFire;

    public function new(x: Float, y: Float, world: World, spreadFireFather : GroupSpreadingFire)
    {
        this.spreadFireFather = spreadFireFather;
        super(x, y, world);
        immovable = true;

        loadGraphic("assets/images/spreadingfire-sheet.png", true, 16, 24);
        animation.add("still",[0,1], 4);
        animation.play("still");

        setSize(16, 16);
        offset.set(0,8);

        hp = HP_VALUE;
        atk = ATTACK_VALUE;
    }

    override public function update(): Void
    {
        super.update();
    }

    public override function onCollisionWithPlayer(): Void {}

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
