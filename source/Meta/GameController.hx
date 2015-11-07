package;

import flixel.FlxG;

class GameController
{
	/** Game Management API **/
	public static function ToTitleScreen()
	{
		FlxG.switchState(new MenuState());
	}

	public static function StartGame()
	{
		FlxG.switchState(new World());
	}

	public static function Teleport(target : String)
	{
		GameStatus.currentMapName = target;

		FlxG.switchState(new World(target));
	}

	public static function startStage(stageNumber: Int): Void
	{
		FlxG.switchState(new PreStage(stageNumber));
	}
}
