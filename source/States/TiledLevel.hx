package;

import haxe.io.Path;

import flixel.FlxG;
import flixel.FlxObject;
import utils.tiled.TiledMap;
import utils.tiled.TiledObject;
import utils.tiled.TiledObjectGroup;
import utils.tiled.TiledTileSet;
import utils.tiled.TiledImage;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

class TiledLevel extends TiledMap
{
	private inline static var spritesPath = "assets/images/";
	private inline static var tilesetPath = "assets/tilesets/";

	public var overlayTiles    : FlxGroup;
	public var foregroundTiles : FlxGroup;
	public var backgroundTiles : FlxGroup;
	public var collidableTileLayers : Array<FlxTilemap>;

	public var meltingsPerSecond : Float;

	public function new(tiledLevel : Dynamic)
	{
		super(tiledLevel);

		overlayTiles = new FlxGroup();
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		collidableTileLayers = new Array<FlxTilemap>();

		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);

		/* Read config info */

		/* Read tile info */
		for (tileLayer in layers)
		{
			var tilesetName : String = tileLayer.properties.get("tileset");
			if (tilesetName == null)
				throw "'tileset' property not defined for the " + tileLayer.name + " layer. Please, add the property to the layer.";

			// Locate the tileset
			var tileset : TiledTileSet = null;
			for (ts in tilesets) {
				if (ts.name == tilesetName)
				{
					tileset = ts;
					break;
				}
			}

			// trace(tilesetName);

			if (tileset == null)
				throw "Tileset " + tilesetName + " could not be found. Check the name in the layer 'tileset' property or something.";

			var processedPath = buildPath(tileset);

			var tilemap : FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileset.tileWidth, tileset.tileHeight, 0, 1, 1, 1);

			tilemap.ignoreDrawDebug = true;

			if (tileLayer.properties.contains("overlay"))
			{
				overlayTiles.add(tilemap);
			}
			else if (tileLayer.properties.contains("solid"))
			{
				collidableTileLayers.push(tilemap);
			}
			else
			{
				backgroundTiles.add(tilemap);
			}
		}
	}

	public function loadObjects(world : World) : Void
	{
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				loadObject(o, group, world);
			}
		}

		if (world.player == null)
			world.player = new Player(64, 64, world);

	}

	private function loadObject(o : TiledObject, g : TiledObjectGroup, world : World) : Void
	{
		var x : Int = o.x;
		var y : Int = o.y;

		// The Y position of objects created from tiles must be corrected by the object height
		if (o.gid != -1) {
			y -= o.height;
		}

		switch (o.type.toLowerCase())
		{

			case "start":
				// addPlayer(x, y, world);

			case "player":
				world.player = new Player(x, y, world);

			/** Elements **/
			case "solid":
				var solid : FlxObject = new FlxObject(x,y,o.width,o.height);
				solid.immovable = true;
				world.solids.add(solid);

			case "teleport":
				var target = o.custom.get("target");

				var teleport : Teleport = new Teleport(x, y, world, o.width, o.height, target);
				world.teleports.add(teleport);
/*
			case "tiledObject":
				var gid = o.gid;
				var tiledImage : TiledImage = getImageSource(gid);
				if (tiledImage == null)
				{
					trace("Could not locate image source for gid=" + gid + "!");
				}
				else
				{
					var decoration : Decoration = new Decoration(x, y, world, tiledImage);
					world.decoration.add(decoration);
				}
*/
			/** Enemies **/

			case "spread":
				var delay : Int = null;

				if (o.custom.contains("delay"))
					delay = Std.parseInt(o.custom.get("delay"));

				var fire : GroupSpreadingFire = new GroupSpreadingFire(x, y, world, delay);
				world.addEnemy(fire);
			case "walker":
				var walker : EnemyWalker = new EnemyWalker(x, y, world);
				world.addEnemy(walker);

			case "mother": 
				var mother : EnemyMother = new EnemyMother(x, y, world);
				world.addEnemy(mother);
		}
	}

	function getImageSource(gid : Int) : TiledImage
	{
		var image : TiledImage = imageCollection.get(gid);
		image.imagePath = "assets/tilesets/detail/" + image.sourceImage;
		return image;
	}

	/*public function initEnemy(e : Enemy, o : TiledObject) : Void
	{
		var variation : Int = getVariation(o);

		e.init(variation);
	}*/

	public function getVariation(o : TiledObject) : Int
	{
		var worldTypeStr : String = o.custom.get("variation");
		if (worldTypeStr != null)
			return Std.parseInt(worldTypeStr);
		else
			return 0;
	}
	/*
	public function addPlayer(x : Int, y : Int, world : World) : Void
	{
		var player : Player = new Player(x, y, world);

		world.addPlayer(player);
	}*/

	public function collideWithLevel(obj : FlxObject, ?notifyCallback : FlxObject -> FlxObject -> Void, ?processCallback : FlxObject -> FlxObject -> Bool) : Bool
	{
		if (collidableTileLayers != null)
		{
			for (map in collidableTileLayers)
			{
				// Remember: Collide the map with the objects, not the other way around!
				return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}

		return false;
	}

	private function buildPath(tileset : TiledTileSet, ?spritesCase : Bool  = false) : String
	{
		var imagePath = new Path(tileset.imageSource);
		var processedPath = (spritesCase ? spritesPath : tilesetPath) +
			imagePath.file + "." + imagePath.ext;

		return processedPath;
	}

	public function destroy()
	{
		backgroundTiles.destroy();
		foregroundTiles.destroy();
		overlayTiles.destroy();
		for (layer in collidableTileLayers)
			layer.destroy();
	}
}
