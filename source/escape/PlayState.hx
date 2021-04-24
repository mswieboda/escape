package escape;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState {
  var player: Player;
  var tiles: FlxTilemap;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;

  override public function create() {
    FlxG.mouse.visible = false;

    tiles = new FlxTilemap();
    tiles.loadMapFromCSV(
      "assets/tiles/level.txt",
      "assets/tiles/tiles.png",
      TILE_WIDTH,
      TILE_HEIGHT,
      AUTO
    );
    add(tiles);

    player = new Player(30, 30);
    add(player);

    super.create();
  }

  override function update(elapsed: Float) {
    FlxG.collide(player, tiles);

    super.update(elapsed);
  }
}
