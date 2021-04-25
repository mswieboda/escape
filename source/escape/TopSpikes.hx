package escape;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;

class TopSpikes extends FlxGroup {
  public static inline var SPEED = 16;

  var trigger: Trigger;

  public function new() {
    super();

    var spikes = Std.int(FlxG.width / Spike.WIDTH);

    for(i in 0...spikes) {
      var spike = new Spike(i * Spike.WIDTH, 0, Spike.TOP);
      spike.velocity.y = SPEED;
      add(spike);
    }

    trigger = new Trigger(0, 0, FlxG.width, 8);
    trigger.moves = true;
    trigger.velocity.y = SPEED;
    add(trigger);
  }

  public function cameraMinY(): Float {
    return trigger.y;
  }
}
