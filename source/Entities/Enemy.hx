package;

import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxRandom;

class Enemy extends Entity
{
	public static inline var LOOT_CHANCE: Float = 0.05;

	public var hp: Int;
	public var atk: Int;
	public var heat: Int;

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
		heat = 1;
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
    public function statusStunned()
    {
    	if (timer == null)
    	{
    		timer = new FlxTimer(StunnedTime, onStunnedEnd);
    	}

    	isStunned = true;
    	velocity.set();
    }

    public function onStunnedEnd(_t : FlxTimer)
    {
    	// Override me!
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

        isStunned = true;
    	brain.transition(statusStunned);
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
        isStunned = true;
		FlxTween.tween(this.scale, {
			x: 0,
			y: 1.5
		}, 0.15, {
			complete: function(tween: FlxTween) {
				world.enemies.remove(this);
				world.removeHeat(this);
				dropLoot();

				if (timer != null)
					timer.cancel();

                destroy();
			}
		});
	}

    override public function destroy()
    {
        trace("Enemy destroy");
        super.destroy();
    }

	public function dropLoot(): Void
	{
		var lootChance: Float = 1 - (Player.MAX_HP_VALUE - GameStatus.currentHp) * LOOT_CHANCE;
		if (FlxRandom.float() >= lootChance)
		{
			world.items.add(new ItemBottle(getMidpoint().x, getMidpoint().y, world));
		}
	}
}
