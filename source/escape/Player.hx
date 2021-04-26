package escape;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Player extends FlxSprite {
  static inline var WIDTH = 24;
  static inline var HEIGHT = 48;
  static inline var MOVEMENT_ACCELERATION = 640;
  static inline var JUMP_X_MOVEMENT_ACCELERATION = 192;
  static inline var JUMP_SPEED = 256;
  static inline var WALL_JUMP_X_SPEED = 320;
  static inline var WALL_JUMP_Y_SPEED = 192;
  static inline var LADDER_SPEED = 160;
  static inline var DRAG: Int = 640;
  static inline var GRAVITY = 640;
  static inline var MAX_VELOCITY_X = 160;
  static inline var MAX_VELOCITY_Y = 640;
  static inline var WALK_FPS = 12;
  static inline var FEET_TRIGGER_HEIGHT = 16;

  public var actionMessage: ActionMessage;
  public var feetTrigger: Trigger;

  var climbing = false;
  var walkRightFoot = false;
  var canWallJump = false;

  public function new(x: Float, y: Float) {
    super(x, y);

    loadGraphic(AssetPaths.player__png, true, WIDTH, HEIGHT);
    animation.add("walkRightFoot", [1, 2, 1, 0], WALK_FPS, false);
    animation.add("walkLeftFoot", [3, 4, 3, 0], WALK_FPS, false);
    animation.add("wallJump", [5], 0, false);

    setFacingFlip(LEFT, true, false);
    setFacingFlip(RIGHT, false, false);

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
  }

  override public function update(elapsed: Float) {
    updateMovement();

    super.update(elapsed);
  }

  function updateMovement() {
    var lefts = [FlxKey.LEFT, FlxKey.A];
    var rights = [FlxKey.RIGHT, FlxKey.D];
    var left = FlxG.keys.anyPressed(lefts);
    var right = FlxG.keys.anyPressed(rights);
    var down = FlxG.keys.anyPressed([DOWN, S]);
    var up = FlxG.keys.anyPressed([UP, W]);

    if (left && right) left = right = false;
    if (down && up) up = down = false;

    acceleration.x = 0;
    acceleration.y = climbing ? 0 : GRAVITY;

    if (up || down) {
      if (climbing) {
        velocity.y = down ? LADDER_SPEED : -LADDER_SPEED;
      } else if (up) {
        if (velocity.y == 0) {
          velocity.y = -JUMP_SPEED;

          animation.pause();
        } else if (canWallJump && (left || right)) {
          velocity.x = left ? WALL_JUMP_X_SPEED : -WALL_JUMP_X_SPEED;
          velocity.y = -WALL_JUMP_Y_SPEED;

          facing = left ? RIGHT : LEFT;

          animation.pause();
        } else if (left || right) {
          acceleration.x += left ? -JUMP_X_MOVEMENT_ACCELERATION : JUMP_X_MOVEMENT_ACCELERATION;
        }
      }
    } else {
      if (left) {
        if (velocity.y == 0 || climbing) facing = LEFT;
        acceleration.x -= MOVEMENT_ACCELERATION;

        animateWalk();
      } else if (right) {
        if (velocity.y == 0 || climbing) facing = RIGHT;
        acceleration.x += MOVEMENT_ACCELERATION;

        animateWalk();
      }
    }

    // lock feetTrigger to player position
    feetTrigger.setPosition(x, y + height - FEET_TRIGGER_HEIGHT);
  }

  public function updateBeforeCollisionChecks(elapsed: Float) {
    climbing = false;
    canWallJump = false;
    acceleration.y = GRAVITY;

    actionMessage.hide();
  }

  public static function onHitSpikes(player: Player, spike: Spike) {
    player.hitSpike(spike);
  }

  public function hitSpike(spike: Spike) {
    // TODO: bloody spikes animation
    // set this.killing = true
    // when animation done, kill!
    kill();
  }

  public static function onDoorTrigger(player: Player, trigger: DoorTrigger) {
    player.doorTrigger(trigger);
  }

  function doorTrigger(trigger: DoorTrigger) {
    actionMessage.show("SPACE/ENTER to open");

    var door = trigger.door;

    if (door.locked && FlxG.keys.anyJustPressed([SPACE, ENTER])) {
      door.unlock();
    }
  }

  public static function onLadderTrigger(player: Player, trigger: LadderTrigger) {
    player.ladderTrigger(trigger);
  }

  function ladderTrigger(trigger: LadderTrigger) {
    actionMessage.show("DOWN/UP to descend/climb");
    climbing = true;
  }

  public function onLeftWallJumpTrigger(feetTrigger: Trigger, trigger: Trigger) {
    actionMessage.show("hold LEFT then press UP to wall jump");

    if (FlxG.keys.anyPressed([LEFT, A])) {
      canWallJump = true;
      facing = LEFT;
      animation.play("wallJump");
    }
  }

  public function onRightWallJumpTrigger(feetTrigger: Trigger, trigger: Trigger) {
    actionMessage.show("hold RIGHT then press UP to wall jump");

    if (FlxG.keys.anyPressed([RIGHT, D])) {
      canWallJump = true;
      facing = RIGHT;
      animation.play("wallJump");
    }
  }

  function animateWalk() {
    if (velocity.y != 0) return;

    if (animation.finished) {
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
