package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.text.FlxBitmapText;
import flixel.math.FlxRandom;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;

import text.PixelText;

class PauseMenu extends FlxSubState
{
	var group : FlxSpriteGroup;
	var text : FlxBitmapText;
	var bg : FlxSprite;
	
	var ready : Bool;

	public function new()
	{
		super(0x00000000);

		group = new FlxSpriteGroup(0, FlxG.height);

		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.scrollFactor.set();

		text = PixelText.New(FlxG.width / 2 - 48, FlxG.height / 4, " ~ PAUSED! ~ ");
		text.scrollFactor.set();

		group.scrollFactor.set();

		group.add(bg);
		group.add(text);

		add(group);

		ready = false;
		
		FlxTween.tween(group, {y: 0}, 0.5, { ease: FlxEase.bounceOut, onComplete: function(_t:FlxTween){
			ready = true;
		}});
	}

	override public function close()
	{
		super.close();
	}

	override public function update(elapsed:Float)
	{
		GamePad.handlePadState();
		if (ready) 
		{
			if (GamePad.justReleased(GamePad.Start))
			{
				FlxTween.tween(group, {y: FlxG.height}, 0.5, { ease: FlxEase.bounceOut, onComplete: function(_t:FlxTween) {
					close();
				}});
			}
		}

		super.update(elapsed);
	}
}
