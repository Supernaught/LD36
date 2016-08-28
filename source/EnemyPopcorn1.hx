package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;


// Behavior: always move per turn

class EnemyPopcorn1 extends Enemy
{
	var directionChoices:Array<Int>;

	public function new(X:Int = 64, Y:Int = 64)
	{
		super(X, Y);

		makeGraphic(16,16, FlxColor.PURPLE);
	}

	public override function init(X:Float, Y:Float, EnemyBullets:FlxTypedGroup<Bullet>, Player:Player, Tilemap:FlxTilemap)
	{
		super.init(X,Y,EnemyBullets,Player,Tilemap);
		trace(x + ' ' + y);
		// trace(tilemap.findPath(new FlxPoint(x,y), new FlxPoint(player.x, player.y), false, null, WIDE));
	}

	public override function getTargetDirection(Tilemap:FlxTilemap):Void
	{
		if(directionChoices.length > 0){
			targetDirection = random.getObject(directionChoices);
		} else {
			targetDirection = FlxObject.NONE;
		}
	}

	// Always find a tile to move
	public override function setTargetTile(Tilemap:FlxTilemap):Void
	{
	    var currentTileIndex = getCurrentTileIndex();
	    directionChoices = [FlxObject.RIGHT, FlxObject.LEFT, FlxObject.UP, FlxObject.DOWN];

		var targetCoords = new FlxPoint(0,0);

		var done:Bool = false;

		var targetTileIndex;

		do {
		    getTargetDirection(Tilemap);

			switch(targetDirection)
			{
				case FlxObject.UP: targetCoords = new FlxPoint(x, y - 16);
				case FlxObject.DOWN: targetCoords = new FlxPoint(x, y + 16);
				case FlxObject.LEFT: targetCoords = new FlxPoint(x - 16, y);
				case FlxObject.RIGHT: targetCoords = new FlxPoint(x + 16, y);
			}

			targetTileIndex = Tilemap.getTileIndexByCoords(targetCoords);

			var targetTileIndexIsFloor = Reg.TILE_FLOOR_VARIATIONS.indexOf(tilemap.getTileByIndex(targetTileIndex)) != -1;

			// if target tile is already occupied or is not a floor, look for another
			if(targetDirection != FlxObject.NONE && (Reg.enemyTargetTiles.indexOf(targetTileIndex) != -1 || !targetTileIndexIsFloor)){
				directionChoices.remove(targetDirection);
			} else {
				targetTileIndex = currentTileIndex;
				done = true;
			}
		}while(!done);

		Reg.enemyTargetTiles.remove(currentTileIndex);
		Reg.enemyTargetTiles.push(targetTileIndex);
	}

}