package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

class MeleeBullet extends Bullet
{
    var timer:FlxTimer;

    public function new()
    {
        super();

        timer = new FlxTimer();

        damage = 1;

        // makeGraphic(16,16, 0x00000000);
        makeGraphic(16,16, FlxColor.YELLOW);

		// setFacingFlip(FlxObject.LEFT, true, false);
        // setFacingFlip(FlxObject.RIGHT, false, false);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    private function destroyBullet(Timer:FlxTimer):Void{
        kill();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public override function shoot(Pos:FlxPoint, Angle:Float):Bullet{
        super.reset(Pos.x, Pos.y);
        timer.start(0.05, destroyBullet, 1);

        return this;
    }
}