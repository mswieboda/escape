package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class PauseMenu extends PlayMenu {
  public function new() {
    var title = "Paused!";
    var itemData = [
      { name: "resume", action: name -> close() },
      { name: "restart", action: name -> FlxG.switchState(new PlayState()) },
      { name: "exit", action: name -> FlxG.switchState(new MenuState()) }
    ];

    super(title, itemData);
  }
}
