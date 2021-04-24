package escape;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class ActionMessage extends FlxGroup {
  static inline var FONT_SIZE = 16;

  var text: FlxText;

  public function new() {
    super();

    visible = false;

    text = new FlxText();
    text.size = FONT_SIZE;

    // so it's static like a HUD at the top of the camera
    text.scrollFactor.set(0, 0);
    text.y = FlxG.height - text.height;

    add(text);
  }

  public function show(text: String) {
    this.text.text = text;
    visible = true;
  }

  public function hide() {
    text.text = "";
    visible = false;
  }
}
