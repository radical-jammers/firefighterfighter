package;

import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Enemy extends Entity
{
	public var hp: Int;
	public var atk: Int;

	public var StunnedTime : Float = 0.30;

	public var brain : StateMachine;

	public var timer : FlxTimer;

	public var isStunned : Bool;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);

        this.world = world;

        brain = new StateMachine(null, onStateChange);
        timer = null;

        isStunned = false;
    }

    public function getPlayer(): Player
    {
        return world.player;
    }

    override public function update()
    {
    	if (brain != null)
    		brain.update();

    	super.update();
    }

    // Override me!
    public function stunned()
    {
    	if (timer == null)
    	{
    		timer = new FlxTimer(StunnedTime, onStunnedEnd);
    	}

    	isStunned = true;
    	color = 0xFFAA0010;
    	velocity.set();
    }

    public function onStunnedEnd(_t : FlxTimer)
    {
    	// Override me!
    	color = 0xFFFFFFFF;
    	isStunned = false;
    	brain.transition(null);
    	timer = null;
    }

    public function onStateChange(nextState : String)
    {
    	// Override me!
    }

    /**
     * Override this method to handle the collision with a MIGHTY PUNCH'O
     */
    public function onPunched(punchMask : FlxObject) : Bool
    {
    	// Do override!
    	if (isStunned)
    		return false;

    	brain.transition(stunned);
    	return true;
    }

    public function receiveDamage(damage: Int): Void
    {
        if (hp > 0)
        {
            hp = Std.int(Math.max(0, hp - damage));
            if (hp == 0)
                onDefeat();
        }
    }

    public function onCollisionWithPlayer(): Void {}

	public function onDefeat(): Void
	{
        trace("ah, muero");
		FlxTween.tween(this.scale, {
			x: 0,
			y: 1.5
		}, 0.15, {
			complete: function(tween: FlxTween) {
				world.enemies.remove(this);
                destroy();
			}
		});
	}

    override public function destroy()
    {
        trace("Enemy destroy");
        super.destroy();
    }
}
