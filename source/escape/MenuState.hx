package escape;

import flixel.FlxG;
import flixel.FlxState;

class MenuState extends FlxState {
  override public function create() {
    var text = new flixel.text.FlxText(0, 0, 0, "start", 32);

    text.screenCenter();

    add(text);

    super.create();
  }

  override function update(elapsed: Float) {
    super.update(elapsed);
  }
}
