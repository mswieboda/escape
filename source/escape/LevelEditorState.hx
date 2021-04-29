package escape;

import flixel.FlxG;

class LevelEditorState extends LevelState {
  var levelEditor: LevelEditor;

  public function new(levelFileName = AssetPaths.test__dat) {
    var player = new EditorPlayer();
    levelEditor = new LevelEditor(player, levelFileName);

    super(player, levelEditor);
  }

  override function addLevel() {
    var background = new Background(level.width, level.height);

    add(background);
    add(level);
    add(player);
    add(level.foregrounds);

    player.setPosition(level.playerPosition.x, level.playerPosition.y);
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    if (Actions.game.menu.triggered) openSubState(new LevelEditorMenu(levelEditor));
  }
}
