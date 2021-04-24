package escape;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Spike extends FlxSprite {
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 32;

  public function new(x: Float, y: Float) {
    super(x, y);

    makeGraphic(WIDTH, HEIGHT, FlxColor.GRAY);

    immovable = true;
  }

  override function update(elapsed: Float) {
    // keeps it static at the top, kind of like a HUD
    // instead of `setScroll(0, 0);` since that gets ignored by collisions
    y += Camera.SCROLL_SPEED * elapsed;

    super.update(elapsed);
  }
}
