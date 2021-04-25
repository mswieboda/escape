package escape;

import flixel.FlxG;
import flixel.group.FlxGroup;

class TopSpikes extends FlxGroup {
  public function new() {
    super();

    var spikes = Std.int(FlxG.width / Spike.WIDTH);

    for(i in 0...spikes) {
      var spike = new TopSpike(i * Spike.WIDTH, 0);
      add(spike);
    }
  }
}
