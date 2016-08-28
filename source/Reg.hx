package;

import flixel.math.FlxPoint;

class Reg
{
	// Player stats
	public static var playerDamage = 1;

	// Attack types
	public static var MELEE = 1;
	public static var RANGED = 2;

	// Assets
	public static var PLAYER_SPRITE = "assets/images/player.png";

	// Tile Size
	public static var T_WIDTH:Int = 16;
	public static var T_HEIGHT:Int = 16;

	// Tile types
	public static var TILE_EMPTY:Int = 0;
	public static var TILE_WALL:Int = 1;
	public static var TILE_FLOOR:Int = 2;

	// Tile variations
	public static var TILE_FLOOR_VARIATIONS = [26,27,28];

	// Tilemap indices
	// Occupied target tiles for enemy moves
	public static var enemyTargetTiles:Array<Int> = [];
}