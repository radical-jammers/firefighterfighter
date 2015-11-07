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
import flixel.group.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;

class World extends GameState
{
	public var level : TiledLevel;
	public var player : Player;

	public var enemies: FlxGroup;
	public var solids: FlxGroup;
	public var entities : FlxTypedGroup<Entity>;


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

		enemies = new FlxGroup();
		enemies.add(new GroupSpreadingFire(150, 132, this));
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

		//level.collideWithLevel(player);

		/*for (enemy in enemies)
		{
			level.collideWithLevel(enemy);
		}*/

		//resolveGroupWorldCollision(enemies);
		FlxG.collide(solids,enemies);

		FlxG.collide(solids,player);

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

	/*function resolveGroupWorldCollision(group : FlxGroup) : Void
	{
		for (element in group)
		{
			if (Std.is(element, FlxGroup))
			{
				resolveGroupWorldCollision(cast(element, FlxGroup));
			}
			else
			{
				level.collideWithLevel(cast element);
			}
		}
	}*/

	function handleDebugRoutines()
	{
		var mousePos : FlxPoint = FlxG.mouse.getWorldPosition();

		if (FlxG.keys.justPressed.ONE)
		{
			enemies.add(new EnemyWalker(mousePos.x, mousePos.y, this));
		}
	}
}
