package escape;

import flixel.FlxG;
import flixel.FlxState;

class LevelEditorState extends LevelState {
  public function new() {
    super(AssetPaths.level__dat, AssetPaths.tiles__png);
  }
}
