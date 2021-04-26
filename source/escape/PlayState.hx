package escape;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
  var level: Level;
  var player: Player;

  override public function create() {
    player = new Player(50, 10);

    level = new Level(player, AssetPaths.level__txt, AssetPaths.tiles__png);

    add(level);
    add(player.actionMessage);

    super.create();

    // TODO: why are none of these working? move where they need to be
    FlxG.mouse.visible = false;
    FlxG.mouse.enabled = false;
    FlxG.mouse.useSystemCursor = false;

    Action.addInputs();
  }

  override function update(elapsed: Float) {
    if (!player.alive && subState == null) openSubState(new GameOverMenu());
    if (Action.menu.triggered) openSubState(new PauseMenu());

    super.update(elapsed);
  }
}
