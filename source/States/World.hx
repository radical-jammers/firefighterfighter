package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSort;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;

class World extends GameState
{
	public var level : TiledLevel;
	public var player : Player;
	public var enemies : FlxTypedGroup<Enemy>;

	public var entities : FlxTypedGroup<Entity>;

	// stage status variables
	public var remainingTime: Int = 60;
	public var heatLevel: Int = 10;

	override public function create():Void
	{
		super.create();

		// Load the tiled level
		level = new TiledLevel("assets/maps/" + "w0m0" + ".tmx");

		entities = new FlxTypedGroup<Entity>();

		add(level.backgroundTiles);

		player = new Player(100, 100, this);
		add(player);

		enemies = new FlxTypedGroup<Enemy>();
		enemies.add(new EnemyWalker(150, 132, this));
		add(enemies);

		add(level.overlayTiles);

		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
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
