package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import text.PixelText;
import flixel.util.FlxTimer;
import flixel.effects.particles.FlxEmitter;

class GameOver extends GameState
{
    private var sadPug: FlxSprite;
    private var timer: FlxTimer;
    private var barking: Bool;

    public override function create(): Void
    {
        super.create();

        FlxG.camera.bgColor = GameConstants.DARK_BG_COLOR;

        GameStatus.reset();

        add(PixelText.New(FlxG.width / 2 - 36, FlxG.height / 2 - 24, "Game Over"));
        sadPug = new FlxSprite(FlxG.width / 2 - 12, FlxG.height / 2 - 12);
        sadPug.loadGraphic("assets/images/pug-sheet.png", true, 24, 24);
        sadPug.animation.add("bark-woefully", [0, 1, 2, 3, 0], 8, false);

        add(sadPug);

        sadPug.animation.play("bark-woefully");

        timer = null;
        barking = true;

        addParticles(0, FlxG.height - 32, FlxG.width / 4, 16);
        addParticles(FlxG.width / 4, FlxG.height - 32, FlxG.width / 4, 16);
        addParticles(FlxG.width / 2, FlxG.height - 32, FlxG.width / 4, 16);
        addParticles(3 * FlxG.width / 4, FlxG.height - 32, FlxG.width / 4, 16);

        addParticles(0, FlxG.height - 16, FlxG.width / 4, 16);
        addParticles(FlxG.width / 4, FlxG.height - 16, FlxG.width / 4, 16);
        addParticles(FlxG.width / 2, FlxG.height - 16, FlxG.width / 4, 16);
        addParticles(3 * FlxG.width / 4, FlxG.height - 16, FlxG.width / 4, 16);
    }

    public override function update(elapsed:Float): Void
    {
        if (!barking && sadPug.animation.finished && (timer == null || timer.finished))
        {
            if (timer == null)
                timer = new FlxTimer().start(1.5, doBarkWoefully);
            else
                timer.start(1.5, doBarkWoefully);
            barking = true;
        }
        else if (sadPug.animation.finished)
            barking = false;

        super.update(elapsed);

        if (GamePad.justPressed(GamePad.Start) || GamePad.justPressed(GamePad.A))
    		GameController.ToTitleScreen();
    }

    private function doBarkWoefully(timer: FlxTimer): Void
    {
        timer.cancel();
        sadPug.animation.play("bark-woefully");
    }

    private function addParticles(x: Float, y: Float, w: Float, h: Float): Void
    {
        var angle = -45 * Math.PI / 180;
        var particles: FlxEmitter = new FlxEmitter();
        particles.width = w;
        particles.height = h;
        // particles.setRotation(0, 0);
        // particles.setMotion(-45, 15, 180);
        particles.launchAngle.set(angle, angle);
        particles.velocity.set(15, 15);
        particles.loadParticles("assets/images/fire-particles.png", 6, 0, true);
        // particles.makeParticles("assets/images/fire-particles.png", 6, 0, true, 0);
        particles.alpha.set(1, 1, 0, 0);
        particles.scale.set(1, 2, 0, 0.25);
        particles.lifespan.set(2);
        
        particles.x = x;
        particles.y = y;
        //particles.start({Explode:false, Frequency:0.1, Quantity:0});
        particles.start(false, 0.1, 0);

        add(particles);
    }
}
