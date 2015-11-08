package;

class ItemBottle extends Entity
{
    public static inline var HP_AMOUNT: Int = 1;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
        loadGraphic("assets/images/item-bottle", false);
    }

    public override function update(): Void
    {
        FlxG.overlap(this, world.player, onCollect);
        super.update();
    }

    public function onCollect(bottle: CollectibleBottle, player: Player): Void
    {
        player.recoverHp(HP_AMOUNT);
    }
}
