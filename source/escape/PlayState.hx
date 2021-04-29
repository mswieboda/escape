package escape;

import flixel.FlxG;

class PlayState extends LevelState {
  var topSpikes: TopSpikes;

  public function new() {
    var player = new Player();
    var level = new Level(player, AssetPaths.level__dat);

    super(player, level);
  }

  override function addLevel() {
    super.addLevel();

    topSpikes = new TopSpikes();

    add(topSpikes);
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    Camera.update(elapsed, topSpikes.cameraMinY());

    FlxG.collide(topSpikes, player, Player.onHitSpikes);
  }
}
