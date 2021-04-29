package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class LevelEditorMenu extends PlayMenu {
  public function new(level: LevelEditor, levelFileName: String) {
    var title = "Level Editor";
    var itemData = [
      { name: "resume", action: name -> close() },
      { name: "test", action: name -> test(levelFileName) },
      { name: "save", action: name -> save(level) },
      { name: "load", action: name -> close() },
      { name: "exit", action: name -> FlxG.switchState(new MenuState()) }
    ];

    super(title, itemData);
  }

  function test(levelFileName: String) {
    close();
    FlxG.switchState(new LevelState(levelFileName));
  }

  function save(level: LevelEditor) {
    level.save();
    close();
  }
}
