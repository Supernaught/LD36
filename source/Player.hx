package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	// Stats
	var hp:Int = 10;

	// Movement stuff
	public var movespeed:Float = 8;
	public var moving:Bool = false;
	public var targetPosition:FlxPoint;
	var previousPosition:FlxPoint;

	// Attack stuff
	var canAttack:Bool;
	var attackDelay:Float = 0.2;
	var attackType:Int;

	// Units stuff
	private var bullets:FlxTypedGroup<Bullet>;
    // private var effects:FlxTypedGroup<WooshEffects>;

    // Other stuff
    var timer:FlxTimer;

    public function new(X:Int = 64, Y:Int = 64, Bullets = null)
    {
    	super(X, Y);

    	bullets = Bullets;
    	// attackType = Reg.MELEE;
    	attackType = Reg.RANGED;

		makeGraphic(16,16, FlxColor.GREEN);
		// loadGraphic(Reg.PLAYER_SPRITE, null, 16, 16);

		timer = new FlxTimer();
		canAttack = true;

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		// loadGraphic("assets/images/Hero_Sprite.png");

		trace(X, Y);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		movementControls();
		attackControls();
		updateMovements();
	}

	// MOVEMENT

	public function movementControls():Void
	{
		if(!moving) {
			if(FlxG.keys.justPressed.UP){
				move(FlxObject.UP);
			}
			if(FlxG.keys.justPressed.DOWN){
				move(FlxObject.DOWN);
			}
			if(FlxG.keys.justPressed.RIGHT){
				move(FlxObject.RIGHT);
			}
			if(FlxG.keys.justPressed.LEFT){
				move(FlxObject.LEFT);
			}
		}
	}

	public function updateMovements():Void
	{
		// if(moving){
		// 	FlxVelocity.moveTowardsPoint(this, targetPosition);
		// 	// trace(x + ', ' + y + ' -> ' + targetPosition);
		// } else {
		// 	acceleration.x = 0;
		// 	acceleration.y = 0;
		// 	// trace('done');
		// }

		//  -------

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

	public function attackControls():Void
	{
		if(FlxG.keys.justPressed.X) {
			attemptAttack();
		}
	}

	public function move(TargetFacing:Int):Void
	{
		// trace(Reg.enemyTargetTiles);
		previousPosition = new FlxPoint(x,y);

		if(!moving) {
			facing = TargetFacing;
			moving = true;

			switch(facing)
			{
				case FlxObject.UP: targetPosition = new FlxPoint(x,y - Reg.T_HEIGHT);
				case FlxObject.DOWN: targetPosition = new FlxPoint(x,y + Reg.T_HEIGHT);
				case FlxObject.LEFT: targetPosition = new FlxPoint(x - Reg.T_WIDTH,y);
				case FlxObject.RIGHT: targetPosition = new FlxPoint(x + Reg.T_WIDTH,y);
			}

			// trace(x + ', ' + y + ' -> ' + targetPosition);

			PlayState.moveAllEnemies();
		}

		// trace("Moved to: " + x/16 + ' ' + y/16);		
	}

	// public function movedToTargetPosition():Bool
	// {
	// 	trace(Math.abs(x - targetPosition.x));
	// 	return Math.floor(Math.abs(x - targetPosition.x)) <= 0 && Math.floor(Math.abs(y - targetPosition.y)) <= 0;
	// }

	// ATTACK STUFF

	public function takeDamage(Damage: Int):Void
	{
		hp -= Damage;
	}

	public function attemptAttack():Void
	{
		if(canAttack) {
			attack();
		}
	}

	public function attack():Void
	{
		if(attackType == Reg.MELEE) {
			var xAttackPos = x;
			var yAttackPos = y;

			switch(facing) {
				case FlxObject.RIGHT: xAttackPos += Reg.T_WIDTH;
				case FlxObject.LEFT: xAttackPos -= Reg.T_WIDTH;
				case FlxObject.UP: yAttackPos -= Reg.T_HEIGHT;
				case FlxObject.DOWN: yAttackPos += Reg.T_HEIGHT;
			}

			bullets.recycle(MeleeBullet).shoot(new FlxPoint(xAttackPos, yAttackPos), 0);
		} else if(attackType == Reg.RANGED) {
			var shootAngle = 0;

			switch(facing) {
				case FlxObject.RIGHT: shootAngle = 90;
				case FlxObject.LEFT: shootAngle = -90;
				case FlxObject.UP: shootAngle = 0;
				case FlxObject.DOWN: shootAngle = 180;
			}

			bullets.recycle(RangedBullet).shoot(new FlxPoint(getGraphicMidpoint().x,getGraphicMidpoint().y), shootAngle);
		}
		
		canAttack = false;
		timer.start(0, enableAttack);
	}

	private function enableAttack(Timer:FlxTimer):Void{
		canAttack = true;
	}

	public function resetPosition():Void
	{
		moving = false;
		setPosition(previousPosition.x, previousPosition.y);
	}
}