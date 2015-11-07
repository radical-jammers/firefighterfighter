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
		spreadTimer.start(3.0, doRoam, 0);
		spreadingFires = new FlxTypedGroup<EnemySpreadingFire>();
		spreadingFires.add(new EnemySpreadingFire(x, y, world, this));
		world.enemies.add(spreadingFires);
		makeGraphic(0, 0);
	}

	public function remove(fire: EnemySpreadingFire)
	{
		spreadingFires.remove(fire);
	}

	override public function update()
	{
		if (spreadingFires.length == 0)
		{
			destroy();
		}
		super.update();
	}

	private function doRoam(timer: FlxTimer): Void
	{
		var fire : EnemySpreadingFire;
		var dir : Float;
		var xPos : Float;
		var yPos : Float;
		var iter : Int;
		var nreplications : Int;

		iter = 0;
		nreplications = 0;

		while (iter < spreadingFires.length && nreplications < 3)
		{
			var spreadingFire : EnemySpreadingFire = spreadingFires.members[iter];
			fire = null;
			dir = Math.random();
			if (spreadingFire != null)
			{
				xPos = spreadingFire.getMidpoint().x - (spreadingFire.get_width()/2);
				yPos = spreadingFire.getMidpoint().y - (spreadingFire.get_width()/2);

				if ( dir < 0.25) 
				{
					if (!spreadingFire.overlapsAt(xPos - FIRE_SIZE, yPos, spreadingFires) && !spreadingFire.overlapsAt(xPos - FIRE_SIZE, yPos, world.solids))
					{
						fire = new EnemySpreadingFire(xPos - FIRE_SIZE, yPos, world, this);
						spreadingFires.add(fire);
						trace("New Fire! We are now" + spreadingFires.length);
						nreplications ++;
					}
				} else if ( dir > 0.25 && dir < 0.5) 
				{
					if (!spreadingFire.overlapsAt(xPos + FIRE_SIZE, yPos, spreadingFires) && !spreadingFire.overlapsAt(xPos + FIRE_SIZE, yPos, world.solids))
					{
						fire = new EnemySpreadingFire(xPos + FIRE_SIZE, yPos, world, this);
						spreadingFires.add(fire);
						trace("New Fire! We are now" + spreadingFires.length);
						nreplications ++;
					}
				} else if ( dir > 0.5 && dir < 0.75) 
				{
					if (!spreadingFire.overlapsAt(xPos, yPos - FIRE_SIZE, spreadingFires) && !spreadingFire.overlapsAt(xPos, yPos - FIRE_SIZE, world.solids))
					{
						fire = new EnemySpreadingFire(xPos, yPos - FIRE_SIZE, world, this);
						spreadingFires.add(fire);
						trace("New Fire! We are now" + spreadingFires.length);
						nreplications ++;
					}
				} else if ( dir > 0.75) 
				{
					if (!spreadingFire.overlapsAt(xPos, yPos + FIRE_SIZE, spreadingFires) && !spreadingFire.overlapsAt(xPos, yPos + FIRE_SIZE, world.solids))
					{
						fire = new EnemySpreadingFire(xPos, yPos + FIRE_SIZE, world, this);
						spreadingFires.add(fire);
						trace("New Fire! We are now" + spreadingFires.length);
						nreplications ++;
					}
				}
				iter ++;
			}
		}
	}

	override public function destroy(): Void
	{
		for (spreadingFire in spreadingFires)
		{
			spreadingFire.destroy();
		}
		world.enemies.remove(this);
		super.destroy();
	}

}