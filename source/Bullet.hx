package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public var damage:Int = 1;

    public function new()
    {
        super();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function shoot(Pos:FlxPoint, Angle:Float):Bullet{
        trace('shoot');
 		return this;       
    }

    public function setSpeed(X:Float = null, Y:Float = null):Void{
    	
    }
}