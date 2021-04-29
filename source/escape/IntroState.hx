package escape;

import flixel.FlxG;
import flixel.FlxState;

class IntroState extends LevelState {
  public function new() {
    super(AssetPaths.intro__dat, AssetPaths.tiles__png);
  }
}
