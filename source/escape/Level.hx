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
    fileName: String,
    tileGraphic: FlxTilemapGraphicAsset = AssetPaths.tiles__png
  ) {
    colliders = new FlxGroup();
    doorTriggers = new FlxGroup();
    ladderTriggers = new FlxGroup();
    leftWallJumpTriggers = new FlxGroup();
    rightWallJumpTriggers = new FlxGroup();

    super(player, fileName, tileGraphic);

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

    foregrounds.add(spikes);
  }

  public override function updateCollisions(player: Player) {
    FlxG.collide(colliders, player);
    FlxG.collide(spikes, player, Player.onHitSpikes);
    FlxG.overlap(doorTriggers, player, Player.onDoorTrigger, Door.onDoorTrigger);
    FlxG.overlap(ladderTriggers, player, Player.onLadderTrigger);
    FlxG.overlap(leftWallJumpTriggers, player.feetTrigger, player.onLeftWallJumpTrigger);
    FlxG.overlap(rightWallJumpTriggers, player.feetTrigger, player.onRightWallJumpTrigger);
  }

  override function addDoor(row: Int, col: Int): Int {
    var prevRowTile = getTile(row - 1, col);
    var nextRowTile = getTile(row + 1, col);

    if (prevRowTile != Door.TILE && nextRowTile == Door.TILE) {
      var door = new Door(col * TILE_WIDTH, row * TILE_HEIGHT);

      doors.add(door);
      doorTriggers.add(door.trigger);
    }

    return 0;
  }

  override function addLadder(row: Int, col: Int, ladderTileData: Array<BaseLevel.LadderData>): Int {
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
    ladderTriggers.add(ladder.trigger);

    return tileData;
  }

  override function addWallJumpTrigger(row: Int, col: Int) {
    var prevColTile = getTile(row, col - 1);
    var nextColTile = getTile(row, col + 1);

    if (prevColTile == '0') {
      if (getTile(row, col - 2) == '1') return;

      var prevCorners = [getTile(row - 1, col - 1), getTile(row + 1, col - 1)];

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
      if (getTile(row, col + 2) == '1') return;

      var nextCorners = [getTile(row - 1, col + 1), getTile(row + 1, col + 1)];

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
}
