package escape;

import flixel.FlxObject;

class Trigger extends FlxObject {
  public function new(x: Float, y: Float, width: Float, height: Float) {
    super(x, y, width, height);

    immovable = true;
    solid = false;
    moves = false;
  }
}
