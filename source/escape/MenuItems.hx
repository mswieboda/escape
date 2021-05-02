package escape;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class MenuItems extends FlxTypedGroup<MenuItem> {
  static inline var PADDING = 16;

  var selectedIndex = 0;
  var firstFrame = true;

  public function new(y: Float, itemData: Array<ItemData>) {
    super();

    for (index => data in itemData) {
      var item = new MenuItem(0, data.name);

      item.scrollFactor.set(0, 0);
      item.y = y + index * (item.height + PADDING);
      item.actionCondition = data.actionCondition != null ? data.actionCondition : actionCondition;
      item.action = data.action;

      add(item);
    }

    members[selectedIndex].setSelected(true);
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    if (firstFrame) {
      firstFrame = false;
      return;
    }

    if (Actions.menu.down.triggered) {
      members[selectedIndex].setSelected(false);

      selectedIndex = selectedIndex + 1 >= members.length ? 0 : selectedIndex + 1;

      members[selectedIndex].setSelected(true);
    } else if (Actions.menu.up.triggered) {
      members[selectedIndex].setSelected(false);

      selectedIndex = selectedIndex - 1 < 0 ? members.length - 1 : selectedIndex - 1;

      members[selectedIndex].setSelected(true);
    }
  }

  function actionCondition(name: String): Bool {
    if (firstFrame) return false;

    return Actions.menu.action.triggered;
  }
}

typedef ItemData = {
  name: String,
  ?actionCondition: (name: String) -> Bool,
  ?action: (name: String) -> Void
}
