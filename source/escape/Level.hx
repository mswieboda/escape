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

class Level extends BaseLevel {
  var colliders: FlxGroup;
  var doorTriggers: FlxGroup;
  var ladderTriggers: FlxGroup;
  var leftWallJumpTriggers: FlxGroup;
  var rightWallJumpTriggers: FlxGroup;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;
  static inline var WALL_TRIGGER_WIDTH = 16;

  public function new(
    player: Player,
    levelData: String,
    tileGraphic: FlxTilemapGraphicAsset
  ) {
    colliders = new FlxGroup();
    doorTriggers = new FlxGroup();
    ladderTriggers = new FlxGroup();
    leftWallJumpTriggers = new FlxGroup();
    rightWallJumpTriggers = new FlxGroup();

    super(player, levelData, tileGraphic);

    colliders.add(tiles);
    colliders.add(doors);
    colliders.add(ladders);
  }

  override function addAll() {
    add(tiles);
    add(doors);
    add(ladders);
    add(doorTriggers);
    add(ladderTriggers);
    add(leftWallJumpTriggers);
    add(rightWallJumpTriggers);
  }

  public override function updateCollisions(player: Player) {
    FlxG.collide(colliders, player);
    FlxG.collide(spikes, player, Player.onHitSpikes);
    FlxG.overlap(doorTriggers, player, Player.onDoorTrigger, Door.onDoorTrigger);
    FlxG.overlap(ladderTriggers, player, Player.onLadderTrigger);
    FlxG.overlap(leftWallJumpTriggers, player.feetTrigger, player.onLeftWallJumpTrigger);
    FlxG.overlap(rightWallJumpTriggers, player.feetTrigger, player.onRightWallJumpTrigger);
  }

  override function addDoor(row: Int, col: Int, levelStrData: Array<Array<String>>): Int {
    var prevRowTile = getTile(levelStrData, row - 1, col);
    var nextRowTile = getTile(levelStrData, row + 1, col);

    if (prevRowTile != Door.TILE && nextRowTile == Door.TILE) {
      var door = new Door(col * TILE_WIDTH, row * TILE_HEIGHT);

      doors.add(door);
      doorTriggers.add(door.trigger);
    }

    return 0;
  }

  override function addLadder(row: Int, col: Int, levelStrData: Array<Array<String>>, ladderTileData: Array<BaseLevel.LadderData>): Int {
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

  override function addSpike(row: Int, col: Int, levelStrData: Array<Array<String>>): Int {
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

  override function addLava(row: Int, col: Int, levelStrData: Array<Array<String>>): Int {
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

  override function addWallJumpTrigger(row: Int, col: Int, levelStrData: Array<Array<String>>) {
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
    return BaseLevel.getTile(levelStrData, row, col);
  }
}
