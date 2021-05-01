package escape;

import flixel.FlxG;

class PlayState extends LevelState {
  var topSpikes: TopSpikes;

  public function new() {
    super(AssetPaths.level__dat);
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
