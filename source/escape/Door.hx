package escape;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class Door extends FlxGroup {
  public static inline var TILE = 'D';
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 64;
  public static inline var FPS = 6;

  public var trigger: Trigger;
  public var locked: Bool;

  var sprite: FlxSprite;
  var animating = false;

  public function new(x: Float, y: Float, locked = true) {
    super();

    sprite = new FlxSprite(x, y);
    sprite.immovable = true;

    var frames = [for(i in 0...11) i];
    var frameReversed = frames.copy();

    frameReversed.reverse();

    sprite.loadGraphic(AssetPaths.door__png, true, WIDTH, HEIGHT);
    sprite.animation.add("up", frames, FPS, false);
    sprite.animation.add("down", frameReversed, FPS, false);

    trigger = new DoorTrigger(x - WIDTH / 2, y, WIDTH * 2, HEIGHT, this);

    this.locked = locked;

    add(sprite);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    checkLocked();
  }

  function checkLocked() {
    if (!animating || !sprite.animation.finished) return;

    if (locked) {
      setUnlocked();
    } else {
      setLocked();
    }
  }

  public function unlock() {
    animating = true;
    sprite.animation.play("up");
  }

  public function lock() {
    animating = true;
    sprite.animation.play("down");
  }

  function setLocked() {
    animating = false;
    locked = true;
    sprite.solid = true;
  }

  function setUnlocked() {
    animating = false;
    locked = false;
    sprite.solid = false;
  }

  public static function onDoorTrigger(player: Player, trigger: DoorTrigger): Bool {
    return trigger.door.locked;
  }
}
