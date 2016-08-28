package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;

class MapTestState extends FlxState
{
	var floorMaker:FloorMaker;

	var tilemap: FlxTilemap;

	var player:Player;

	var floorCount = 100;

	override public function create():Void
	{
		super.create();

		generateMap();

		player = new Player(Math.round(floorCount/2 * Reg.T_WIDTH), Math.round(floorCount/2 * Reg.T_HEIGHT), null);
		add(player);

		FlxG.camera.follow(player, null, 0.2);
	}

	public function generateMap():Void
	{
	    floorMaker = new FloorMaker(floorCount);
		tilemap = new FlxTilemap();

		tilemap.loadMapFrom2DArray(floorMaker.map, "assets/images/tiles.png", 16, 16);
		// tilemap.loadMapFrom2DArray(floorMaker.map, "assets/images/ld33_tilesheet.png", 16, 16);
		trace(tilemap.width+ ' ' + tilemap.height);

		FlxG.worldBounds.width = (tilemap.widthInTiles + 1) * Reg.T_WIDTH;
		FlxG.worldBounds.height = (tilemap.heightInTiles + 1) * Reg.T_HEIGHT;

		add(tilemap);

		// FlxG.camera.focusOn(new FlxPoint(110/2, 110/2));
		// FlxG.camera.follow(tilemap);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(FlxG.keys.justPressed.R){
			FlxG.switchState(new MapTestState());
		}

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
}
