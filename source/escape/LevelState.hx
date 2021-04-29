package escape;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxAssets;

class LevelState extends FlxState {
  var levelFile: String;
  var tileGraphic: FlxTilemapGraphicAsset;
  var level: Level;
  var player: Player;

  public function new(levelFile: String, tileGraphic: FlxTilemapGraphicAsset) {
    super();

    this.levelFile = levelFile;
    this.tileGraphic = tileGraphic;
  }

  override public function create() {
    player = new Player();
    level = new Level(player, levelFile, tileGraphic);

    add(level);
    add(player.actionMessage);

    super.create();

    // TODO: why are none of these working? move where they need to be
    FlxG.mouse.visible = false;
    FlxG.mouse.enabled = false;
    FlxG.mouse.useSystemCursor = false;

    Actions.addInputs();
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    if (!player.alive && subState == null) openSubState(new GameOverMenu());
    if (Actions.game.menu.triggered) openSubState(new PauseMenu());
  }
}
