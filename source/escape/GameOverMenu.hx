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
#if web
      { name: "exit" }
#else
      { name: "exit", action: name -> Sys.exit(0) }
#end
    ];

    super(title, itemData, parentPersistentUpdate);
  }
}
