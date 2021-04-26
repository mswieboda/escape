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

  // TODO: make names a map, key of names, and holds action functions
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
    if (Action.menuDown.triggered) {
      members[selectedIndex].setSelected(false);

      selectedIndex = selectedIndex + 1 >= members.length ? 0 : selectedIndex + 1;

      members[selectedIndex].setSelected(true);
    } else if (Action.menuUp.triggered) {
      members[selectedIndex].setSelected(false);

      selectedIndex = selectedIndex - 1 < 0 ? members.length - 1 : selectedIndex - 1;

      members[selectedIndex].setSelected(true);
    }

    super.update(elapsed);
  }

  function actionCondition(name: String) {
    return Action.menuAction.triggered;
  }
}

typedef ItemData = {
  name: String,
  ?actionCondition: (name: String) -> Bool,
  ?action: (name: String) -> Void
}
