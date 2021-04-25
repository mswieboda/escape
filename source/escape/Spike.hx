package escape;

import flixel.FlxSprite;

class Spike extends FlxSprite {
  public static inline var WIDTH = 32;
  public static inline var HEIGHT = 32;
  public static inline var TILE = "S";

  public static inline var FLOOR = 0;
  public static inline var TOP = 1;
  public static inline var LEFT = 2;
  public static inline var RIGHT = 3;
  public static inline var LAVA_MID = 4;
  public static inline var LAVA_LEFT = 5;
  public static inline var LAVA_RIGHT = 6;

  static inline var HITBOX_RATIO = 0.5;

  public function new(x: Float, y: Float, section: Int = FLOOR) {
    super(x, y);

    loadGraphic(AssetPaths.spike__png, true, WIDTH, HEIGHT);

    frameSetup(section);

    immovable = true;

    width *= HITBOX_RATIO;
    height *= HITBOX_RATIO;

    centerOffsets(true);
  }

  function frameSetup(section: Int) {
    switch(section) {
      case FLOOR:
        animation.frameIndex = 0;
      case TOP:
        animation.frameIndex = 0;
        flipY = true;
      case LEFT:
        animation.frameIndex = 1;
      case RIGHT:
        animation.frameIndex = 1;
        flipX = true;
      default:
        animation.frameIndex = 0;
    }
  }
}
