package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class GameOverMenu extends PlayMenu {
  public function new(levelState: BaseLevelState) {
    var title = "Game Over!";
    var parentPersistentUpdate = true;
    var itemData = [
      { name: "restart", action: name -> levelState.restart() },
      { name: "exit", action: name -> FlxG.switchState(new MenuState()) }
    ];

    super(title, itemData, parentPersistentUpdate);
  }
}
