package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class LevelEditorMenu extends PlayMenu {
  public function new(onSave: () -> Void) {
    var title = "Level Editor";
    var itemData = [
      { name: "resume", action: name -> close() },
      { name: "save", action: name -> onSave() },
      { name: "load", action: name -> close() },
      { name: "exit", action: name -> FlxG.switchState(new MenuState()) }
    ];

    super(title, itemData);
  }
}
