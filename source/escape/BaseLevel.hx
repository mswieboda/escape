package escape;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxImageFrame;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDestroyUtil;
import flixel.system.FlxAssets;
import openfl.Assets;

class BaseLevel extends FlxGroup {
  public static inline var TILE_WIDTH = 32;
  public static inline var TILE_HEIGHT = 32;
  public static inline var LAYERS = 2;

  public var fileName: String;
  public var playerPosition: FlxPoint;
  public var widthInTiles(get, never): Int;
  public var heightInTiles(get, never): Int;

  var tileGraphic: FlxTilemapGraphicAsset;
  var foregroundTileGraphic: FlxTilemapGraphicAsset;
  var levelStrData: Array<Array<Array<String>>>;
  var tiles: FlxTilemap;
  var foregroundTiles: FlxTilemap;
  var behindLadderSprites: FlxGroup;
  var doors: FlxGroup;
  var ladders: FlxGroup;
  var spikes: FlxGroup;

  public var foregrounds: FlxGroup;

  public function new(
    player: Player,
    fileName: String,
    tileGraphic: FlxTilemapGraphicAsset = AssetPaths.tiles__png,
    foregroundTileGraphic: FlxTilemapGraphicAsset = AssetPaths.foreground_tiles__png
  ) {
    super();

    this.fileName = fileName;
    this.tileGraphic = tileGraphic;
    this.foregroundTileGraphic = foregroundTileGraphic;
    this.playerPosition = new FlxPoint();

    initTiles();

    behindLadderSprites = new FlxGroup();
    doors = new FlxGroup();
    ladders = new FlxGroup();
    spikes = new FlxGroup();
    foregrounds = new FlxGroup();

    loadTilesFromFile(fileName);
  }

  function initTiles() {
    tiles = new FlxTilemap();
    tiles.useScaleHack = false;

    foregroundTiles = new FlxTilemap();
    foregroundTiles.useScaleHack = false;
    foregroundTiles.alpha = 0.39;
  }

  function addAll() {
    add(tiles);
    add(behindLadderSprites);
    add(doors);
    add(ladders);

    foregrounds.add(foregroundTiles);
    foregrounds.add(spikes);
  }

  function get_widthInTiles(): Int return tiles.widthInTiles;
  function get_heightInTiles(): Int return tiles.heightInTiles;

  public function updateCollisions(player: Player) {
    // NOTE: overridden in child classes
  }

  static function parseCSV(csv: String): Array<Array<Array<String>>> {
    var data: Array<Array<Array<String>>> = [];
    var regex: EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
    var rows: Array<String> = regex.split(csv);

    for(rowString in rows) {
      var rowData: Array<Array<String>> = [];

      for (cellString in rowString.split(",")) {
        rowData.push(cellString.split("|"));
      }

      data.push(rowData);
    }

    return data;
  }

  function loadTilesFromFile(csv: String) {
    if (Assets.exists(csv)) {
      csv = Assets.getText(csv);
    }

    levelStrData = parseCSV(csv);

    loadTiles();
  }

  function loadTiles() {
    var levelData: Array<Array<Int>> = [];
    var foregroundData: Array<Array<Int>> = [];
    var ladderTileData: Array<LadderData> = [];

    for(row => rowStrData in levelStrData) {
      var rowData: Array<Int> = [];
      var rowForegroundData: Array<Int> = [];

      for (col => layers in rowStrData) {
        var noForegroundAdded = true;

        for (layer => tile in layers) {
          var tileData = Std.parseInt(tile);

          if (layer == 0) {
            if (tileData == null) {
              switch(tile.toUpperCase()) {
                case Door.TILE:
                  tileData = tileForDoor(col, row);
                case Ladder.TILE:
                  tileData = tileForLadder(col, row, ladderTileData);
                case Spike.TILE:
                  tileData = tileForSpike(col, row);
                case Lava.TILE:
                  tileData = tileForLava(col, row);
                case Player.TILE:
                  tileData = tileForPlayer(col, row);
                default:
                  trace('>>> ($col, $row): ??? $tile');
                  tileData = 0;
              }
            }

            rowData.push(tileData);
          } else if (layer == 1) {
            rowForegroundData.push(tileData);
            noForegroundAdded = false;
          }

          addTileTriggers(layer, col, row, tile);
        }

        if (noForegroundAdded) {
          rowForegroundData.push(0);
        }
      }

      levelData.push(rowData);
      foregroundData.push(rowForegroundData);
    }

    tiles.loadMapFrom2DArray(
      levelData,
      tileGraphic,
      TILE_WIDTH,
      TILE_HEIGHT,
      AUTO
    );

    foregroundTiles.loadMapFrom2DArray(
      foregroundData,
      foregroundTileGraphic,
      TILE_WIDTH,
      TILE_HEIGHT,
      AUTO
    );

    // set world bounds from tiles
    FlxG.worldBounds.set(
      -TILE_WIDTH,
      -TILE_HEIGHT,
      tiles.width + TILE_WIDTH,
      tiles.height + TILE_HEIGHT
    );

    // swap tiles with ladders on them to sprites (to get no collision)
    // then add the sprite to this FlxGroup (after all tiles)
    for (data in ladderTileData) {
      var tile = tiles.getTile(data.col, data.row);

      data.frames = FlxImageFrame.fromGraphic(tiles.graphic, new FlxRect((tile - 1) * TILE_WIDTH, 0, TILE_WIDTH, TILE_HEIGHT));
    }

    for (data in ladderTileData) {
      var sprite = tiles.tileToSprite(data.col, data.row, 0, tp -> tileToSprite(tp, data.frames));

      sprite.immovable = true;
      sprite.moves = false;
      sprite.solid = false;

      behindLadderSprites.add(sprite);
    }

    addAll();
  }

  function reloadTiles() {
    remove(tiles);
    remove(behindLadderSprites);
    remove(doors);
    remove(ladders);

    tiles.destroy();
    foregroundTiles.destroy();

    initTiles();

    doors.clear();
    ladders.clear();
    behindLadderSprites.clear();
    spikes.clear();
    foregrounds.clear();

    loadTiles();
  }

  static function tileToSprite(tileProperties: FlxTileProperties, frames: FlxImageFrame): FlxSprite {
    var tileSprite = new FlxSprite(tileProperties.x, tileProperties.y);

    tileSprite.frames = frames;
    tileSprite.scale.copyFrom(tileProperties.scale);
    tileProperties.scale = FlxDestroyUtil.put(tileProperties.scale);
    tileSprite.alpha = tileProperties.alpha;
    tileSprite.blend = tileProperties.blend;

    return tileSprite;
  }

  function tileForDoor(col: Int, row: Int): Int {
    var prevRowTile = getTile(col, row - 1);
    var nextRowTile = getTile(col, row + 1);

    if (prevRowTile != Door.TILE && nextRowTile == Door.TILE) {
      addDoor(col, row);
    }

    return 0;
  }

  function addDoor(col: Int, row: Int): Door {
    var door = new Door(col * TILE_WIDTH, row * TILE_HEIGHT);

    doors.add(door);

    return door;
  }

  function tileForLadder(col: Int, row: Int, ladderTileData: Array<LadderData>): Int {
    var prevRowTile = getTile(col, row - 1);
    var nextRowTile = getTile(col, row + 1);
    var prevColTile = getTile(col - 1, row);
    var nextColTile = getTile(col + 1, row);
    var tileData = 0;

    if (prevColTile != "0" || nextColTile != "0") {
      tileData = 1;
      ladderTileData.push({col: col, row: row, frames: null});
    }

    var section = Ladder.MIDDLE;

    if (prevRowTile != Ladder.TILE) {
      section = Ladder.TOP;
    } else if (nextRowTile != Ladder.TILE) {
      section = Ladder.BOTTOM;
    }

    addLadder(col, row, section);

    return tileData;
  }

  function addLadder(col: Int, row: Int, section: Int): Ladder {
    var ladder = new Ladder(col * TILE_WIDTH, row * TILE_HEIGHT, section);

    ladders.add(ladder);

    return ladder;
  }

  function tileForSpike(col: Int, row: Int): Int {
    var prevRowTile = getTile(col, row - 1);
    var nextRowTile = getTile(col, row + 1);
    var prevColTile = getTile(col - 1, row);
    var nextColTile = getTile(col + 1, row);
    var section = Spike.FLOOR;

    if (prevColTile == '1') {
      // 1s?
      section = Spike.RIGHT;
    } else if (nextColTile == '1') {
      // ?s1 (? is not 1)
      section = Spike.LEFT;
    } else if (prevRowTile == '0' && nextRowTile == '1') {
      // ?0?
      // 0s0
      // ?1?
      section = Spike.FLOOR;
    } else if (prevRowTile == '1') {
      // ?1?
      // 0s0
      // ?@? (@ is ? but not 1)
      section = Spike.TOP;
    }

    var spike = new Spike(col * TILE_WIDTH, row * TILE_HEIGHT, section);

    spikes.add(spike);

    return 0;
  }

  function tileForLava(col: Int, row: Int): Int {
    var prevColTile = getTile(col - 1, row);
    var nextColTile = getTile(col + 1, row);
    var section = Lava.MID;

    if (prevColTile != Lava.TILE) {
      section = Lava.LEFT;
    } else if (nextColTile != Lava.TILE) {
      section = Lava.RIGHT;
    }

    var spike = new Lava(col * TILE_WIDTH, row * TILE_HEIGHT, section);

    spikes.add(spike);

    return 0;
  }

  function tileForPlayer(col: Int, row: Int): Int {
    playerPosition.set(col * TILE_WIDTH, row * TILE_HEIGHT - Player.HEIGHT / 2);

    return 0;
  }

  function addTileTriggers(layer: Int, col: Int, row: Int, tile: String) {
    // overridden in child classes
  }

  function getTile(col: Int, row: Int, layer: Int = 0): String {
    var safe = row >= 0
      && row < levelStrData.length
      && col >= 0
      && col < levelStrData[row].length
      && layer >= 0
      && layer < levelStrData[row][col].length;

    return safe ? levelStrData[row][col][layer].toUpperCase() : '0';
  }
}

typedef LadderData = {
  col: Int,
  row: Int,
  frames: FlxImageFrame
}
