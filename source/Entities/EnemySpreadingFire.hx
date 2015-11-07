package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxObject;

class EnemySpreadingFire extends Enemy
{
    private static inline var ATTACK_VALUE: Int = 5;
    private static inline var HP_VALUE: Int = 10;

    private var spreadTimer: FlxTimer;
    private var spreadFireFather : GroupSpreadingFire;

    var particles : flixel.effects.particles.FlxEmitterExt;

    public function new(x: Float, y: Float, world: World, spreadFireFather : GroupSpreadingFire)
    {
        this.spreadFireFather = spreadFireFather;
        super(x, y + 8, world);
        immovable = true;
        solid = false;
        
        this.scale = new FlxPoint(0,0);
        loadGraphic("assets/images/spreadingfire-sheet.png", true, 16, 24);
        animation.add("still",[0,1], 4);
        animation.play("still");

        setSize(16, 16);
        offset.set(0, 8);

        particles = new flixel.effects.particles.FlxEmitterExt();
        particles.width = 16;
        particles.height = 16;
        particles.setRotation(0, 0);
        particles.setMotion(-45, 15, 180);
        particles.makeParticles("assets/images/fire-particles.png", 6, 0, true, 0);
        particles.setAlpha(1, 1, 0, 0);
        particles.setScale(1, 2, 0, 0.25);

        particles.x = x;
        particles.y = y;
        particles.start(false, 2, 0.1, 0);

        hp = HP_VALUE;

        FlxTween.tween(this.scale, {
            x: 1,
            y: 1
        }, 0.5, {
            complete: function(tween: FlxTween) {
                solid = true;
            }
        });

        FlxTween.tween(this, {
            y : y - 8
        }, 0.5, {
            complete: function(tween: FlxTween) {
                solid = true;
            }
        });
    }

    override public function update(): Void
    {
        particles.update();
        super.update();
    }

    override public function draw() : Void
    {
        super.draw();
        particles.draw();
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
        particles.destroy();
        spreadFireFather.remove(this);
        super.destroy();
    }

}
