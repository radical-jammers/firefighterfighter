package;

import text.PixelText;
import flixel.text.FlxBitmapTextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxCamera;

class PostStage extends GameState
{
    private var scoreText: FlxBitmapTextField;
    private var stageNumber: Int;
    private var score: Int;
    private var fakeScore1: Int;
    private var fakeScore2: Int;
    private var player: FlxSprite;
    private var pug: FlxSprite;
    private var scoreTime: Float;
    private var finished: Bool;

    public function new(stageNumber: Int)
    {
        this.stageNumber = stageNumber;
        super();

        score = 0;
        fakeScore1 = 3;
        fakeScore2 = 7;
        scoreTime = 1.5 + FlxRandom.float();
        finished = false;
    }

    public override function create(): Void
    {
        new FlxTimer(scoreTime, function(timer: FlxTimer) {
            finished = true;
        });

        FlxG.camera.bgColor = GameConstants.DARK_BG_COLOR;

        add(PixelText.New(FlxG.width / 2 - 48, 2 * FlxG.height / 3, "Stage " + stageNumber + " Clear"));
        add(PixelText.New(FlxG.width / 2 - 64, FlxG.height / 3, "Total score:"));

        scoreText = PixelText.New(FlxG.width / 2 + 32, FlxG.height / 3, Std.string(score));
        add(scoreText);

        player = new FlxSprite(-24, FlxG.height / 2);
        player.loadGraphic("assets/images/fighter-walk-sheet.png", true, 32, 24);
		player.animation.add("run", [6, 5], 6);
        player.animation.play("run");
        add(player);

        pug = new FlxSprite(-20, FlxG.height / 2 - 18);
        pug.loadGraphic("assets/images/pug-sheet.png", true, 24, 24);
        pug.animation.add("idle", [2]);
        pug.animation.play("idle");
        add(pug);
    }

    public override function update(): Void
    {
        FlxVelocity.moveTowardsPoint(player, new FlxPoint(FlxG.width + 24, FlxG.height / 2 + 12), 40);
        FlxVelocity.moveTowardsPoint(pug, new FlxPoint(FlxG.width + 24, FlxG.height / 2 - 6), 40);

        if (!finished)
        {
            score++;
            fakeScore1 = (fakeScore1 + 1) % 10;
            fakeScore2 = (fakeScore2 + 1) % 10;
            scoreText.text = Std.string(score) + Std.string(fakeScore1) + Std.string(fakeScore1);
        }
        else if (GamePad.justPressed(GamePad.Start) || GamePad.justPressed(GamePad.A))
        {
            GameStatus.currentStage++;
            GameController.StartStage(GameStatus.currentStage);
        }

        super.update();
    }
}
