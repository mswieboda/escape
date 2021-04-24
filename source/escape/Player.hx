package escape;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;

class Player extends FlxSprite {
  static inline var MOVEMENT_SPEED = 100;
  static inline var DRAG: Int = 1000;
  static inline var WALK_FPS = 6;

  var direction: Int;

  public function new(x: Float, y: Float, color: FlxColor = FlxColor.WHITE) {
    super(x, y);

    this.color = color;

    makeGraphic(32, 32, FlxColor.LIME);

    // loadGraphic(AssetPaths.player__png, true, 32, 32);

    // animation.add("walk", [0, 2, 1, 2], WALK_FPS, false);

    drag.x = drag.y = DRAG;
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

    if (left && right) left = right = false;

    if (FlxG.keys.anyJustReleased(lefts.concat(rights))) {
      // animation.pause();
    }

    if (!(left || right)) return;

    var vx = velocity.x;
    var vy = velocity.y;

    if (left) {
      vx = -MOVEMENT_SPEED;
      facing = LEFT;
    } else if (right) {
      vx = MOVEMENT_SPEED;
      facing = RIGHT;
    }

    // animation.play(facingToAnimation());

    var distance = Math.sqrt(Math.pow(vx, 2) + Math.pow(vy, 2));

    vx = vx / distance * MOVEMENT_SPEED;

    velocity.set(vx, vy);
  }

  function facingToAnimation() {
    switch (facing) {
      case LEFT:
        return "walk";
      case RIGHT:
        return "walk";
      default:
        return "none";
    }
  }
}
