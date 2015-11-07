package;

import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import flixel.FlxG;

class GroupSpreadingFire extends Enemy
{
	private static inline var FIRE_SIZE: Int = 16;
	private var spreadingFires : FlxTypedGroup<EnemySpreadingFire>;
	private var spreadTimer: FlxTimer;

	public function new(x: Float, y: Float, world: World)
	{
		super(0, 0, world);
		spreadTimer = new FlxTimer();
		spreadTimer.start(2.0, doRoam, 0);
		spreadingFires = new FlxTypedGroup<EnemySpreadingFire>();
		spreadingFires.add(new EnemySpreadingFire(x, y, world));
		makeGraphic(0, 0);
	}

	override public function update(): Void
	{
		for (spreadingFire in spreadingFires)
		{
			spreadingFire.update();
		}
		super.update();
	}

	private function doRoam(timer: FlxTimer): Void
	{
		var fire : EnemySpreadingFire;
		var dir : Float;
		var xPos : Float;
		var yPos : Float;

		for (spreadingFire in spreadingFires)
		{
			fire = null;
			dir = Math.random();
			xPos = spreadingFire.getMidpoint().x - (spreadingFire.get_width()/2);
			yPos = spreadingFire.getMidpoint().y - (spreadingFire.get_width()/2);
			if ( dir < 1) {
				trace("1");

				//fire = new EnemySpreadingFire(spreadingFire.getMidpoint().x - (spreadingFire.get_width()/2) - FIRE_SIZE, spreadingFire.getMidpoint().y - (spreadingFire.get_height()/2), world);
				if (!spreadingFire.overlapsAt(xPos - FIRE_SIZE,yPos, spreadingFires)) //&& !spreadingFire.overlapsAt(xPos - FIRE_SIZE,yPos,world.level.backgroundTiles))
				{
					fire = new EnemySpreadingFire(spreadingFire.getMidpoint().x - (spreadingFire.get_width()/2) - FIRE_SIZE, spreadingFire.getMidpoint().y - (spreadingFire.get_height()/2), world);
					spreadingFires.add(fire);
					trace("New Fire! We are now" + spreadingFires.length);
				}
			} else if ( dir > 0.25 && dir < 0.5) {
				trace("2");
				fire = new EnemySpreadingFire(spreadingFire.getMidpoint().x - (spreadingFire.get_width()/2) + FIRE_SIZE, spreadingFire.getMidpoint().y - (spreadingFire.get_height()/2), world);
				if (!fire.overlaps(spreadingFires) && !fire.overlaps(world.level.backgroundTiles))
				{
					spreadingFires.add(fire);
					trace("New Fire! We are now" + spreadingFires.length);
				}
			} else if ( dir > 0.5 && dir < 0.75) {
				trace("3");
				fire = new EnemySpreadingFire(spreadingFire.getMidpoint().x - (spreadingFire.get_width()/2), spreadingFire.getMidpoint().y - FIRE_SIZE - (spreadingFire.get_height()/2), world);
				if (!fire.overlaps(spreadingFires) && !fire.overlaps(world.level.backgroundTiles))
				{
					spreadingFires.add(fire);
					trace("New Fire! We are now" + spreadingFires.length);
				}
			} else if ( dir > 0.75) {
				trace("4");
				fire = new EnemySpreadingFire(spreadingFire.getMidpoint().x - (spreadingFire.get_width()/2), spreadingFire.getMidpoint().y + FIRE_SIZE - (spreadingFire.get_height()/2), world);
				if (!fire.overlaps(spreadingFires) && !fire.overlaps(world.level.backgroundTiles))
				{
					spreadingFires.add(fire);
					trace("New Fire! We are now" + spreadingFires.length);
				}
			}
		}
	}

	override public function draw(): Void
	{
		for (spreadingFire in spreadingFires)
		{
			spreadingFire.draw();
		}
		super.draw();
	}

}
