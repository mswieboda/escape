package escape;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Door extends FlxSprite {
  public static inline var TILE = 'd';
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 32;

  public function new(x: Float, y: Float) {
    x -= WIDTH / 2;
    y -= HEIGHT / 2;

    super(x, y);

    makeGraphic(WIDTH, HEIGHT, FlxColor.BROWN);

    setSize(WIDTH * 2, HEIGHT * 2);
    offset.set(-WIDTH / 2, -HEIGHT / 2);
    // updateHitbox();

    immovable = true;
    solid = false;
  }
}
