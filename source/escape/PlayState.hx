package escape;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
  var level: Level;
  var player: Player;
  var gameOverMenu: GameOverMenu;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;

  override public function create() {
    FlxG.mouse.visible = false;
    FlxG.debugger.visible = true;
    FlxG.debugger.drawDebug = true;

    player = new Player(30, 30);

    level = new Level(player, AssetPaths.level__txt, AssetPaths.tiles__png);

    add(level);

    gameOverMenu = new GameOverMenu();
    add(gameOverMenu);

    super.create();
  }

  override function update(elapsed: Float) {
    Camera.update(elapsed);

    gameOverCheck();

    super.update(elapsed);
  }

  function gameOverCheck() {
    if (!player.alive && !gameOverMenu.visible) {
      gameOverMenu.show();
    }
  }
}
