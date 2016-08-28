package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

class RangedBullet extends Bullet
{
    var speed:Float;

    public function new()
    {
        super();

        makeGraphic(6, 14, FlxColor.YELLOW);
        speed = 400;
        // acceleration.y = 100;
        drag.x = 50;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    override public function shoot(Pos:FlxPoint, Angle:Float):Bullet{
        super.reset(Pos.x - width / 2, Pos.y - height / 2);

        angle = Angle;
        // angularVelocity = (angle > 0) ? 5 : -5;
        // angularAcceleration = angularVelocity * 2;
        // velocity = FlxVelocity.velocityFromAngle(angle - 90, speed);

        return this;
    }

    // override public function setSpeed(X:Float = null, Y:Float = null):Void{
    // 	velocity.x = (X != null) ? X : acceleration.x;
    // 	velocity.y = (Y != null) ? Y : acceleration.y;
    // }
}