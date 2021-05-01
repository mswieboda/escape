package escape;

import flixel.FlxG;

class LevelState extends BaseLevelState {
  var levelFileName: String;

  public function new(levelFileName: String = AssetPaths.level__dat) {
    this.levelFileName = levelFileName;

    var player = new Player();
    var level = new Level(player, levelFileName);

    super(player, level);
  }

  override function addLevel() {
    super.addLevel();
    Camera.setup(player);
  }

  override public function restart() {
    FlxG.switchState(Type.createInstance(Type.getClass(this), [levelFileName]));
  }
}
