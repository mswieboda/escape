package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class GameOverMenu extends PlayMenu {
  public function new() {
    var title = "Game Over!";
    var parentPersistentUpdate = true;
    var itemData = [
      { name: "restart", action: name -> FlxG.switchState(new PlayState()) },
      { name: "exit", action: name -> FlxG.switchState(new MenuState()) }
    ];

    super(title, itemData, parentPersistentUpdate);
  }
}
