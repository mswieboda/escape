package escape;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTile;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class Player extends FlxSprite {
  // size, position
  public static inline var WIDTH = 24;
  public static inline var HEIGHT = 48;
  public static inline var TILE = 'P';

  // movement
  public static inline var GRAVITY = 640;
  static inline var MOVEMENT_ACCELERATION = 640;
  static inline var JUMP_X_MOVEMENT_ACCELERATION = 192;
  static inline var JUMP_SPEED = 256;
  static inline var WALL_JUMP_X_SPEED = 320;
  static inline var WALL_JUMP_Y_SPEED = 192;
  static inline var LADDER_SPEED = 160;
  static inline var DRAG: Int = 640;
  static inline var MAX_VELOCITY_X = 160;
  static inline var MAX_VELOCITY_Y = 640;
  static inline var WATER_DRAG_X_RATIO = -0.75;
  static inline var WATER_DRAG_Y_RATIO = -0.5;
  static inline var WATER_GRAVITY_RATIO = -0.7;

  // animation
  static inline var WALK_FPS = 12;
  static inline var IDLE_FPS = 12;
  static inline var IDLE_TIME = 0.75;
  static inline var WATER_FPS_RATIO = -0.75;
  static var ANIMATION_FPS: Map<String, Int> = [
    "walkRightFoot" => WALK_FPS,
    "walkLeftFoot" => WALK_FPS,
    "wallJump" => WALK_FPS,
    "idleJump" => WALK_FPS,
    "idle" => IDLE_FPS
  ];

  // sound
  static inline var FLOOR_MAX_VELOCITY = 480;

  static inline var FEET_TRIGGER_HEIGHT = 16;

  public var actionMessage: ActionMessage;
  public var feetTrigger: Trigger;

  var climbing = false;
  var walkRightFoot = false;
  var canWallJump = false;
  var idleTimer: FlxTimer;
  var firstFrame = true;
  var reachedMaxVelocityFromFloor = false;
  var triggeredMaxVelocityFromFloor = false;
  var inWater = false;
  var alreadyHitWater = false;

  public function new() {
    super();

    loadGraphic(AssetPaths.player__png, true, WIDTH, HEIGHT);

    animation.add("walkRightFoot", [1, 2, 1, 0], ANIMATION_FPS["walkRightFoot"], false);
    animation.add("walkLeftFoot", [3, 4, 3, 0], ANIMATION_FPS["walkLeftFoot"], false);
    animation.add("wallJump", [5, 3, 4], ANIMATION_FPS["wallJump"], false);
    animation.add("idleJump", [1, 2], ANIMATION_FPS["idleJump"], false);
    animation.add("idle", [0, 6], ANIMATION_FPS["idle"], false);

    setFacingFlip(FlxObject.LEFT, true, false);
    setFacingFlip(FlxObject.RIGHT, false, false);

    drag.set(DRAG, DRAG);
    acceleration.y = GRAVITY;
    maxVelocity.set(MAX_VELOCITY_X, MAX_VELOCITY_Y);

    actionMessage = new ActionMessage();

    feetTrigger = new Trigger(
      x,
      y + height - FEET_TRIGGER_HEIGHT,
      width,
      FEET_TRIGGER_HEIGHT
    );

    idleTimer = new FlxTimer();
    idleTimer.start(IDLE_TIME);
  }

  override public function update(elapsed: Float) {
    updateMovement();

    super.update(elapsed);
  }

  function updateMovement() {
    if (firstFrame) {
      firstFrame = false;
      return;
    }

    var left = Actions.game.left.triggered;
    var right = Actions.game.right.triggered;
    var down = Actions.game.down.triggered;
    var up = Actions.game.up.triggered;
    var jump = Actions.game.jump.triggered;

    if (left && right) left = right = false;
    if (down && up) up = down = false;

    // for stuff like water, mud, quicksand etc to slow down
    var movementXRatio = 1.0;
    var movementYRatio = 1.0;
    var gravityRatio = 1.0;
    var fpsRatio = 1.0;

    if (inWater) {
      movementXRatio += WATER_DRAG_X_RATIO;
      movementYRatio += WATER_DRAG_Y_RATIO;
      gravityRatio += WATER_GRAVITY_RATIO;
      fpsRatio += WATER_FPS_RATIO;
    }

    if (animation.curAnim != null && animation.name != null) {
      animation.curAnim.frameRate = ANIMATION_FPS[animation.name] * fpsRatio;
    }

    acceleration.x = 0;
    acceleration.y = climbing ? 0 : GRAVITY * gravityRatio;

    if (climbing && (up || down)) {
      velocity.y = (down ? LADDER_SPEED : -LADDER_SPEED) * movementYRatio;
    }

    if (jump) {
      if (velocity.y == 0) {
        velocity.y = -JUMP_SPEED * movementYRatio;

        animation.pause();
      } else if (canWallJump && (left || right)) {
        velocity.x = (left ? WALL_JUMP_X_SPEED : -WALL_JUMP_X_SPEED) * movementXRatio;
        velocity.y = -WALL_JUMP_Y_SPEED * movementYRatio;

        facing = left ? FlxObject.RIGHT : FlxObject.LEFT;

        animation.resume();
      }

      Sound.play("jump", 0.5);
    }

    if (velocity.y == 0) {
      if (left) {
        facing = FlxObject.LEFT;
        acceleration.x -= MOVEMENT_ACCELERATION * movementXRatio;

        animateWalk();
      } else if (right) {
        facing = FlxObject.RIGHT;
        acceleration.x += MOVEMENT_ACCELERATION * movementXRatio;

        animateWalk();
      } else {
        // idle animation and delay
        if (animation.name != "idle" || animation.finished) {
          animation.play("idle");
          animation.pause();
          idleTimer.reset(IDLE_TIME);
        } else if (animation.paused && idleTimer.finished) {
          animation.play("idle");

          Sound.play("breath");
        }
      }
    } else {
      if (left || right) {
        acceleration.x += (left ? -JUMP_X_MOVEMENT_ACCELERATION : JUMP_X_MOVEMENT_ACCELERATION) * movementXRatio;
      } else if (animation.name != "idleJump") {
        animation.play("idleJump");
      }
    }

    // lock feetTrigger to player position
    feetTrigger.setPosition(x, y + height - FEET_TRIGGER_HEIGHT);
  }

  public function updateBeforeCollisionChecks() {
    climbing = false;
    canWallJump = false;

    if (triggeredMaxVelocityFromFloor) {
      if (velocity.y <= 0) {
        triggeredMaxVelocityFromFloor = false;
        reachedMaxVelocityFromFloor = false;
      }
    } else {
      if (velocity.y >= FLOOR_MAX_VELOCITY) {
        reachedMaxVelocityFromFloor = true;
      }
    }

    if (!inWater) {
      alreadyHitWater = false;
    }

    inWater = false;

    actionMessage.hide();
  }

  public static function onHitSpikes(spike: Spike, player: Player) {
    player.hitSpike(spike);
  }

  public function hitSpike(spike: Spike) {
    // TODO: bloody spikes animation
    // set this.killing = true
    // when animation done, kill!
    kill();
  }

  public static function onDoorTrigger(trigger: Trigger, player: Player) {
    player.doorTrigger(cast(trigger.parent, Door));
  }

  function doorTrigger(door: Door) {
    // TODO: have actionMessage come from actions gamepad/keyboard etc somehow
    actionMessage.show("[action] to open");

    if (door.locked && Actions.game.action.triggered) {
      door.unlock();
    }
  }

  public static function onLadderTrigger(trigger: Trigger, player: Player) {
    player.ladderTrigger(cast(trigger.parent, Ladder));
  }

  function ladderTrigger(ladder: Ladder) {
    // TODO: have actionMessage come from actions gamepad/keyboard etc somehow
    actionMessage.show("[down/up] to descend/climb");

    climbing = true;
  }

  public function onLeftWallJumpTrigger(trigger: Trigger, feetTrigger: Trigger) {
    // TODO: have actionMessage come from actions gamepad/keyboard etc somehow
    actionMessage.show("hold [left] then press [jump] to wall jump");

    if (!canWallJump && Actions.game.left.triggered) {
      canWallJump = true;
      facing = FlxObject.LEFT;
      animation.play("wallJump");
      animation.pause();
    }
  }

  public function onRightWallJumpTrigger(trigger: Trigger, feetTrigger: Trigger) {
    // TODO: have actionMessage come from actions gamepad/keyboard etc somehow
    actionMessage.show("hold [right] then press [jump] to wall jump");

    if (!canWallJump && Actions.game.right.triggered) {
      canWallJump = true;
      facing = FlxObject.RIGHT;
      animation.play("wallJump");
      animation.pause();
    }
  }

  public function onFloorTrigger(trigger: Trigger, feetTrigger: Trigger) {
    if (!triggeredMaxVelocityFromFloor && reachedMaxVelocityFromFloor) {
      triggeredMaxVelocityFromFloor = true;

      // TODO: break leg/slow down, etc
      //       temporarily for a min, 3 mins, etc

      FlxG.camera.shake(0.015, 0.3);
      Sound.play("jump", 0.5);
    }
  }

  public function onWaterTile(tile: FlxObject, feetTrigger: FlxObject): Bool {
    // check a fake/temp hitbox, with an offset, and width/height adjustments
    var overlapFound = feetTrigger.x + feetTrigger.width > tile.x
      && feetTrigger.x < tile.x + tile.width
      && feetTrigger.y + feetTrigger.height > tile.y
      && feetTrigger.y < tile.y + tile.height;

    if (overlapFound) {
      inWater = true;

      if (!alreadyHitWater) {
        alreadyHitWater = true;

        // TODO: add a particle splash at the intersection point

        Sound.play("splash", 0.3);
        FlxG.camera.shake(0.0015, 0.15);
      }
    }

    return overlapFound;
  }

  function animateWalk() {
    if (velocity.y != 0) return;

    if ((animation.name != "walkLeftFoot" && animation.name != "walkRightFoot") || animation.finished) {
      if (walkRightFoot) {
          walkRightFoot = false;
          animation.play("walkLeftFoot");
      } else {
        walkRightFoot = true;
        animation.play("walkRightFoot");
      }
    } else {
      animation.resume();
    }
  }
}
