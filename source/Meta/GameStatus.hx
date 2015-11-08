package;

class GameStatus
{
    public static var lives: Int = 5;
    public static var currentHp: Int = 5;
    public static var currentStage: Int = 1;
    public static var currentMapName : String = "w1s1";

    public static function reset(): Void
    {
        lives = 5;
        currentHp = 5;
        currentStage = 1;
        currentMapName = "w1s1";
    }
}
