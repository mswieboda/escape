package escape;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Spike extends FlxSprite {
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 32;

  public function new(x: Float, y: Float) {
    super(x, y);

    loadGraphic(AssetPaths.spike__png, false, WIDTH, HEIGHT);

    // keeps it static at the top, kind of like a HUD
    // instead of `setScroll(0, 0);` since that gets ignored by collisions
    velocity.y = Camera.SCROLL_SPEED;

    immovable = true;
  }
}
