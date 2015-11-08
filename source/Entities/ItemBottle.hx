package;

import flixel.FlxG;

class ItemBottle extends Item
{
    public static inline var HP_AMOUNT: Int = 1;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
        loadGraphic("assets/images/item-bottle.png", false);
    }

    public override function onCollect(player: Player): Void
    {
        player.recoverHp(HP_AMOUNT);
        destroy();
    }
}
