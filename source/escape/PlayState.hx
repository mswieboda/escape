package escape;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends LevelState {
  var topSpikes: TopSpikes;

  public function new() {
    super(AssetPaths.level__dat, AssetPaths.tiles__png);
  }

  override public function create() {
    super.create();

    topSpikes = new TopSpikes();

    add(topSpikes);
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    Camera.update(elapsed, topSpikes.cameraMinY());

    FlxG.collide(topSpikes, player, Player.onHitSpikes);
  }
}
