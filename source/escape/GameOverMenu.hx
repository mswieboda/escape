package escape;

import flixel.group.FlxGroup;
import flixel.text.FlxText;

class GameOverMenu extends FlxGroup {
  static inline var FONT_SIZE = 32;

  var text: FlxText;

  public function new() {
    super();

    visible = false;

    text = new FlxText();
    text.size = FONT_SIZE;

    // so it's static like a HUD at the top of the camera
    text.scrollFactor.set(0, 0);
    text.screenCenter();

    add(text);
  }

  public function show() {
    text.text = "Game Over!";
    text.screenCenter();
    visible = true;
  }
}
