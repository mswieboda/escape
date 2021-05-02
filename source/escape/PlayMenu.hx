package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class PlayMenu extends FlxSubState {
  static inline var FONT_SIZE = 32;
  static inline var PADDING = 16;

  var title: String;
  var itemData: Array<MenuItems.ItemData>;
  var parentPersistentUpdate: Bool;
  var parentPersistentDraw: Bool;
  var firstFrame = true;

  public function new(
    title: String,
    itemData: Array<MenuItems.ItemData>,
    parentPersistentUpdate: Bool = false,
    parentPersistentDraw: Bool = true
  ) {
    super();

    this.title = title;
    this.itemData = itemData;
    this.parentPersistentUpdate = parentPersistentUpdate;
    this.parentPersistentDraw = parentPersistentDraw;
  }

  override public function create() {
    super.create();

    var text = new FlxText();
    text.text = title;
    text.size = FONT_SIZE;

    // so it's static like a HUD at the top of the camera
    text.scrollFactor.set(0, 0);
    text.screenCenter();

    add(text);

    add(new MenuItems(text.y + text.height + PADDING, itemData));

    if (_parentState != null) {
      _parentState.persistentUpdate = parentPersistentUpdate;
      _parentState.persistentDraw = parentPersistentDraw;
    }

    Actions.addInputs();
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    if (firstFrame) firstFrame = false;
  }
}
