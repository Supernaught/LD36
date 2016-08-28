package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;


class FloorMaker
{
	public var map: Array<Array<Int>>;

	var xPos:Int;
	var yPos:Int;

	var mapWidth:Int;
	var mapHeight:Int;
	public var maxFloors:Int;
	public var floorCount:Int = 0;

	var random:FlxRandom;

	private var upDownChance:Float = 1;
	private var leftRightChance:Float = 3;
	private var room2x2Chance:Float = 10;

	public function new(MaxFloors:Int = 60):Void
	{
		random = new FlxRandom();

		mapWidth = MaxFloors;
		mapHeight = MaxFloors;
		maxFloors = MaxFloors;

		xPos = Math.round(mapWidth / 2);
		yPos = Math.round(mapHeight / 2);

		trace('xy of tilemap: ' + xPos + ' ' + yPos);

		initializeFloor();
		// generateNextFloor();
		// trace(map);
	}

	public function initializeFloor():Void
	{
		map = new Array<Array<Int>>();

		for(y in 0...mapHeight) {
			var row: Array<Int> = [];

			for(x in 0...mapWidth) {
				row.insert(x, Reg.TILE_EMPTY);
			}

			map.insert(y, row);
		}

		map[yPos][xPos] = Reg.TILE_FLOOR;
	}

	public function generateNextFloor():Int
	{
		var nextTileCoord:FlxPoint = getNextTileCoord();

		yPos = Math.round(nextTileCoord.y);
		xPos = Math.round(nextTileCoord.x);
		map[yPos][xPos] = Reg.TILE_FLOOR;

		// 50% chance to create 2x2 floors
		if(random.bool(room2x2Chance)) {
			if(floorCountNotMax() && isTileEmpty(yPos, xPos+1)) { map[yPos][xPos+1] = Reg.TILE_FLOOR; floorCount++; }
			if(floorCountNotMax() && isTileEmpty(yPos+1, xPos)) { map[yPos+1][xPos] = Reg.TILE_FLOOR; floorCount++; }
			if(floorCountNotMax() && isTileEmpty(yPos+1, xPos+1)) { map[yPos+1][xPos+1] = Reg.TILE_FLOOR; floorCount++; }
		}

		if(floorCountNotMax()){
			floorCount++;
		}

		return Math.round((floorCount/maxFloors-2) * 100);
	}

	public function floorCountNotMax():Bool
	{
		return (floorCount < maxFloors - 1);
	}

	public function getNextTileCoord():FlxPoint
	{
		var tempYPos = yPos;
		var tempXPos = xPos;
		var exclude:Int = 0;
		var done:Bool = false;

		do {
			done = false;
			var randomDirections = [FlxObject.UP,FlxObject.DOWN,FlxObject.LEFT,FlxObject.RIGHT];
			randomDirections.remove(exclude);

			var randDirection = random.getObject(randomDirections, [upDownChance,upDownChance,leftRightChance,leftRightChance]);
			// trace(randDirection);

			switch(randDirection){
				case FlxObject.UP: 
				tempYPos--;

				case FlxObject.LEFT:
				tempXPos--;

				case FlxObject.DOWN: 
				tempYPos++;

				case FlxObject.RIGHT:
				tempXPos++;

				default: trace('def');
			}

			// if(isTileOutOfBounds(tempXPos, tempYPos)){
			// 	trace('out of bounds');
			// 	exclude = randDirection;
			// 	tempYPos = yPos;
			// 	tempXPos = xPos;
			// } else if(isTileEmpty(tempXPos, tempYPos)) {
			// 	exclude = 0;
			// 	done = true;
			// }

		} while(!isTileEmpty(tempXPos, tempYPos));

		return new FlxPoint(tempXPos, tempYPos);
	}

	public function isTileOutOfBounds(XPos:Int, YPos:Int):Bool
	{
		return (YPos < 0 && YPos >= mapHeight && XPos < 0 && XPos >= mapWidth);
	}

	public function isTileEmpty(XPos:Int, YPos:Int):Bool
	{
		// trace('checking: ' + XPos + ', ' + YPos);
		// trace(YPos >= 0 && YPos < mapHeight && XPos >= 0 && XPos < mapWidth && map[YPos][XPos] == 0);
		return (map[YPos][XPos] == Reg.TILE_EMPTY);
	}
}
