package escape;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

#if (!web)
import sys.FileSystem;
#end

using flixel.util.FlxArrayUtil;
using StringTools;

class LevelEditorLoadMenu extends PlayMenu {
  public function new(back: () -> Void) {
    var title = "load";

    var levels = getLevels();
    var itemData: Array<MenuItems.ItemData> = [];

    for (level in levels) {
      itemData.push({ name: level.name, action: name -> load(level.fileName) });
    }

    itemData.push({ name: "back", action: name -> this.back(back) });

    super(title, itemData);
  }

  function getLevels(directory: String = "assets/levels"): Array<LevelData> {
    var filterExtensions: Array<String> = ["dat"];
    var levels: Array<LevelData> = [];
#if (!web)
    if (!directory.endsWith("/"))
      directory += "/";

    var directoryInfo = FileSystem.readDirectory(directory);

    for (fileName in directoryInfo) {
      if (!FileSystem.isDirectory(directory + fileName)) {
        // ignore system files
        if (fileName.startsWith(".")) continue;

        var fileNameData = fileName.split(".");
        var extension: String = fileNameData.last();

        if (!filterExtensions.contains(extension)) continue;

        var levelData: LevelData = {
          name: fileNameData[0],
          fileName: directory + fileName
        };

        levels.push(levelData);
      }
    }
#end
    return levels;
  }

  function load(fileName) {
    FlxG.switchState(new LevelEditorState(fileName));
  }

  function back(back: () -> Void) {
    close();
    back();
  }
}

typedef LevelData = {
  fileName: String,
  name: String
}
