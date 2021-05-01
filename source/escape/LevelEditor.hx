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
  static inline var LAYERS = BaseLevel.LAYERS;
  static inline var CURSOR_THICKNESS = 2.5;
  static inline var CURSOR_COLOR = 0xFF00FF00;
  static var TILES: Array<String> = [
    '0',
    '1',
    Spike.TILE,
    SpikeFalling.TILE,
    Lava.TILE,
    Door.TILE,
    Ladder.TILE,
    Player.TILE
  ];

  public var cursor: FlxSprite;

  var cursorCol: Int = 0;
  var cursorRow: Int = 0;
  var cursorLayer: Int = 0;

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

    var width = Std.int(TILE_WIDTH + CURSOR_THICKNESS * 2);
    var height = Std.int(TILE_HEIGHT + CURSOR_THICKNESS * 2);

    cursor.makeGraphic(width, height, FlxColor.TRANSPARENT);

    FlxSpriteUtil.drawRect(
      cursor,
      CURSOR_THICKNESS / 2,
      CURSOR_THICKNESS / 2,
      TILE_WIDTH + CURSOR_THICKNESS,
      TILE_HEIGHT + CURSOR_THICKNESS,
      FlxColor.TRANSPARENT,
      {thickness: CURSOR_THICKNESS, color: CURSOR_COLOR}
    );
    cursor.setPosition(-CURSOR_THICKNESS, -CURSOR_THICKNESS);

    setCursorColor();
  }

  function setCursorColor() {
    cursor.color = FlxColor.fromHSL(0, 0, (cursorLayer + 1) / LAYERS);
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
    var layerForward = Actions.editor.layerForward.triggered;
    var layerBack = Actions.editor.layerBack.triggered;

    if (up && down) up = down = false;
    if (left && right) left = right = false;

    if (!up && !down && !left && !right && !layerForward && !layerBack) return;

    if (up || down) {
      cursor.y += up ? -TILE_HEIGHT : TILE_HEIGHT;
      cursorRow += up ? -1 : 1;

      if (cursorRow < 0) cursorRow = 0;
    }

    if (left || right) {
      cursor.x += left ? -TILE_WIDTH : TILE_WIDTH;
      cursorCol += left ? -1 : 1;

      if (cursorCol < 0) cursorCol = 0;
    }

    if (layerForward || layerBack) {
      cursorLayer += layerForward ? 1 : -1;

      if (cursorLayer < 0) cursorLayer = LAYERS - 1;
      if (cursorLayer >= LAYERS) cursorLayer = 0;

      setCursorColor();
    }
  }

  function checkForTileEdit() {
    var action = Actions.menu.action.triggered;
    var tileForward = Actions.editor.tileForward.triggered;
    var tileBack = Actions.editor.tileForward.triggered;

    if (!action && !tileForward && !tileBack) return;

    var tile = getTile(cursorCol, cursorRow, cursorLayer);
    var newTile = '';

    addEmptiesToCursor();

    if (action && (tile == '0' || tile == '1')) {
      newTile = tile == '0' ? '1' : '0';
    } else if (cursorLayer == 0 && (tileForward || tileBack)) {
      var index = TILES.indexOf(tile.toUpperCase());

      if (index < 0) return;

      if (tileForward) {
        newTile = TILES[index + 1 < TILES.length ? index + 1 : 0];
      } else {
        newTile = TILES[index - 1 >= 0 ? index - 1 : TILES.length - 1];
      }
    }

    if (newTile != '') {
      levelStrData[cursorRow][cursorCol][cursorLayer] = newTile;

      reloadTiles();
    }
  }

  function addEmptiesToCursor() {
    if (cursorRow >= levelStrData.length) {
      for (r in levelStrData.length...(cursorRow + 1)) {
        levelStrData[r] = [];

        for (c in 0...levelStrData[0].length) {
          levelStrData[r][c] = [for (l in 0...LAYERS) '0'];
          tiles.setTile(c, r, 0);
          foregroundTiles.setTile(c, r, 0);
        }
      }
    }

    if (cursorCol >= levelStrData[0].length) {
      for (r in 0...levelStrData.length) {
        for (c in levelStrData[r].length...(cursorCol + 1)) {
          levelStrData[r][c] = [for (l in 0...LAYERS) '0'];
          tiles.setTile(c, cursorRow, 0);
          foregroundTiles.setTile(c, cursorRow, 0);
        }
      }
    }
  }

  public function save() {
    var content = levelStrData.map(row -> row.map(layers -> layers.join('|')).join(',')).join("\n");
    File.saveContent(fileName, content);
  }
}
