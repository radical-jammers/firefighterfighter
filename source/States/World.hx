package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;

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

		enemies = new FlxTypedGroup<Enemy>();
		enemies.add(new EnemyWalker(150, 132, this));
		add(enemies);
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

		/*FlxG.collide(player, enemies, onPlayerEnemyCollision)
		{

		}*/

		super.update();
	}
}
