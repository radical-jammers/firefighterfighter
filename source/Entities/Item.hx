package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Item extends Entity
{
    private var collected: Bool;

    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
        immovable = true;
        collected = false;
    }

    public function onCollect(player: Player): Void
    {
		if (!collected) 
		{
			solid = false;
			collected = true;		
			FlxTween.tween(this.scale, {
				x: 0,
				y: 1.5
			}, 0.15, {
				onComplete: function(tween: FlxTween) {
					destroy();
				}
			});
		}
    }
}
