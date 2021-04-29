package escape;

import flixel.FlxG;
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
  public var foregrounds: FlxGroup;
  public var playerPosition: FlxPoint;

  var levelDataFilename: String;
  var tileGraphic: FlxTilemapGraphicAsset;
  var levelStrData: Array<Array<String>>;
  var tiles: FlxTilemap;
  var doors: FlxGroup;
  var ladders: FlxGroup;
  var ladderSprites: FlxGroup;
  var spikes: FlxGroup;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;

  public function new(
    player: Player,
    levelDataFilename: String,
    tileGraphic: FlxTilemapGraphicAsset
  ) {
    super();

    this.levelDataFilename = levelDataFilename;
    this.tileGraphic = tileGraphic;

    foregrounds = new FlxGroup();
    tiles = new FlxTilemap();
    doors = new FlxGroup();
    ladders = new FlxGroup();
    ladderSprites = new FlxGroup();
    spikes = new FlxGroup();

    loadTilesFromFile(levelDataFilename);
  }

  function addAll() {
    add(tiles);
    add(ladderSprites);
    add(doors);
    add(ladders);

    foregrounds.add(spikes);
  }

  public function updateCollisions(player: Player) {
    // NOTE: overridden in child classes
  }

  static function parseCSV(csv: String): Array<Array<String>> {
    var data: Array<Array<String>> = [];
    var regex: EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
    var rows: Array<String> = regex.split(csv);

    for(rowString in rows) {
      data.push(rowString.split(","));
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
    var ladderTileData: Array<LadderData> = [];

    for(row => rowStrData in levelStrData) {
      var rowData: Array<Int> = [];

      for (col => tile in rowStrData) {
        var tileData = Std.parseInt(tile);

        if (tileData == null) {
          switch(tile.toUpperCase()) {
            case Door.TILE:
              tileData = addDoor(row, col);
            case Ladder.TILE:
              tileData = addLadder(row, col, ladderTileData);
            case Spike.TILE:
              tileData = addSpike(row, col);
            case Lava.TILE:
              tileData = addLava(row, col);
            case Player.TILE:
              playerPosition = new FlxPoint(col * TILE_WIDTH, row * TILE_HEIGHT - Player.HEIGHT / 2);
              tileData = 0;
            default:
              trace('>>> [$row, $col]: ??? $tile');
              tileData = 0;
          }
        } else if (tileData == 1) {
          addWallJumpTrigger(row, col);
        }

        rowData.push(tileData);
      }

      levelData.push(rowData);
    }

    tiles.loadMapFrom2DArray(
      levelData,
      tileGraphic,
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

      ladderSprites.add(sprite);
    }

    addAll();
  }

  function reloadTiles() {
    remove(tiles);
    remove(ladderSprites);
    remove(doors);
    remove(ladders);

    foregrounds.clear();
    tiles.destroy();
    tiles = new FlxTilemap();
    doors.clear();
    ladders.clear();
    ladderSprites.clear();
    spikes.clear();

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

  function addDoor(row: Int, col: Int): Int {
    var prevRowTile = getTile(row - 1, col);
    var nextRowTile = getTile(row + 1, col);

    if (prevRowTile != Door.TILE && nextRowTile == Door.TILE) {
      var door = new Door(col * TILE_WIDTH, row * TILE_HEIGHT);

      doors.add(door);
      // doorTriggers.add(door.trigger);
    }

    return 0;
  }

  function addLadder(row: Int, col: Int, ladderTileData: Array<LadderData>): Int {
    var prevRowTile = getTile(row - 1, col);
    var nextRowTile = getTile(row + 1, col);
    var prevColTile = getTile(row, col - 1);
    var nextColTile = getTile(row, col + 1);
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

    var ladder = new Ladder(col * TILE_WIDTH, row * TILE_HEIGHT, section);

    ladders.add(ladder);
    // ladderTriggers.add(ladder.trigger);

    return tileData;
  }

  function addSpike(row: Int, col: Int): Int {
    var prevRowTile = getTile(row - 1, col);
    var nextRowTile = getTile(row + 1, col);
    var prevColTile = getTile(row, col - 1);
    var nextColTile = getTile(row, col + 1);
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

  function addLava(row: Int, col: Int): Int {
    var prevColTile = getTile(row, col - 1);
    var nextColTile = getTile(row, col + 1);
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

  function addWallJumpTrigger(row: Int, col: Int) {
    // overridden in child classes
  }

  // TODO: this is backwards, maybe switch to col, row (same with all above methods)
  function getTile(row: Int, col: Int): String {
    var safe = row >= 0 && row < levelStrData.length && col >= 0 && col < levelStrData[row].length;

    return safe ? levelStrData[row][col].toUpperCase() : '0';
  }
}

typedef LadderData = {
  col: Int,
  row: Int,
  frames: FlxImageFrame
}
