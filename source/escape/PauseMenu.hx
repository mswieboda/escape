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
#if web
      { name: "exit" }
#else
      { name: "exit", action: name -> Sys.exit(0) }
#end
    ];

    super(title, itemData);
  }
}
