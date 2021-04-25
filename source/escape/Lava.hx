package escape;

import flixel.FlxSprite;

class Lava extends Spike {
  public static inline var TILE = "~";
  public static inline var MID = Spike.LAVA_MID;
  public static inline var LEFT = Spike.LAVA_LEFT;
  public static inline var RIGHT = Spike.LAVA_RIGHT;

  static inline var HITBOX_RATIO = 0.5;

  public function new(x: Float, y: Float, section: Int = MID) {
    super(x, y, section);
  }

  override function frameSetup(section: Int) {
    switch(section) {
      case MID:
        animation.frameIndex = 2;
      case LEFT:
        animation.frameIndex = 3;
      case RIGHT:
        animation.frameIndex = 3;
        flipX = true;
      default:
        animation.frameIndex = 0;
    }
  }
}
