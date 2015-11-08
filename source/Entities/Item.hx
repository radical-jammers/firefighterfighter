package;

class Item extends Entity
{
    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
    }

    public function onCollect(player: Player): Void {}
}
