package escape;

import flixel.FlxG;
import flixel.group.FlxGroup;

class Spikes extends FlxGroup {
  public function new() {
    super();

    var spikes = Std.int(FlxG.width / Spike.WIDTH);

    for(i in 0...spikes) {
      var spike = new Spike(i * Spike.WIDTH, 0);
      add(spike);
    }
  }
}
