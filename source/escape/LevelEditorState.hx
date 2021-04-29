package escape;

import flixel.FlxG;
import flixel.FlxState;

class LevelEditorState extends FlxState {
  var levelFileName: String;
  var level: LevelEditor;
  var player: Player;

  public function new(levelFileName = AssetPaths.test__dat) {
    super();

    player = new EditorPlayer();
    level = new LevelEditor(player, levelFileName, AssetPaths.tiles__png);
    this.levelFileName = levelFileName;
  }

  override public function create() {
    super.create();

    add(level);
    add(player);
    add(level.foregrounds);

    player.setPosition(level.playerPosition.x, level.playerPosition.y);

    // TODO: why are none of these working? move where they need to be
    FlxG.mouse.visible = false;
    FlxG.mouse.enabled = false;
    FlxG.mouse.useSystemCursor = false;

    Actions.addInputs();
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    if (Actions.game.menu.triggered) openSubState(new LevelEditorMenu(level, levelFileName));
  }
}
