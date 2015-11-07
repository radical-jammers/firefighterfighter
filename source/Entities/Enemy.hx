package;

import flixel.FlxObject;

class Enemy extends Entity
{
	public var brain : StateMachine;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);

        this.world = world;

        brain = new StateMachine(null, onStateChange);
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
    	return true;
    }
}
