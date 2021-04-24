package escape;

import flixel.FlxG;

class Camera {
  public static inline var SCROLL_SPEED = 10;

  public static function update(elapsed: Float) {
    FlxG.camera.scroll.y += SCROLL_SPEED * elapsed;
  }
}
