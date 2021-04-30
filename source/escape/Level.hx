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
    add(behindLadderSprites);
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

  override function addDoor(row: Int, col: Int): Door {
    var door = super.addDoor(row, col);

    doorTriggers.add(door.trigger);

    return door;
  }

  override function addLadder(row: Int, col: Int, section: Int): Ladder {
    var ladder = super.addLadder(row, col, section);

    ladderTriggers.add(ladder.trigger);

    return ladder;
  }

  override function addWallJumpTriggers(row: Int, col: Int) {
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
