package;

import flixel.FlxG;

class GameController
{
	public static function GetStageFirstMap(stageNumber : Int) : String
	{
		switch (stageNumber)
		{
			case 1:
				return "s1s1";
			case 2:
				return "s2s1";
			default:
				throw "FuCK yOU biAtch";
		}
	}


	/** Game Management API **/
	public static function ToTitleScreen()
	{
		FlxG.switchState(new MenuState());
	}

	public static function StartGame()
	{
		StartStage(1);
	}

	public static function StartStage(stageNumber : Int): Void
	{
		GameStatus.currentStage = stageNumber;
		var mapName : String = GetStageFirstMap(stageNumber);

		FlxG.switchState(new PreStage(stageNumber, mapName));
	}

	public static function PostStageScreen(stageNumber: Int): Void
	{
		FlxG.switchState(new PostStage(stageNumber));
	}

	public static function NextStage()
	{
		GameStatus.currentStage++;
		StartStage(GameStatus.currentStage);
		// RestartStage();
	}

	public static function RestartStage()
	{
		// Do something??
		StartStage(GameStatus.currentStage);
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

	public static function GameOver(): Void
	{
		FlxG.switchState(new GameOver());
	}
}
