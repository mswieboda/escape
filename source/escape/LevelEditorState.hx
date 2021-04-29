package escape;

import flixel.FlxG;
import flixel.FlxState;

class LevelEditorState extends FlxState {
  var levelFileName: String;
  var level: LevelEditor;
  var player: Player;

  override public function create() {
    player = new Player();
    level = new LevelEditor(player, AssetPaths.test__dat, AssetPaths.tiles__png);

    add(level);

    super.create();

    // TODO: why are none of these working? move where they need to be
    FlxG.mouse.visible = false;
    FlxG.mouse.enabled = false;
    FlxG.mouse.useSystemCursor = false;

    Actions.addInputs();
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    if (Actions.game.menu.triggered) openSubState(new LevelEditorMenu(onSave));
  }

  function onSave() {
    level.save();
  }
}
