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
      { name: "start", action: name -> FlxG.switchState(new PlayState(AssetPaths.level__dat)) },
      { name: "playground", action: name -> FlxG.switchState(new LevelState(AssetPaths.playground__dat)) },
      { name: "settings", action: name -> FlxG.switchState(new MenuState()) },
      { name: "level editor", action: name -> FlxG.switchState(new LevelEditorState()) },
      { name: "credits", action: name -> FlxG.switchState(new MenuState()) },
#if (!web)
      { name: "exit", action: name -> Sys.exit(0) }
#end
    ]);

    add(title);
    add(menuItems);

    super.create();

    Actions.addInputs();
  }
}
