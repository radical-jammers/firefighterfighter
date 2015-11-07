package;

class Enemy extends Entity
{
    public function new(x: Float, y: Float, world: World)
    {
        this.world = world;
        super(x, y, world);
    }

    public function getPlayer(): Player
    {
        return world.player;
    }

    public function onCollisionWithPlayer(): Void {}
}
