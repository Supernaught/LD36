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


class Enemy extends FlxSprite
{
	// Stats
	var hp: Int = 2;

    // Attack stuff
    var enemyBullets:FlxTypedGroup<Bullet>;
    var canAttack:Bool;
    var attackDelay:Float;

	// Movement stuff
	public var movespeed:Float = 4;
	public var moving:Bool = false;
	var targetPosition:FlxPoint;
	var previousPosition:FlxPoint;
	var targetDirection:Int;

    // Player target
    var player:Player;

    // Tilemap reference
    var tilemap:FlxTilemap;

    var random:FlxRandom;

	public function new(X:Int = 64, Y:Int = 64)
	{
		super(X, Y);

		// immovable = true;

		random = new FlxRandom();

		// makeGraphic(16,16, FlxColor.RED);
		makeGraphic(16,16, FlxColor.RED);
		previousPosition = new FlxPoint(x, y);
		// loadGraphic(Reg.PLAYER_SPRITE, null, 16, 16);
	}

	public function init(X:Float, Y:Float, EnemyBullets:FlxTypedGroup<Bullet>, Player:Player, Tilemap:FlxTilemap)
	{
		x = X;
        y = Y;

        enemyBullets = EnemyBullets;
        player = Player;
        tilemap = Tilemap;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		updateMovements();
	}

	public function takeDamage(Damage:Int):Bool
	{
	    hp -= Damage;
	    FlxSpriteUtil.flicker(this, 0.15, 0.02, true);
        FlxG.camera.shake(0.006,0.06, null, false);

        if(hp <= 0){
            die();
            return true;
        }

        return false;
	}

	public function die():Void
	{
        // FlxG.camera.shake(0.015,0.2, null, false);
    	super.kill();
	}

	public function setTargetTile(Tilemap:FlxTilemap):Void
	{
	    var currentTileIndex = Tilemap.getTileIndexByCoords(new FlxPoint(x,y));

	    getTargetDirection(Tilemap);

		var targetCoords = new FlxPoint(0,0);

		switch(targetDirection)
		{
			case FlxObject.UP: targetCoords = new FlxPoint(x, y - 16);
			case FlxObject.DOWN: targetCoords = new FlxPoint(x, y + 16);
			case FlxObject.LEFT: targetCoords = new FlxPoint(x - 16, y);
			case FlxObject.RIGHT: targetCoords = new FlxPoint(x + 16, y);
		}

		var targetTileIndex = Tilemap.getTileIndexByCoords(targetCoords);

		// if target tile is already occupied, cancel target tile
		if(Reg.enemyTargetTiles.indexOf(targetTileIndex) != -1){
			targetTileIndex = currentTileIndex;
			targetDirection = FlxObject.NONE;
		}

		Reg.enemyTargetTiles.remove(currentTileIndex);
		Reg.enemyTargetTiles.push(targetTileIndex);

		// trace(currentTileIndex + ' -> ' + targetTileIndex);
	}

	public function move():Void
	{
		previousPosition = new FlxPoint(x, y);
		if(!moving && targetDirection != FlxObject.NONE) {
			facing = targetDirection;
			moving = true;
		}
	}

	public function updateMovements():Void
	{
		if(moving) {
			switch(facing)
			{
				case FlxObject.UP: y -= movespeed;
				case FlxObject.DOWN: y += movespeed;
				case FlxObject.LEFT: x -= movespeed;
				case FlxObject.RIGHT: x += movespeed;
			}

			if ((x % Reg.T_WIDTH == 0) && (y % Reg.T_HEIGHT == 0))
			{
				moving = false;
			}
		}
	}

	public function getTargetDirection(Tilemap:FlxTilemap):Void
	{
		targetDirection = random.getObject([FlxObject.NONE, FlxObject.RIGHT, FlxObject.LEFT, FlxObject.UP, FlxObject.DOWN]);
	}

	public function resetPosition():Void
	{
		moving = false;
		setPosition(previousPosition.x, previousPosition.y);
	}

	public function getCurrentTileIndex():Int
	{
		return tilemap.getTileIndexByCoords(new FlxPoint(x,y));
	}
}