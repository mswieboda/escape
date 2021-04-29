package escape;

import flixel.system.FlxAssets;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import sys.io.File;
import sys.FileSystem;

class LevelEditor extends BaseLevel {
  static inline var TILE_WIDTH = BaseLevel.TILE_WIDTH;
  static inline var TILE_HEIGHT = BaseLevel.TILE_HEIGHT;
  static inline var CURSOR_THICKNESS = 5.0;
  static inline var CURSOR_COLOR = 0xFF00FF00;

  var cursor: FlxSprite;
  var cursorCol: Int = 0;
  var cursorRow: Int = 0;

  public function new(
    player: Player,
    fileName: String,
    tileGraphic: FlxTilemapGraphicAsset = AssetPaths.tiles__png
  ) {
    makeCursor();

    super(player, fileName, tileGraphic);
  }

  function makeCursor() {
    cursor = new FlxSprite();

    var width = Std.int(TILE_WIDTH + CURSOR_THICKNESS);
    var height = Std.int(TILE_HEIGHT + CURSOR_THICKNESS);

    cursor.makeGraphic(width, height, FlxColor.TRANSPARENT);

    FlxSpriteUtil.drawRect(
      cursor,
      CURSOR_THICKNESS / 2,
      CURSOR_THICKNESS / 2,
      TILE_WIDTH,
      TILE_HEIGHT,
      FlxColor.TRANSPARENT,
      {thickness: CURSOR_THICKNESS, color: CURSOR_COLOR}
    );
  }

  override function addAll() {
    super.addAll();

    foregrounds.add(cursor);
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    updateCursorPosition();
    checkForTileEdit();
  }

  function updateCursorPosition() {
    var up = Actions.menu.up.triggered;
    var down = Actions.menu.down.triggered;
    var left = Actions.menu.left.triggered;
    var right = Actions.menu.right.triggered;

    if (up && down) up = down = false;
    if (left && right) left = right = false;

    if (up || down) {
      cursor.y += up ? -TILE_HEIGHT : TILE_HEIGHT;
      cursorRow += up ? -1 : 1;
    } else if (left || right) {
      cursor.x += left ? -TILE_WIDTH : TILE_WIDTH;
      cursorCol += left ? -1 : 1;
    }
  }

  function checkForTileEdit() {
    var action = Actions.menu.action.triggered;
    var cycleForward = Actions.editor.cycleForward.triggered;
    var cycleBack = Actions.editor.cycleForward.triggered;

    if (!action && !cycleForward && !cycleBack) return;

    var tile = getTile(cursorRow, cursorCol);
    var newTile = '';

    addEmptiesToCursor();

    if (action && (tile == '0' || tile == '1')) {
      newTile = tile == '0' ? '1' : '0';
    } else if (cycleForward || cycleBack) {
      var allTiles = ['0', '1', Spike.TILE, Lava.TILE, Door.TILE, Ladder.TILE, Player.TILE];
      var index = allTiles.indexOf(tile.toUpperCase());

      if (index < 0) return;

      if (cycleForward) {
        newTile = allTiles[index + 1 < allTiles.length ? index + 1 : 0];
      } else {
        newTile = allTiles[index - 1 >= 0 ? index - 1 : allTiles.length - 1];
      }
    }

    if (newTile != '') {
      // TODO: flip this around in BaseLevel to be [cursorCol][cursorRow] for consistency with tiles.setTile
      levelStrData[cursorRow][cursorCol] = newTile;

      reloadTiles();
    }
  }

  function addEmptiesToCursor() {
    if (cursorRow >= levelStrData.length) {
      for (r in levelStrData.length...(cursorRow + 1)) {
        levelStrData[r] = [];

        for (c in 0...levelStrData[0].length) {
          levelStrData[r][c] = '0';
          tiles.setTile(c, r, 0);
        }
      }
    }

    if (cursorCol >= levelStrData[0].length) {
      for (r in 0...levelStrData.length) {
        for (c in levelStrData[r].length...(cursorCol + 1)) {
          levelStrData[r][c] = '0';
          tiles.setTile(c, cursorRow, 0);
        }
      }
    }
  }

  public function save() {
    var content = levelStrData.map(cols -> cols.join(',')).join("\n");
    File.saveContent(fileName, content);
  }
}
