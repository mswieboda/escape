package escape;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class Ladder extends FlxGroup {
  public static inline var TILE = 'L';
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 32;
  public static inline var TOP = 0;
  public static inline var MIDDLE = 1;
  public static inline var BOTTOM = 2;

  public var trigger: Trigger;

  var sprite: FlxSprite;

  public function new(x: Float, y: Float, section: Int) {
    super();

    sprite = new FlxSprite(x, y);
    sprite.immovable = true;
    sprite.moves = false;
    sprite.solid = false;

    sprite.loadGraphic(AssetPaths.ladder__png, true, WIDTH, HEIGHT);
    sprite.animation.frameIndex = section;

    trigger = new Trigger(x, y - HEIGHT / 2, WIDTH, HEIGHT * 2, this);

    add(sprite);
  }
}
