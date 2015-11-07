package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSort;
import flixel.util.FlxPoint;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxTimer;

import ui.Hud;

class World extends GameState
{
	public var level : TiledLevel;
	public var player : Player;

	public var enemies: FlxTypedGroup<Enemy>;
	public var solids: FlxGroup;
	public var entities : FlxTypedGroup<Entity>;
	public var hud: Hud;

	public static inline var STAGE_DURATION = 60;

	// stage status variables
	public var remainingTime: Int = STAGE_DURATION;
	public var heatLevel: Int = 10;

	// Timers
	public var stageTimer: FlxTimer;

	override public function create():Void
	{
		super.create();

		entities = new FlxTypedGroup<Entity>();

		solids = new FlxGroup();
		add(solids);

		// Load the tiled level
		level = new TiledLevel("assets/maps/" + "w0m0" + ".tmx");

		add(level.backgroundTiles);
		level.loadObjects(this);

		player = new Player(100, 100, this);
		add(player);

		enemies = new FlxTypedGroup<Enemy>();
		enemies.add(new GroupSpreadingFire(150, 132, this));
		add(enemies);

		add(level.overlayTiles);

		hud = new Hud(this);
		add(hud);

		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);

		stageTimer = new FlxTimer(1.0, function(timer: FlxTimer) {
			remainingTime--;
			if (remainingTime == 0)
			{
				player.onDefeat();
				GameStatus.lives--;
				GameController.startStage(GameStatus.currentStage);
			}
		}, STAGE_DURATION);
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if (GamePad.checkButton(GamePad.Start))
		{
			openSubState(new PauseMenu());
		}

		level.collideWithLevel(player);

		for (enemy in enemies)
		{
			level.collideWithLevel(enemy);
		}

		FlxG.collide(enemies);

		FlxG.collide(player, enemies, onCollisionPlayerEnemy);

		handleDebugRoutines();

		super.update();

		entities.sort(FlxSort.byY);
	}

	public function onCollisionPlayerEnemy(player: Player, enemy: Enemy): Void
	{
		player.onCollisionWithEnemy(enemy);
		enemy.onCollisionWithPlayer();
	}

	function handleDebugRoutines()
	{
		var mousePos : FlxPoint = FlxG.mouse.getWorldPosition();

		if (FlxG.keys.justPressed.ONE)
		{
			enemies.add(new EnemyWalker(mousePos.x, mousePos.y, this));
		}
	}
}
