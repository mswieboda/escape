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

class Level extends FlxGroup {
  var player: Player;
  var tiles: FlxTilemap;
  var colliders: FlxGroup;
  var doors: FlxGroup;
  var doorTriggers: FlxGroup;
  var ladders: FlxGroup;
  var ladderTriggers: FlxGroup;
  var leftWallJumpTriggers: FlxGroup;
  var rightWallJumpTriggers: FlxGroup;
  var spikes: FlxGroup;
  var topSpikes: TopSpikes;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;
  static inline var WALL_TRIGGER_WIDTH = 16;

  public function new(
    player: Player,
    levelData: String,
    tileGraphic: FlxTilemapGraphicAsset
  ) {
    super();

    this.player = player;

    Camera.setup(player);

    tiles = new FlxTilemap();
    colliders = new FlxGroup();
    doors = new FlxGroup();
    doorTriggers = new FlxGroup();
    ladders = new FlxGroup();
    ladderTriggers = new FlxGroup();
    leftWallJumpTriggers = new FlxGroup();
    rightWallJumpTriggers = new FlxGroup();
    spikes = new FlxGroup();
    topSpikes = new TopSpikes();

    loadTiles(levelData, tileGraphic);

    spikes.add(topSpikes);

    colliders.add(tiles);
    colliders.add(doors);
    colliders.add(ladders);

    add(doors);
    add(doorTriggers);
    add(ladders);
    add(ladderTriggers);
    add(leftWallJumpTriggers);
    add(rightWallJumpTriggers);
    add(player);
    add(player.feetTrigger);
    add(spikes);
  }

  override function update(elapsed: Float) {
    Camera.update(elapsed, topSpikes.cameraMinY());

    super.update(elapsed);

    player.updateBeforeCollisionChecks(elapsed);

    FlxG.collide(colliders, player);
    FlxG.collide(spikes, player, Player.onHitSpikes);
    FlxG.overlap(doorTriggers, player, Player.onDoorTrigger, Door.onDoorTrigger);
    FlxG.overlap(ladderTriggers, player, Player.onLadderTrigger);
    FlxG.overlap(leftWallJumpTriggers, player.feetTrigger, player.onLeftWallJumpTrigger);
    FlxG.overlap(rightWallJumpTriggers, player.feetTrigger, player.onRightWallJumpTrigger);
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

  function loadTiles(csv: String, tileGraphic: FlxTilemapGraphicAsset) {
    var levelData: Array<Array<Int>> = [];
    var ladderTileData: Array<LadderData> = [];

    if (Assets.exists(csv)) {
      csv = Assets.getText(csv);
    }

    var levelStrData = parseCSV(csv);

    for(row => rowStrData in levelStrData) {
      var rowData: Array<Int> = [];

      for (col => tile in rowStrData) {
        var tileData = Std.parseInt(tile);

        if (tileData == null) {
          switch(tile.toUpperCase()) {
            case Door.TILE:
              tileData = addDoor(row, col, levelStrData);
            case Ladder.TILE:
              tileData = addLadder(row, col, levelStrData, ladderTileData);
            case Spike.TILE:
              tileData = addSpike(row, col, levelStrData);
            case Lava.TILE:
              tileData = addLava(row, col, levelStrData);
            case Player.TILE:
              player.setPosition(col * TILE_WIDTH, row * TILE_HEIGHT - Player.HEIGHT / 2);
              tileData = 0;
            default:
              trace('>>> [$row, $col]: ??? $tile');
              tileData = 0;
          }
        } else if (tileData == 1) {
          addWallJumpTrigger(row, col, levelStrData);
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

    add(tiles);

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

      add(sprite);
    }
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

  function addDoor(row: Int, col: Int, levelStrData: Array<Array<String>>): Int {
    var prevRowTile = getTile(levelStrData, row - 1, col);
    var nextRowTile = getTile(levelStrData, row + 1, col);

    if (prevRowTile != Door.TILE && nextRowTile == Door.TILE) {
      var door = new Door(col * TILE_WIDTH, row * TILE_HEIGHT);

      doors.add(door);
      doorTriggers.add(door.trigger);
    }

    return 0;
  }

  function addLadder(row: Int, col: Int, levelStrData: Array<Array<String>>, ladderTileData: Array<LadderData>): Int {
    var prevRowTile = getTile(levelStrData, row - 1, col);
    var nextRowTile = getTile(levelStrData, row + 1, col);
    var prevColTile = getTile(levelStrData, row, col - 1);
    var nextColTile = getTile(levelStrData, row, col + 1);
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
    ladderTriggers.add(ladder.trigger);

    return tileData;
  }

  function addSpike(row: Int, col: Int, levelStrData: Array<Array<String>>): Int {
    var prevRowTile = getTile(levelStrData, row - 1, col);
    var nextRowTile = getTile(levelStrData, row + 1, col);
    var prevColTile = getTile(levelStrData, row, col - 1);
    var nextColTile = getTile(levelStrData, row, col + 1);
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

  function addLava(row: Int, col: Int, levelStrData: Array<Array<String>>): Int {
    var prevColTile = getTile(levelStrData, row, col - 1);
    var nextColTile = getTile(levelStrData, row, col + 1);
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

  function addWallJumpTrigger(row: Int, col: Int, levelStrData: Array<Array<String>>) {
    var prevColTile = getTile(levelStrData, row, col - 1);
    var nextColTile = getTile(levelStrData, row, col + 1);

    if (prevColTile == '0') {
      if (getTile(levelStrData, row, col - 2) == '1') return;

      var prevCorners = [getTile(levelStrData, row - 1, col - 1), getTile(levelStrData, row + 1, col - 1)];

      if (prevCorners.contains('1')) return;

      var trigger = new Trigger(
        col * TILE_WIDTH - WALL_TRIGGER_WIDTH / 2,
        row * TILE_HEIGHT,
        WALL_TRIGGER_WIDTH,
        TILE_HEIGHT
      );

      rightWallJumpTriggers.add(trigger);
    }

    if (nextColTile == '0') {
      if (getTile(levelStrData, row, col + 2) == '1') return;

      var nextCorners = [getTile(levelStrData, row - 1, col + 1), getTile(levelStrData, row + 1, col + 1)];

      if (nextCorners.contains('1')) return;

      var trigger = new Trigger(
        col * TILE_WIDTH + TILE_WIDTH - WALL_TRIGGER_WIDTH / 2,
        row * TILE_HEIGHT,
        WALL_TRIGGER_WIDTH,
        TILE_HEIGHT
      );

      leftWallJumpTriggers.add(trigger);
    }
  }

  static function getTile(levelStrData: Array<Array<String>>, row: Int, col: Int): String {
    var safe = row >= 0 && row < levelStrData.length && col >= 0 && col < levelStrData[row].length;

    return safe ? levelStrData[row][col].toUpperCase() : '0';
  }
}

typedef LadderData = {
  col: Int,
  row: Int,
  frames: FlxImageFrame
}
