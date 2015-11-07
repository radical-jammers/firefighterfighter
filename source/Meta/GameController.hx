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
		StartStage(1, "test0");
	}

	public static function Teleport(target : String)
	{
		GameStatus.currentMapName = target;

		FlxG.switchState(new World());
	}

	public static function StartStage(stageNumber : Int, mapName : String): Void
	{
		GameStatus.currentStage = stageNumber;

		FlxG.switchState(new PreStage(stageNumber, mapName));
	}

	public static function RestartStage()
	{
		FlxG.switchState(new World());
	}
}
