package escape;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class Ladder extends FlxGroup {
  public static inline var TILE = 'L';
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 32;

  public var trigger: LadderTrigger;

  var sprite: FlxSprite;

  public function new(x: Float, y: Float, tiles: Int) {
    super();

    sprite = new FlxSprite(x, y);
    sprite.immovable = true;
    sprite.moves = false;
    sprite.solid = false;

    sprite.makeGraphic(WIDTH, HEIGHT * tiles, 0x33333333);

    trigger = new LadderTrigger(x, y - HEIGHT / 2, WIDTH, HEIGHT * (tiles + 1), this);

    add(sprite);
  }
}
