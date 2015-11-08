package;

import flixel.FlxObject;
import flixel.util.FlxRect;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

class Hostage extends Entity
{
	public static inline var MinIdleTime : Float = 0.7;
	public static inline var MaxIdleTime : Float = 2;

	public var brain : StateMachine;

	public function new(X : Float, Y : Float, World : World, Graphic : String, GraphicSize : FlxPoint, ?Mask : FlxRect = null)
	{
		super(X, Y, World);

		var graphicPath : String = "assets/images/" + Graphic + ".png";

		loadGraphic(graphicPath, true, Std.int(GraphicSize.x), Std.int(GraphicSize.y));
		animation.add("idle", [0]);
		animation.add("anim", [0, 1, 2, 3], 4, false);

		if (Mask != null)
		{
			setSize(Mask.width, Mask.height);
			offset.set(Mask.x, Mask.y);
		}

		brain = new StateMachine(null, onStateChange);
	}

	override public function update()
	{
		brain.update();

		super.update();
	}

	public function onStateChange(newState : String)
	{
		switch (newState)
		{
			case "idle":
				animation.play("idle");
				new FlxTimer(FlxRandom.floatRanged(MinIdleTime, MaxIdleTime), function (_t:FlxTimer) {
					brain.transition(anim, "anim");
				});
			case "anim":
				animation.play("idle");
		}
	}

	public function idle()
	{
		if (world.player.getMidpoint().x < getMidpoint().x)
			flipX = true;
		else
			flipX = false;

		animation.play("idle");
	}

	public function anim()
	{
		if (animation.finished)
			brain.transition(idle, "idle");
	}
}