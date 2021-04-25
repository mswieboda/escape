package escape;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;

class TopSpikes extends FlxGroup {
  public function new() {
    super();

    var spikes = Std.int(FlxG.width / Spike.WIDTH);

    for(i in 0...spikes) {
      var spike = new TopSpike(i * Spike.WIDTH, 0);
      add(spike);
    }

    var trigger = new Trigger(0, 0, FlxG.width, 8);
    trigger.moves = true;
    trigger.velocity.y = Camera.SCROLL_SPEED;
    add(trigger);
  }
}
