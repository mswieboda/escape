package escape;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class GameOverMenu extends FlxGroup {
  static inline var FONT_SIZE = 32;
  static inline var PADDING = 16;

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

    var menuItems = new MenuItems(text.y + text.height + PADDING, [
      { name: "restart", action: name -> FlxG.switchState(new PlayState()) },
#if web
      { name: "exit" }
#else
      { name: "exit", action: name -> Sys.exit(0) }
#end
    ]);

    add(menuItems);
  }

  public function show() {
    text.text = "Game Over!";
    text.screenCenter();
    visible = true;
  }
}
