package escape;

import flixel.FlxG;

class PlayState extends LevelState {
  var topSpikes: TopSpikes;

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
