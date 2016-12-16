package;

import flixel.util.FlxTimer;
import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxObject;

class EnemySpreadingFire extends Enemy
{
    public static inline var ATTACK_VALUE: Int = 1;
    public static inline var HP_VALUE: Int = 5;

    private var spreadTimer: FlxTimer;
    private var spreadFireFather : GroupSpreadingFire;

    var particles : flixel.effects.particles.FlxEmitter;

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

        setSize(12, 12);
        offset.set(2, 10);

        var angle = -45 * Math.PI / 180;
        particles = new flixel.effects.particles.FlxEmitter();
        particles.width = 16;
        particles.height = 16;
        particles.speed.set(15, 15);
        particles.angle.set(angle, angle);
        particles.loadParticles("assets/images/fire-particles.png", 6, 0, true);
        particles.alpha.set(1, 1, 0, 0);
        particles.scale.set(1, 2, 0, 0.25);
        particles.lifespan.set(2);

        particles.x = x;
        particles.y = y;
        particles.start(false, 0.1, 0);

        hp = HP_VALUE;
        atk = ATTACK_VALUE;

        FlxTween.tween(this.scale, {
            x: 1,
            y: 1
        }, 0.5, {
            onComplete: function(tween: FlxTween) {
                solid = true;
            }
        });

        FlxTween.tween(this, {
            y : this.y - 8
        }, 0.5, {
            onComplete: function(tween: FlxTween) {
                solid = true;
            }
        });
    }

    override public function update(elapsed:Float): Void
    {
        particles.update(elapsed);
        super.update(elapsed);
    }


    public override function onCollisionWithPlayer(): Void {}

    override public function draw() : Void
    {
        super.draw();
        particles.draw();
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
