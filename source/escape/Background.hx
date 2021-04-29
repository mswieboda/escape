package escape;

import flixel.FlxSprite;

class Background extends FlxSprite {
  public function new(width: Float, height: Float) {
    super();

    makeGraphic(Std.int(width), Std.int(height), 0x1100FF00);

    immovable = true;
    moves = false;
  }
}
