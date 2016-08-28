package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;
import flixel.addons.util.FlxAsyncLoop;

class PlayState extends FlxState
{
	// Play stuff
	var random:FlxRandom;

	// Floormaker & Loading
	var loadingText:FlxText;
	var floorMaker:FloorMaker;
	var looper: FlxAsyncLoop;

	// Level
	public static var tilemap: FlxTilemap;
	var floorCount = 50;
	var map: Array<Array<Int>>;
	var levelCollidable: FlxGroup;

	// Units
	public static var enemies:FlxTypedGroup<Enemy>;
	var enemyBullets:FlxTypedGroup<Bullet>;

	public static var player:Player;
	var bullets:FlxTypedGroup<Bullet>;

	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = 0xff1e214a;

		var ext = 20;
		FlxG.camera.setSize(FlxG.width + ext, FlxG.height + ext);
		FlxG.camera.setPosition( - ext / 2, - ext / 2);

		random = new FlxRandom();

		setupLoading();
		setupFloormaker();
	}

	// This is called after setupFloormaker() finishes creating the map
	public function setupGame():Void
	{
		remove(loadingText);
		loadingText = null;

		setupLevel();
		setupPlayer();
		setupEnemies();

		add(tilemap);
		add(enemies);
		add(player);
		add(bullets);
		add(enemyBullets);

		FlxG.camera.focusOn(new FlxPoint(player.x, player.y));
		FlxG.camera.follow(player, null, 0.2);

		setupCollidables();
	}


	// SETUPS

	public function setupLoading():Void
	{
		var loadingText = new FlxText(10, FlxG.height - 18, FlxG.width, "Loading...");
		loadingText.setFormat(null, 8);

		add(loadingText);
	}

	public function setupFloormaker():Void
	{
		map = null;

		looper = new FlxAsyncLoop(floorCount, generateFloor, 10);
		looper.start();
		add(looper);

		floorMaker = new FloorMaker(floorCount);
	}

	public function generateFloor():Void
	{
		floorMaker.generateNextFloor();
		var percent:Float = floorMaker.floorCount/(floorMaker.maxFloors-1) * 100;
		// trace("Loading map: " + Math.round(percent));
	}

	public function setupEnemies():Void
	{
		enemies = new FlxTypedGroup<Enemy>(100);
		// enemies.maxSize = 100;

		enemyBullets = new FlxTypedGroup<Bullet>(100);
		// enemyBullets.maxSize = 100;

		spawnEnemies();
	}

	public function setupPlayer():Void
	{
		bullets = new FlxTypedGroup<Bullet>(5);
        // bullets.maxSize = 5;

        var startX = Math.round(floorCount/2 * Reg.T_WIDTH);
        var startY = Math.round(floorCount/2 * Reg.T_HEIGHT);
        player = new Player(startX, startY, bullets);
    }

    public function setupLevel():Void
    {
    	// var floorTileType = Reg.TILE_FLOOR;

    	tilemap = new FlxTilemap();
    	tilemap.useScaleHack = true;
		tilemap.setCustomTileMappings([0,Reg.TILE_FLOOR], [Reg.TILE_FLOOR], [Reg.TILE_FLOOR_VARIATIONS]);
		tilemap.loadMapFrom2DArray(map, "assets/images/LD36_Tilesheet.png", 16, 16);
		// tilemap.loadMapFrom2DArray(map, "assets/images/tiles_white.png", 16, 16);
		// trace(tilemap.width+ ' ' + tilemap.height);

		FlxG.worldBounds.width = (tilemap.widthInTiles + 1) * Reg.T_WIDTH;
		FlxG.worldBounds.height = (tilemap.heightInTiles + 1) * Reg.T_HEIGHT;

		tilemap.setTileProperties(0,FlxObject.ANY);
		tilemap.setTileProperties(1,FlxObject.NONE);
		tilemap.setTileProperties(2,FlxObject.NONE);

		// Floor variations
		tilemap.setTileProperties(26,FlxObject.NONE);
		tilemap.setTileProperties(27,FlxObject.NONE);
		tilemap.setTileProperties(28,FlxObject.NONE);
	}

	public function spawnEnemies()
	{
		var floorIndices = [];

		for(floorTile in Reg.TILE_FLOOR_VARIATIONS) {
			for(tileIndex in tilemap.getTileInstances(floorTile)){
				floorIndices.push(tileIndex);
			}
		}

		trace(floorIndices);

		var enemiesToSpawn = 2;

		for(i in 0...enemiesToSpawn){
			var randomIndex = random.getObject(floorIndices);
			var coord = tilemap.getTileCoordsByIndex(randomIndex, false);
			enemies.recycle(Enemy).init(coord.x, coord.y, enemyBullets, player);
		}
	}

	public function setupCollidables():Void
	{
		levelCollidable = new FlxGroup();

		levelCollidable.add(bullets);
		levelCollidable.add(enemyBullets);
		// levelCollidable.add(enemyGibs);
		// levelCollidable.add(whiteGibs);
		levelCollidable.add(player);
		levelCollidable.add(enemies);
	}


	// GAMEPLAY

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(map == null){
			if(!looper.started){
				looper.start();
			} else {
				if(looper.finished){
					trace('done');
					looper.kill();
					looper.destroy();

					map = floorMaker.map;
					trace(map);
					setupGame();
				}
			}

			return;
		}


		if(FlxG.keys.justPressed.R){
			FlxG.switchState(new PlayState());
		}

		handleCollisions();

		// if(FlxG.keys.pressed.RIGHT){
		// 	FlxG.camera.x -= 3;
		// }
		// if(FlxG.keys.pressed.LEFT){
		// 	FlxG.camera.x += 3;
		// }
		// if(FlxG.keys.pressed.DOWN){
		// 	FlxG.camera.y -= 3;
		// }
		// if(FlxG.keys.pressed.UP){
		// 	FlxG.camera.y += 3;
		// }
	}

	
	override public function destroy():Void
	{
		tilemap = null;
		player = null;
		bullets = null;
		enemies = null;
		enemyBullets = null;

		super.destroy();
	}

	public function handleCollisions():Void
	{
		FlxG.collide(levelCollidable, tilemap, onCollision);
		// FlxG.overlap(enemies, tilemap, enemyCollideWall);
		// FlxG.collide(player, enemies, onCollision);

		// FlxG.collide(enemies, enemies);

		FlxG.overlap(bullets, enemies, bulletHit);
		FlxG.overlap(player, enemies, playerHit);
		FlxG.overlap(player, enemyBullets, playerHit);
	}

	public function enemyCollideWall(Enemy:Enemy, Map:FlxObject):Void
	{
		trace('overlap');
		// Enemy.resetPosition();
	}

	public function onCollision(Object1: FlxObject, Object2: FlxObject):Void
	{
		if(Std.is(Object1,Player)) {
			player.resetPosition();
		}

		if(Std.is(Object1, Bullet)){
			Object1.kill();

			// gibs?
		}
	}

	private function bulletHit(Bullet:Bullet, Enemy:Enemy):Void
	{
		Bullet.kill();

		// if enemy died on take damage
		if(Enemy.takeDamage(Reg.playerDamage)){
			// enemyGibs.at(Bullet);
			// enemyGibs.start(true,1,0,20,3);
		}
	}

	private function playerHit(Player:Player, HitObject:FlxObject):Void{
		if (Std.is(HitObject, Bullet)){
			HitObject.kill();
		}

		player.takeDamage(1);
	}

	public static function playerDie(){
		
	}

	public static function moveAllEnemies() {
		Reg.enemyTargetTiles = [];
		enemies.forEachAlive(moveEnemy);
		trace(Reg.enemyTargetTiles);
	}

	public static function moveEnemy(Enemy:Enemy):Void
	{
		Enemy.setTargetTile(tilemap);
		Enemy.move();
	}
}