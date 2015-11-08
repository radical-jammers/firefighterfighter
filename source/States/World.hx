package;

import flixel.FlxBasic;
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

	public var teleports : FlxGroup;

	public var entities : FlxTypedGroup<Entity>;
	public var hud: Hud;

	public static inline var STAGE_DURATION = 99;
	public static inline var HEAT_THRESHOLD: Int = 20;

	// stage status variables
	public var remainingTime: Int = STAGE_DURATION;
	public var originalHeat: Int;
	public var currentHeat: Int;
	public var heatLevel: Int;

	// If true, nobody moves
	public var teleporting : Bool;

	// Timers
	public var stageTimer: FlxTimer;

	override public function create():Void
	{
		super.create();

		// Prepare the groups
		entities = new FlxTypedGroup<Entity>();
		solids = new FlxGroup();
		enemies = new FlxGroup();
		teleports = new FlxGroup();
		currentHeat = 0;
		originalHeat = 0;

		// Load the tiled level
		level = new TiledLevel("assets/maps/" + GameStatus.currentMapName + ".tmx");

		// Add the tiles to the game
		add(level.backgroundTiles);

		// Load the objects in the map file
		level.loadObjects(this);

		// Add the entities list
		add(entities);

		// Add the overlay tiles
		add(level.overlayTiles);

		// Prepare the HUD
		hud = new Hud(this);
		add(hud);

		// Setup camera bounds, and follow player
		FlxG.camera.setBounds(0, 0, level.fullWidth, level.fullHeight + 16);
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);

		// Setup stage timer
		stageTimer = new FlxTimer(FlxMath.SQUARE_ROOT_OF_TWO*13/7, function(timer: FlxTimer) {
			remainingTime--;
			if (remainingTime == 0)
				player.onDefeat();
		}, STAGE_DURATION);

		// But wait!
		teleporting = true;

		// First...fade in!
		FlxG.camera.fill(0xFF000000);
		FlxG.camera.fade(0xFF000000, 0.75, true, onLevelStart);
	}

	public function onLevelStart()
	{
		// Start the fading catharsis
		fadeToRed();
		teleporting = false;
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if (!teleporting)
		{
			if (GamePad.checkButton(GamePad.Start))
			{
				openSubState(new PauseMenu());
			}

			FlxG.collide(solids,enemies);
			FlxG.collide(solids,player);

			FlxG.collide(enemies);

			FlxG.overlap(teleports, player, onPlayerTeleportCollision);

			FlxG.collide(player, enemies, onCollisionPlayerEnemy);

			handleDebugRoutines();

			super.update();

			entities.sort(FlxSort.byY);
		}

		// Checks if the scene has been cleared
		heatLevel = originalHeat == 0 ? 0 : Std.int(100 * currentHeat / originalHeat);
		if (heatLevel <= HEAT_THRESHOLD)
		{
			hud.coolEnough = true;
			stageTimer.cancel();
			fadeTimer.cancel();
			FlxG.camera.fill(0x00FFFFFF, false);
		}
	}

	public function onCollisionPlayerEnemy(player: Player, enemy: Enemy): Void
	{
		player.onCollisionWithEnemy(enemy);
		enemy.onCollisionWithPlayer();
	}

	public function onPlayerTeleportCollision(teleport : Teleport, player : Player) : Void
	{
		var target : String = teleport.target;

		if (target != null)
		{
			teleporting = true;

			if (fadeTimer != null)
				fadeTimer.cancel();

			FlxG.camera.fade(0xFF000000, 0.75, function gogogo() {
				GameController.Teleport(target);
			}, true);
		}
	}

	public var fadeTimer : FlxTimer;

	public function fadeToRed()
	{
		fadeTimer = new FlxTimer(0.7, function(t:FlxTimer) {
			FlxG.camera.fade(0x43FF5151, 3.5, false, fadeToClear, true);
		});
	}

	public function fadeToClear()
	{
		fadeTimer = new FlxTimer(1.5, function(t:FlxTimer) {
			FlxG.camera.fade(0x43FF5151, 3.5, true, fadeToRed, true);
		});
	}

	public function addEnemy(enemy: Enemy): Void
	{
		enemies.add(enemy);
		addHeat(enemy);
	}

	// Calculates global temperature after adding a new enemy
	public function addHeat(obj: FlxBasic): Void
	{
		if (Std.is(obj, FlxTypedGroup))
		{
			var enemies: FlxTypedGroup<Dynamic> = cast(obj, FlxTypedGroup<Dynamic>);
			for (enemy in enemies)
				addHeat(enemy);
		} else
		{
			var enemy: Enemy = cast(obj, Enemy);
			currentHeat += enemy.heat;
			originalHeat = Std.int(Math.max(originalHeat, currentHeat));
		}
	}

	public function removeHeat(enemy: Enemy): Void
	{
		currentHeat -= enemy.heat;
	}

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
			addEnemy(new EnemyWalker(mousePos.x, mousePos.y, this));
		}

		if (FlxG.keys.justPressed.K)
		{
			player.hp--;
		}
		else if (FlxG.keys.justPressed.L)
		{
			player.hp++;
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
