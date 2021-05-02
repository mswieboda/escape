package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class LevelEditorMenu extends PlayMenu {
  public function new(levelEditor: LevelEditor, load: () -> Void) {
    var title = "Level Editor";
    var itemData = [
      { name: "edit", action: name -> edit() },
      { name: "test", action: name -> test(levelEditor) },
      { name: "save", action: name -> save(levelEditor) },
      { name: "load", action: name -> this.load(load) },
      { name: "exit", action: name -> FlxG.switchState(new MenuState()) }
    ];

    super(title, itemData);
  }

  function edit() {
    if (firstFrame) return;

    close();
  }

  function test(levelEditor: LevelEditor) {
    close();

    FlxG.switchState(new LevelState(levelEditor.fileName));
  }

  function save(levelEditor: LevelEditor) {
    levelEditor.save();
    close();
  }

  function load(load: () -> Void) {
    load();
    close();
  }
}
