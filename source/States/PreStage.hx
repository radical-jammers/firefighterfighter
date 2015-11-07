package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import text.PixelText;
import flixel.util.FlxTimer;

class PreStage extends GameState
{
    private var remainingLives: FlxSprite;
    private var playerPic: FlxSprite;
    private var preStageTimer: FlxTimer;

    private var stageNumber: Int;

    public function new(stageNumber: Int)
    {
        this.stageNumber = stageNumber;
        super();
    }

    public override function create(): Void
    {
        super.create();

        add(PixelText.New(FlxG.width / 2 - 48, 2 * FlxG.height / 3, "Stage " + stageNumber + " Start"));
        add(PixelText.New(FlxG.width / 2 - 4, FlxG.height / 2, "x"));

        playerPic = new FlxSprite(FlxG.width / 2 - 32, FlxG.height / 2 - 12);
        remainingLives = new FlxSprite(FlxG.width / 2 + 8, FlxG.height / 2 - 4);

        playerPic.loadGraphic("assets/images/fighter-walk-sheet.png", false, 32, 24);

        remainingLives.loadGraphic("assets/images/hud-timer.png", true, 8, 16);
        remainingLives.animation.add("lives", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
        remainingLives.animation.play("lives");
        remainingLives.animation.pause();
        remainingLives.animation.frameIndex = GameStatus.lives;

        add(playerPic);
        add(remainingLives);

        preStageTimer = new FlxTimer(2.0, function(timer: FlxTimer) {
            GameController.StartGame();
        });
    }
}