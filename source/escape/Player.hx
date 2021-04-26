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
  static inline var JUMP_SPEED = 320;
  static inline var LADDER_SPEED = 160;
  static inline var DRAG: Int = 640;
  static inline var GRAVITY = 640;
  static inline var MAX_VELOCITY_X = 160;
  static inline var MAX_VELOCITY_Y = 640;
  static inline var WALK_FPS = 12;

  public var actionMessage: ActionMessage;

  var climbing = false;
  var walkRightFoot = false;
  var canWallJump = false;

  public function new(x: Float, y: Float) {
    super(x, y);

    loadGraphic(AssetPaths.player__png, true, WIDTH, HEIGHT);
    animation.add("walkRightFoot", [1, 2, 1, 0], WALK_FPS, false);
    animation.add("walkLeftFoot", [3, 4, 3, 0], WALK_FPS, false);

    setFacingFlip(LEFT, true, false);
    setFacingFlip(RIGHT, false, false);

    drag.set(DRAG, DRAG);
    acceleration.y = GRAVITY;
    maxVelocity.set(MAX_VELOCITY_X, MAX_VELOCITY_Y);

    actionMessage = new ActionMessage();
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

    if (left) {
      facing = LEFT;
    } else if (right) {
      facing = RIGHT;
    }

    if (up || down) {
      if (climbing) {
        velocity.y = down ? LADDER_SPEED : -LADDER_SPEED;
      } else if (up) {
        if (canWallJump || velocity.y == 0) {
          velocity.y = -JUMP_SPEED;

          animation.pause();
        }

        if (canWallJump && (left || right)) {
          velocity.x = right ? -MOVEMENT_ACCELERATION : MOVEMENT_ACCELERATION;
        }
      }
    } else {
      if (left) {
        acceleration.x -= MOVEMENT_ACCELERATION;

        animateWalk();
      } else if (right) {
        acceleration.x += MOVEMENT_ACCELERATION;

        animateWalk();
      }
    }
  }

  public function updateBeforeCollisionChecks(elapsed: Float) {
    climbing = false;
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

  public static function onWallJumpTrigger(player: Player, trigger: Trigger) {
    player.wallJumpTrigger(trigger);
  }

  function wallJumpTrigger(trigger: Trigger) {
    actionMessage.show("LEFT/RIGHT to wall jump");
    canWallJump = true;
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
