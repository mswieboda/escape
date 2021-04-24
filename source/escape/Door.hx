package escape;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class Door extends FlxGroup {
  public static inline var TILE = 'd';
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 64;

  public var trigger: Trigger;
  public var locked: Bool;

  var sprite: FlxSprite;

  public function new(x: Float, y: Float, locked = true) {
    super();

    sprite = new FlxSprite(x, y);
    sprite.immovable = true;
    sprite.makeGraphic(WIDTH, HEIGHT, FlxColor.BROWN);

    trigger = new DoorTrigger(x - WIDTH / 2, y, WIDTH * 2, HEIGHT, this);

    this.locked = locked;

    add(sprite);
  }

  public function unlock() {
    trace(">>> Door unlock");
    locked = false;
    sprite.solid = false;

    // TODO: change sprite frame
  }

  public function lock() {
    locked = true;
    sprite.solid = true;

    // TODO: change sprite frame
  }

  public static function onDoorTrigger(player: Player, trigger: DoorTrigger): Bool {
    return trigger.door.locked;
  }
}
