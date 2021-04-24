package escape;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.system.FlxAssets;

class Level extends FlxGroup {
  var tiles: FlxTilemap;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;

  public function new(levelData: String, tileGraphic: FlxTilemapGraphicAsset) {
    super();

    tiles = new FlxTilemap();
    tiles.loadMapFromCSV(
      levelData,
      tileGraphic,
      TILE_WIDTH,
      TILE_HEIGHT,
      AUTO
    );
    add(tiles);

    // TODO: find specific tiles like ladders, doors, etc
    // make objects for them (without sprites etc)
  }

  override function update(elapsed: Float) {
    super.update(elapsed);
  }
}
