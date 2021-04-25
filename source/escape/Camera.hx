package escape;

import flixel.FlxG;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxObject;

class Camera {
  public static function setup(followTarget: FlxObject) {
    FlxG.camera.follow(followTarget, FlxCameraFollowStyle.PLATFORMER);
    FlxG.camera.setScrollBounds(0, null, 0, null);
  }

  public static function update(elapsed: Float, minY: Float) {
    FlxG.camera.setScrollBounds(0, null, minY, null);
  }
}
