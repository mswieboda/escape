package escape;

import escape.MenuItems.ItemData;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxAxes;

class MenuState extends FlxState {
  static inline var PADDING = 32;
  static inline var TITLE_SIZE = 64;
  static inline var TITLE_COLOR = 0xFFCC0000;
  static inline var TITLE_BORDER_SIZE = 8;
  static inline var TITLE_BORDER_COLOR = 0xFF660000;

  override public function create() {
    var title = new FlxText(0, PADDING, 0, "escape", TITLE_SIZE);

    title.color = TITLE_COLOR;
    title.borderSize = TITLE_BORDER_SIZE;
    title.borderStyle = FlxTextBorderStyle.SHADOW;
    title.borderColor = TITLE_BORDER_COLOR;
    title.screenCenter(FlxAxes.X);

    var menuItems = new MenuItems(title.y + title.height + PADDING, [
      "start" => { action: name -> FlxG.switchState(new PlayState()) },
#if web
      "exit" => {}
#else
      "exit" => { action: name -> Sys.exit(0) }
#end
    ]);

    add(title);
    add(menuItems);

    super.create();

    Action.addInputs();
  }
}
