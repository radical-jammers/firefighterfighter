package ui;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

class Hud extends FlxTypedGroup<FlxSprite> {
    public var world: World;

    private var clock: FlxSprite;
    private var firstFigure: FlxSprite;
    private var lastFigure: FlxSprite;
    private var background: FlxSprite;

    public function new(world: World)
    {
        this.world = world;
        super();

        clock = new FlxSprite(0, FlxG.height - 16);
        firstFigure = new FlxSprite(8, FlxG.height - 16);
        lastFigure = new FlxSprite(16, FlxG.height - 16);

        clock.loadGraphic("assets/images/hud-timer.png", true, 8, 16);
        firstFigure.loadGraphic("assets/images/hud-timer.png", true, 8, 16);
        lastFigure.loadGraphic("assets/images/hud-timer.png", true, 8, 16);
        background = new FlxSprite(0, FlxG.height - 16).makeGraphic(FlxG.width, 16, FlxColor.BLACK);

        clock.animation.add("clock", [10]);
        firstFigure.animation.add("first", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
        lastFigure.animation.add("last", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);

        clock.animation.play("clock");
        firstFigure.animation.play("first");
        lastFigure.animation.play("last");

        for (elem in [clock, firstFigure, lastFigure])
            elem.animation.pause();

        add(background);
        add(clock);
        add(firstFigure);
        add(lastFigure);

        for (sprite in this)
            sprite.scrollFactor.set();
    }

    public override function draw(): Void
    {
        super.draw();
    }

    public override function update(): Void
    {
        var timeFigures = getRemainingTimeFigures();
        firstFigure.animation.frameIndex = Std.int(timeFigures.first);
        lastFigure.animation.frameIndex = Std.int(timeFigures.last);

        super.update();
    }

    private function getRemainingTimeFigures(): Dynamic
    {
        var remainingTime: Int = world.remainingTime;
        return {
            first: remainingTime / 10,
            last: remainingTime % 10
        }
    }
}
