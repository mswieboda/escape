package escape;

class IntroState extends LevelState {
  public function new() {
    var player = new Player();
    var level = new Level(player, AssetPaths.layers__dat);

    super(player, level);
  }
}
