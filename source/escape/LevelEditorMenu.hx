package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class LevelEditorMenu extends PlayMenu {
  public function new(levelEditor: LevelEditor) {
    var title = "Level Editor";
    var itemData = [
      { name: "resume", action: name -> close() },
      { name: "test", action: name -> test(levelEditor) },
      { name: "save", action: name -> save(levelEditor) },
      { name: "load", action: name -> close() },
      { name: "exit", action: name -> FlxG.switchState(new MenuState()) }
    ];

    super(title, itemData);
  }

  function test(levelEditor: LevelEditor) {
    var player = new Player();
    var testLevel = new Level(player, levelEditor.fileName);

    close();

    FlxG.switchState(new LevelState(player, testLevel));
  }

  function save(levelEditor: LevelEditor) {
    levelEditor.save();
    close();
  }
}
