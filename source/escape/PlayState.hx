package escape;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
  override public function create() {
    FlxG.mouse.visible = false;

    super.create();
  }

  override function update(elapsed: Float) {
    super.update(elapsed);
  }
}
