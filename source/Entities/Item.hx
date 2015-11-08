package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Item extends Entity
{
    public function new(x: Float, y: Float, world: World)
    {
        super(x, y, world);
        immovable = true;
    }

    public function onCollect(player: Player): Void
    {
        FlxTween.tween(this.scale, {
			x: 0,
			y: 1.5
		}, 0.15, {
			complete: function(tween: FlxTween) {
                destroy();
			}
		});
    }
}
