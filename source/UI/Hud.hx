package ui;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

class Hud extends FlxTypedGroup<FlxSprite> {
    public var world: World;
    public var coolEnough: Bool;

    public static inline var MAX_BOTTLES: Int = 5;

    private var clock: FlxSprite;
    private var firstFigure: FlxSprite;
    private var lastFigure: FlxSprite;
    private var background: FlxSprite;

    private var heat: FlxSprite;

    private var bottlesP1: Array<FlxSprite>;
    private var bottlesP2: Array<FlxSprite>;
    private var emptyBottlesP1: Array<FlxSprite>;
    private var emptyBottlesP2: Array<FlxSprite>;

    public function new(world: World)
    {
        this.world = world;
        coolEnough = false;
        super();

        initSprites();
        loadSprites();
        loadAnimations();
        addSprites();

        for (sprite in this)
            sprite.scrollFactor.set();
    }

    private function initSprites(): Void
    {
        bottlesP1 = new Array<FlxSprite>();
        emptyBottlesP1 = new Array<FlxSprite>();
        bottlesP2 = new Array<FlxSprite>();
        heat = new FlxSprite(FlxG.width - 80, FlxG.height - 16);
        clock = new FlxSprite(96, FlxG.height - 16);
        firstFigure = new FlxSprite(104, FlxG.height - 16);
        lastFigure = new FlxSprite(112, FlxG.height - 16);
        background = new FlxSprite(0, FlxG.height - 16).makeGraphic(FlxG.width, 16, FlxColor.BLACK);
    }

    private function loadSprites(): Void
    {
        for (i in 0...MAX_BOTTLES)
        {
            var bottle = new FlxSprite(i * 8, FlxG.height - 16);
            var emptyBottle = new FlxSprite(i * 8, FlxG.height - 16);
            bottle.loadGraphic("assets/images/hud-p1hp.png", false);
            emptyBottle.loadGraphic("assets/images/hud-emptyhp.png", false);
            emptyBottle.visible = false;
            bottlesP1.push(bottle);
            emptyBottlesP1.push(emptyBottle);
        }

        clock.loadGraphic("assets/images/hud-timer.png", true, 8, 16);
        firstFigure.loadGraphic("assets/images/hud-timer.png", true, 8, 16);
        lastFigure.loadGraphic("assets/images/hud-timer.png", true, 8, 16);
        heat.loadGraphic("assets/images/hud-temperature.png", true, 80, 16);
    }

    private function loadAnimations(): Void
    {
        clock.animation.add("clock", [10]);
        firstFigure.animation.add("first", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
        lastFigure.animation.add("last", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
        heat.animation.add("heat", [0, 1]);

        clock.animation.play("clock");
        firstFigure.animation.play("first");
        lastFigure.animation.play("last");
        heat.animation.play("heat");

        for (elem in [clock, firstFigure, lastFigure, heat])
            elem.animation.pause();

        heat.animation.frameIndex = 1;
    }

    private function addSprites(): Void
    {
        add(background);

        for (bottle in bottlesP1)
            add(bottle);

        for (bottle in emptyBottlesP1)
            add(bottle);

        add(clock);
        add(firstFigure);
        add(lastFigure);
        add(heat);
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

        for (i in 0...MAX_BOTTLES)
        {
            if (GameStatus.currentHp > i)
            {
                bottlesP1[i].visible = true;
                emptyBottlesP1[i].visible = false;
            } else {
                bottlesP1[i].visible = false;
                emptyBottlesP1[i].visible = true;
            }
        }

        if (!coolEnough)
            heat.animation.frameIndex = 1;
        else
        {
            heat.animation.frameIndex = 0;
            clock.visible = false;
            firstFigure.visible = false;
            lastFigure.visible = false;
        }

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
