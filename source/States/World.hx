package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
<<<<<<< HEAD
import flixel.group.FlxTypedGroup;
=======
import flixel.util.FlxPoint;
>>>>>>> b7547f58a75992f7e476eccffbdd40dfa889bb4e

/**
 * A FlxState which can be used for the actual gameplay.
 */
class World extends GameState
{

	public var level : TiledLevel;
	public var player : Player;
	public var enemies: FlxTypedGroup<Enemy>;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		// Load the tiled level
		level = new TiledLevel("assets/maps/" + "w0m0" + ".tmx");

		add(level.backgroundTiles);
		add(level.overlayTiles);

		player = new Player(100, 100, this);
		add(player);

<<<<<<< HEAD
		enemies = new FlxTypedGroup<Enemy>();
		enemies.add(new EnemyWalker(150, 132, this));
		add(enemies);
=======
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
>>>>>>> b7547f58a75992f7e476eccffbdd40dfa889bb4e
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
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

		handleDebugRoutines();

		super.update();
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
