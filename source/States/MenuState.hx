package;

import flash.system.System;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import text.PixelText;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends GameState
{
	var titleText : FlxText;
	var menuText : FlxText;

	var currentOption : Int;
	var options : Int;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		FlxG.sound.volume = 1;

		/*var zoom  = FlxG.camera.zoom;
		FlxG.cameras.reset(new FlxCamera(Std.int((FlxG.width / 2 - 80) * zoom), 0, 160, 160, 0));*/

		add(PixelText.New(FlxG.width / 2 - 48, 2 * FlxG.height / 3, "Press Start"));

		var fixedSM : flixel.system.scaleModes.PixelPerfectScaleMode = new PixelPerfectScaleMode();
		FlxG.scaleMode = fixedSM;
		FlxG.camera.bgColor = GameConstants.DARK_BG_COLOR;

		// GameController.init();
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();

		titleText = null;
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (GamePad.justPressed(GamePad.Start) || GamePad.justPressed(GamePad.A))
			handleSelectedOption();
		else if (GamePad.justReleased(GamePad.Select))
			System.exit(0);
	}

	function handleSelectedOption()
	{
		// Start game
		GameController.StartGame();
	}
}
