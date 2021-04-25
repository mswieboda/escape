package escape;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Player extends FlxSprite {
  static inline var WIDTH = 24;
  static inline var HEIGHT = 56;
  static inline var MOVEMENT_ACCELERATION = 640;
  static inline var JUMP_SPEED = 320;
  static inline var LADDER_SPEED = 160;
  static inline var DRAG: Int = 640;
  static inline var GRAVITY = 640;
  static inline var MAX_VELOCITY_X = 160;
  static inline var MAX_VELOCITY_Y = 640;
  static inline var WALK_FPS = 3;

  public var actionMessage: ActionMessage;

  var climbing = false;

  public function new(x: Float, y: Float, color: FlxColor = FlxColor.WHITE) {
    super(x, y);

    this.color = color;

    loadGraphic(AssetPaths.player__png, true, WIDTH, HEIGHT);
    animation.add("walk", [1, 0, 2, 0], WALK_FPS, false);

    setFacingFlip(LEFT, false, false);
    setFacingFlip(RIGHT, true, false);

    drag.x = DRAG;
    acceleration.y = GRAVITY;
    maxVelocity.set(MAX_VELOCITY_X, MAX_VELOCITY_Y);

    actionMessage = new ActionMessage();
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    updateMovement();
  }

  function updateMovement() {
    var lefts = [FlxKey.LEFT, FlxKey.A];
    var rights = [FlxKey.RIGHT, FlxKey.D];
    var left = FlxG.keys.anyPressed(lefts);
    var right = FlxG.keys.anyPressed(rights);
    var jump = FlxG.keys.anyJustPressed([UP, W]);

    if (left && right) left = right = false;

    acceleration.x = 0;

    FlxSpriteUtil.bound(this);

    if (FlxG.keys.anyJustReleased(lefts.concat(rights))) {
      animation.pause();
    }

    if (left) {
      acceleration.x -= MOVEMENT_ACCELERATION;
      facing = LEFT;
      animation.play("walk");
    } else if (right) {
      acceleration.x += MOVEMENT_ACCELERATION;
      facing = RIGHT;
      animation.play("walk");
    }

    // TODO: check `velocity.y == 0` etc (not currently working, it's `7`)
    // to see if they're on the floor, before jumping
    if (jump && !climbing) {
      // so we're not initially colliding with the floor
      y -= 1;
      velocity.y = -JUMP_SPEED;
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

    var ladder = trigger.ladder;
    var down = FlxG.keys.anyPressed([DOWN, S]);
    var up = FlxG.keys.anyPressed([UP, W]);

    velocity.y = 0;
    acceleration.y = 0;

    if (down && up) up = down = false;
    if (!down && !up) return;

    climbing = true;

    velocity.y = down ? LADDER_SPEED : -LADDER_SPEED;
  }
}
