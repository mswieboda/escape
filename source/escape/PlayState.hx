package escape;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
  var player: Player;
  var level: Level;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;

  override public function create() {
    FlxG.mouse.visible = false;

    level = new Level(AssetPaths.level__txt, AssetPaths.tiles__png);
    add(level);

    player = new Player(30, 30);
    add(player);

    super.create();
  }

  override function update(elapsed: Float) {
    FlxG.collide(player, level);

    super.update(elapsed);
  }
}
