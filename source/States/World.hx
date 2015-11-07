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

	public var enemies: FlxGroup;
	public var solids: FlxGroup;
	public var entities : FlxTypedGroup<Entity>;
	public var hud: Hud;

	public static inline var STAGE_DURATION = 99;

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

		enemies = new FlxGroup();
		enemies.add(new GroupSpreadingFire(150, 132, this));
		add(enemies);

		add(level.overlayTiles);

		hud = new Hud(this);
		add(hud);

		FlxG.camera.setBounds(0, 0, level.fullWidth, level.fullHeight + 16);
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);

		stageTimer = new FlxTimer(FlxMath.SQUARE_ROOT_OF_TWO*13/7, function(timer: FlxTimer) {
			remainingTime--;
			if (remainingTime == 0)
				player.onDefeat();
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

		if (FlxG.keys.justPressed.T)
		{
			player.x = mousePos.x;
			player.y = mousePos.y;
		}

		if (FlxG.keys.justPressed.ONE)
		{
			enemies.add(new EnemyWalker(mousePos.x, mousePos.y, this));
		}

		if (FlxG.mouse.justPressed)
		{
			if (_explosion == null)
			{
				_explosion = new flixel.effects.particles.FlxEmitterExt();
				_explosion.width = 16;
				_explosion.height = 16;
				_explosion.setRotation(0, 0);
				_explosion.setMotion(-45, 15, 200);
				_explosion.makeParticles("assets/images/fire-particles.png", 60, 0, true, 0);
				_explosion.setAlpha(1, 1, 0, 0);
				_explosion.setScale(1, 2, 0, 0.25);
				add(_explosion);
			}

			_explosion.x = mousePos.x;
			_explosion.y = mousePos.y;
			_explosion.start(false, 2, 0.1, 100);
			_explosion.update();
		}
	}
	var _explosion : flixel.effects.particles.FlxEmitterExt = null;
}
