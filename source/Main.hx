package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(320, 200, PlayState, 3, 60, 60, true));
		// addChild(new FlxGame(320, 200, PlayState, 3, 60, 60, true));
		// addChild(new FlxGame(480, 320, MapTestState, 2, 60, 60, true));

		FlxG.mouse.visible = false;
	}
}
