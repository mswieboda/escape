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
  var spikes: Spikes;

  static inline var TILE_WIDTH = 32;
  static inline var TILE_HEIGHT = 32;

  public function new(
    player: Player,
    levelData: String,
    tileGraphic: FlxTilemapGraphicAsset
  ) {
    super();

    this.player = player;

    tiles = new FlxTilemap();
    colliders = new FlxGroup();
    doors = new FlxGroup();
    doorTriggers = new FlxGroup();
    ladders = new FlxGroup();
    ladderTriggers = new FlxGroup();
    spikes = new Spikes();

    loadTiles(levelData, tileGraphic);

    colliders.add(tiles);
    colliders.add(doors);
    colliders.add(ladders);

    add(doors);
    add(doorTriggers);
    add(ladders);
    add(ladderTriggers);
    add(player);
    add(spikes);
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    player.updateBeforeCollisionChecks(elapsed);

    FlxG.collide(player, colliders);
    FlxG.collide(player, spikes, Player.onHitSpikes);
    FlxG.overlap(player, doorTriggers, Player.onDoorTrigger, Door.onDoorTrigger);
    FlxG.overlap(player, ladderTriggers, Player.onLadderTrigger);
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
              var prevRowTile = levelStrData[row - 1][col];
              var nextRowTile = levelStrData[row + 1][col];

              tileData = 0;

              if (prevRowTile != Door.TILE) {
                if (nextRowTile == Door.TILE) {
                  var door = new Door(col * TILE_WIDTH, row * TILE_HEIGHT);

                  doors.add(door);
                  doorTriggers.add(door.trigger);
                }
              }
            case Ladder.TILE:
              var prevRowTile = levelStrData[row - 1][col];
              var nextRowTile = levelStrData[row + 1][col];
              var prevColTile = levelStrData[row][col - 1];
              var nextColTile = levelStrData[row][col + 1];

              tileData = 0;

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
            default:
              trace('>>> [$row, $col]: ??? $tile');
              tileData = 0;
          }
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

  function tileToSprite(tileProperties: FlxTileProperties, frames: FlxImageFrame): FlxSprite {
    var tileSprite = new FlxSprite(tileProperties.x, tileProperties.y);

    tileSprite.frames = frames;
    tileSprite.scale.copyFrom(tileProperties.scale);
    tileProperties.scale = FlxDestroyUtil.put(tileProperties.scale);
    tileSprite.alpha = tileProperties.alpha;
    tileSprite.blend = tileProperties.blend;

    return tileSprite;
  }
}

typedef LadderData = {
  col: Int,
  row: Int,
  frames: FlxImageFrame
}
