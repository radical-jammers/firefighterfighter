package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import text.PixelText;
import flixel.util.FlxTimer;
import flixel.FlxCamera;

class PreStage extends GameState
{
    private var remainingLives: FlxSprite;
    private var playerPic: FlxSprite;
    private var preStageTimer: FlxTimer;

    private var stageNumber: Int;
    private var stageName : String;

    public function new(stageNumber: Int, mapName : String)
    {
        this.stageNumber = stageNumber;
        this.stageName = mapName;
        super();
    }

    public override function create(): Void
    {
        super.create();

        FlxG.camera.bgColor = GameConstants.DARK_BG_COLOR;

        add(PixelText.New(FlxG.width / 2 - 48, 2 * FlxG.height / 3, "Stage " + stageNumber + " Start"));
        add(PixelText.New(FlxG.width / 2 - 4, FlxG.height / 2, "x"));

        playerPic = new FlxSprite(FlxG.width / 2 - 32, FlxG.height / 2 - 12);
        remainingLives = new FlxSprite(FlxG.width / 2 + 8, FlxG.height / 2 - 5);

        playerPic.loadGraphic("assets/images/fighter-walk-sheet.png", true, 32, 24);

        remainingLives.loadGraphic("assets/images/hud-timer.png", true, 8, 16);
        remainingLives.animation.add("lives", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
        remainingLives.animation.play("lives");
        remainingLives.animation.pause();
        remainingLives.animation.frameIndex = GameStatus.lives;

        add(playerPic);
        add(remainingLives);

        preStageTimer = new FlxTimer().start(2.0, function(timer: FlxTimer) {
            GameController.Teleport(stageName);
        });
    }
}
