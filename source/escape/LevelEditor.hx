package escape;

import flixel.system.FlxAssets;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;


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
    levelData: String,
    tileGraphic: FlxTilemapGraphicAsset
  ) {
    makeCursor();

    super(player, levelData, tileGraphic);
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
    trace('LevelEditor addAll');
    super.addAll();

    add(cursor);
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

    if (!action) return;

    var tile = getTile(cursorRow, cursorCol);

    if (tile == '0' || tile == '1') {
      tiles.setTile(cursorCol, cursorRow, tile == '0' ? 1 : 0);
    }
  }
}
