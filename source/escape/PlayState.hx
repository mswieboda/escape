package escape;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
  var level: Level;
  var player: Player;
  var gameOverMenu: GameOverMenu;

  override public function create() {
    player = new Player(50, 10);
    gameOverMenu = new GameOverMenu();

    level = new Level(player, AssetPaths.level__txt, AssetPaths.tiles__png);

    add(level);
    add(player.actionMessage);
    add(gameOverMenu);

    super.create();
  }

  override function update(elapsed: Float) {
    gameOverCheck();

    super.update(elapsed);
  }

  function gameOverCheck() {
    if (!player.alive && !gameOverMenu.visible) {
      gameOverMenu.show();
    }
  }
}
