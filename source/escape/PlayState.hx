package escape;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
  var player: Player;

  override public function create() {
    player = new Player(30, 30);

    add(player);

    FlxG.mouse.visible = false;

    super.create();
  }

  override function update(elapsed: Float) {
    super.update(elapsed);
  }
}
