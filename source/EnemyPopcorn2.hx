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


// Behavior: move to player, stop, move to player, stop

class EnemyPopcorn2 extends Enemy
{
	var shouldMove:Bool;

	public function new(X:Int = 64, Y:Int = 64)
	{
		super(X, Y);

		shouldMove = false;
		makeGraphic(16,16, FlxColor.ORANGE);
	}

	public override function init(X:Float, Y:Float, EnemyBullets:FlxTypedGroup<Bullet>, Player:Player, Tilemap:FlxTilemap)
	{
		super.init(X,Y,EnemyBullets,Player,Tilemap);
		trace(x + ' ' + y);
	}

	public override function move():Void
	{
		super.move();

		shouldMove = !shouldMove;
	}

	public override function getTargetDirection(Tilemap:FlxTilemap):Void
	{
		if(!shouldMove){
			targetDirection = FlxObject.NONE;
			return;
		}

		var targetPath = tilemap.findPath(new FlxPoint(x,y), new FlxPoint(player.x, player.y), false, null, NONE);

		var currentX = x/16;
		var currentY = y/16;

		var targetXTile = currentX;
		var targetYTile = currentY;

		if(targetPath.length > 2){
			var nextTarget = targetPath[1];
			targetXTile = (nextTarget.x - 8)/16;
			targetYTile = (nextTarget.y - 8)/16;
		}
		
		var xDistance = (targetXTile - currentX);
		var yDistance = (targetYTile - currentY);

		if(xDistance == 0){
			// move vertically
			if(yDistance != 0){
				targetDirection = (yDistance > 0) ? FlxObject.DOWN : FlxObject.UP;
			} else {
				targetDirection = FlxObject.NONE;
			}
		} else {
			// move horizontally
			if(xDistance != 0){
				targetDirection = (xDistance > 0) ? FlxObject.RIGHT : FlxObject.LEFT;
			} else {
				targetDirection = FlxObject.NONE;
			}
		}

		// if(Math.abs(xDistance) >= Math.abs(yDistance)){
		// 	// move horizontally
		// 	if(xDistance == 0){
		// 		targetDirection = FlxObject.NONE;
		// 	} else {
		// 		targetDirection = (xDistance > 0) ? FlxObject.RIGHT : FlxObject.LEFT;
		// 	}
		// } else {
		// 	// move vertically
		// 	if(yDistance == 0){
		// 		targetDirection = FlxObject.NONE;
		// 	} else {
		// 		targetDirection = (yDistance > 0) ? FlxObject.DOWN : FlxObject.UP;
		// 	}
		// }

		// if(shouldMove){
		// 	targetDirection = random.getObject([FlxObject.RIGHT, FlxObject.LEFT, FlxObject.UP, FlxObject.DOWN]);
		// } else {
		// 	targetDirection = FlxObject.NONE;
		// }
	}
}