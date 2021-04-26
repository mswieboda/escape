package escape;

import escape.MenuItems.ItemData;
import flixel.FlxG;
import flixel.FlxState;

class MenuState extends FlxState {
  override public function create() {
    var menuItems = new MenuItems(10, [
      "start" => { action: name -> FlxG.switchState(new PlayState()) },
      "exit" => { action: name -> Sys.exit(0) }
    ]);

    add(menuItems);

    super.create();
  }
}
