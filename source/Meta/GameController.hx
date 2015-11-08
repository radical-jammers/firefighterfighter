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
		StartStage(1, "w1s1");
	}

	public static function StartStage(stageNumber : Int, mapName : String): Void
	{
		GameStatus.currentStage = stageNumber;

		FlxG.switchState(new PreStage(stageNumber, mapName));
	}

	public static function RestartStage()
	{
		// GameStatus.currentMapName = currentStage
		FlxG.switchState(new PreStage(GameStatus.currentStage, GameStatus.currentMapName));
	}

	// Next Scene
	public static function Teleport(target : String)
	{
		GameStatus.currentMapName = target;

		FlxG.switchState(new World());
	}

	public static function RestartScene()
	{
		FlxG.switchState(new PreStage(GameStatus.currentStage, GameStatus.currentMapName));	
	}
}
