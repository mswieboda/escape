package escape;

import flixel.FlxSprite;

class Spike extends FlxSprite {
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 32;

  public function new(x: Float, y: Float) {
    super(x, y);

    loadGraphic(AssetPaths.spike__png, false, WIDTH, HEIGHT);

    immovable = true;
  }
}
