package escape;

import flixel.FlxBasic;
import flixel.FlxObject;

class Trigger extends FlxObject {
  public var parent: FlxBasic;

  public function new(x: Float, y: Float, width: Float, height: Float, parent: FlxBasic = null) {
    super(x, y, width, height);

    immovable = true;
    moves = false;

    this.parent = parent;
  }
}
