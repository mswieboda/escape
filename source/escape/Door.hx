package escape;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class Door extends FlxGroup {
  public static inline var TILE = 'd';
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 32;

  public var sprite: FlxSprite;
  public var trigger: Trigger;

  public function new(x: Float, y: Float) {
    super();

    sprite = new FlxSprite(x, y);
    sprite.immovable = true;
    sprite.makeGraphic(WIDTH, HEIGHT, FlxColor.BROWN);

    trigger = new Trigger(x -  WIDTH / 2, y - HEIGHT / 2, WIDTH * 2, HEIGHT * 2);

    add(sprite);
  }
}
