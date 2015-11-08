package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxPoint;

class CutscenePlayer extends Entity
{
	public static inline var Idle1Time : Float = 0.6;
	public static inline var Idle2Time : Float = 0.1243553;

	public static inline var JumpHeight : Float = 24;
	public static inline var JumpDuration : Float = 0.35;

	public static inline var RunAcceleration : Float = 900;

	public static inline var ExitRunSpeed : Float = 180;
	public static inline var ExitJumpDuration : Float = 0.7;
	public static inline var ExitFadeDuration : Float = 0.5;

	public var hostage : Hostage;

	public var brain : StateMachine;
	public var timer : FlxTimer;

	public var originalPos : FlxPoint;

	public var exitThreshold : Float;

	public function new(X : Float, Y : Float, World : World, CurrentHostage : Hostage)
	{
		super(X, Y, World);

		hostage = CurrentHostage;

		loadGraphic("assets/images/fighter-walk-sheet.png", true, 32, 24);

		animation.add("idle", [5]);
		animation.add("run", [6, 5], 8);
		animation.add("jump", [6]);

		replaceColor(0xFFFF00FF,0x00000000);

		setSize(12, 12);
		offset.set(10, 12);

		brain = new StateMachine(null, onStateChange);
		timer = new FlxTimer();

		originalPos = new FlxPoint(x, y);

		maxVelocity.set(200, 200);

		exitThreshold = world.level.fullWidth * 0.6;

		brain.transition(idle, "idle1");
	}

	override public function update()
	{
		brain.update();

		super.update();

		hostage.x = x;
		hostage.y = y - hostage.height - 4;
		hostage.update();
	}

	override public function draw()
	{
		super.draw();
		hostage.draw();
	}

	public function onStateChange(nextState : String)
	{
		trace("to " + nextState);
		switch (nextState)
		{
			case "idle1":
				timer.start(Idle1Time, function(t:FlxTimer) {
					brain.transition(jump, "jump1");
				});
			case "jump1":
				FlxTween.linearPath(this, [new FlxPoint(x, y), new FlxPoint(x, y - JumpHeight), new FlxPoint(x, y)], JumpDuration, { /*ease: FlxEase.sineOut, */complete : function(t:FlxTween) {
					animation.play("idle");
					new FlxTimer(0.1, function(_t:FlxTimer) {
						brain.transition(jump, "jump2");
					});
				}});
			case "jump2":
				FlxTween.linearPath(this, [new FlxPoint(x, y), new FlxPoint(x, y - JumpHeight), new FlxPoint(x, y)], JumpDuration, { /*ease: FlxEase.sineOut, */complete : function(t:FlxTween) {
					animation.play("idle");
					new FlxTimer(0.1, function(_t:FlxTimer) {
						brain.transition(idle, "idle2");
					});
				}});
			case "idle2":
				timer.start(Idle1Time, function(t:FlxTimer) {
					brain.transition(run, "run");
				});
			case "run":
			case "exit":
				FlxG.timeScale = 0.4;
				FlxG.camera.followLerp = 14;

				FlxG.camera.fade(0xFF000000, ExitFadeDuration, endCutscene);

				FlxTween.linearPath(this, [new FlxPoint(x, y), new FlxPoint(x + ExitRunSpeed * ExitJumpDuration / 2, y - JumpHeight), new FlxPoint(x + ExitRunSpeed * ExitJumpDuration, y)], ExitJumpDuration, { complete: function (t:FlxTween) {
					brain.transition(null); // ??
				}});
		}
	}

	public function idle()
	{
		animation.play("idle");
	}

	public function jump()
	{
		animation.play("jump");
	}

	public function run()
	{
		animation.play("run");
		acceleration.x = RunAcceleration;

		if (x > exitThreshold)
		{
			brain.transition(exit, "exit");
		}
	}

	public function exit()
	{
		animation.play("jump");
	}

	public function endCutscene()
	{
		FlxG.timeScale = 1;
		//GameController.NextStage();
		GameController.PostStageScreen(GameStatus.currentStage);
	}

	override public function positionShadow()
	{
		if (animation.name == "jump")
		{
			shadow.x = originalPos.x + width/2 - shadow.width/2;
			shadow.y = originalPos.y + height - shadow.height/2;
		}
		else
		{
			super.positionShadow();
		}
	}
}
