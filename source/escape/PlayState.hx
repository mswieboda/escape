package escape;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
  var level: Level;
  var spikes: Spikes;
  var player: Player;
  var gameOverMenu: GameOverMenu;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;

  override public function create() {
    FlxG.mouse.visible = false;

    level = new Level(AssetPaths.level__txt, AssetPaths.tiles__png);
    add(level);

    player = new Player(30, 30);
    add(player);

    spikes = new Spikes();
    add(spikes);

    gameOverMenu = new GameOverMenu();
    add(gameOverMenu);

    super.create();
  }

  override function update(elapsed: Float) {
    FlxG.collide(player, level);
    FlxG.collide(player, spikes, player.onHitSpikes);

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
