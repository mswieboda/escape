package escape;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Background extends FlxSprite {
  static inline var TILE_WIDTH = BaseLevel.TILE_WIDTH;
  static inline var TILE_HEIGHT = BaseLevel.TILE_HEIGHT;

  public function new(widthInTiles: Int, heightInTiles: Int) {
    super();

    immovable = true;
    moves = false;
    solid = false;

    var tile = new FlxSprite();
    var width = widthInTiles * TILE_WIDTH;
    var height = heightInTiles * TILE_HEIGHT;

    tile.loadGraphic(AssetPaths.background__png);
    makeGraphic(width, height, FlxColor.TRANSPARENT);

    for (col in 0...widthInTiles) {
      for (row in 0...heightInTiles) {
        stamp(tile, col * TILE_WIDTH, row * TILE_HEIGHT);
      }
    }
  }
}
