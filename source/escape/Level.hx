package escape;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.system.FlxAssets;
import openfl.Assets;

class Level extends FlxGroup {
  var player: Player;
  var tiles: FlxTilemap;
  var colliders: FlxGroup;
  var doors: FlxGroup;
  var doorTriggers: FlxGroup;
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
    spikes = new Spikes();

    loadTiles(levelData, tileGraphic);

    colliders.add(tiles);
    colliders.add(doors);

    add(tiles);
    add(doors);
    add(doorTriggers);
    add(player);
    add(spikes);
  }

  override function update(elapsed: Float) {
    player.updateBeforeCollisionChecks(elapsed);

    FlxG.collide(player, colliders);
    FlxG.collide(player, spikes, Player.onHitSpikes);
    FlxG.overlap(player, doorTriggers, Player.onDoorTrigger, Door.onDoorTrigger);

    super.update(elapsed);
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

    if (Assets.exists(csv)) {
      csv = Assets.getText(csv);
    }

    var levelStrData = parseCSV(csv);

    for(row => rowStrData in levelStrData) {
      var rowData: Array<Int> = [];

      for (col => tile in rowStrData) {
        var tileData = Std.parseInt(tile);

        if (tileData == null) {
          switch(tile) {
            case Door.TILE:
              var prevTile = levelStrData[row - 1][col];
              var nextTile = levelStrData[row + 1][col];

              tileData = 0;

              if (prevTile != Door.TILE) {
                if (nextTile == Door.TILE) {
                  var door = new Door(col * TILE_WIDTH, row * TILE_HEIGHT);

                  doors.add(door);
                  doorTriggers.add(door.trigger);
                } else {
                  tileData = 1;
                }
              }
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
  }
}
