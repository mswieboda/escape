package escape;

import flixel.FlxG;
import flixel.util.FlxAxes;

class SpikeFalling extends Spike {
  public static inline var TILE = "SF";

  static inline var WIDTH = Spike.WIDTH;
  static inline var HEIGHT = Spike.HEIGHT;

  // shake values
  static inline var SHAKE_INTENSITY = 0.03;
  static inline var SHAKE_DURATION = 0.3;
  static inline var SHAKE_AXES = FlxAxes.XY;

  static inline var GRAVITY = Player.GRAVITY;
  static inline var GROUND_BOUNCE_SPEED = 100;

  public var trigger: Trigger;

  var shakeDuration: Float = 0;
  var shakeComplete: Void -> Void;

  public function new(x: Float, y: Float, triggerHeight: Float) {
    super(x, y, Spike.TOP);

    immovable = false;

    trigger = new Trigger(x - WIDTH * 1.5, y, WIDTH * 4, triggerHeight, this);
  }

  function shakeToFall() {
    if (shakeDuration > 0 || acceleration.y > 0) return;

    shake(fall);
  }

  function hitGroundShake() {
    velocity.y = -GROUND_BOUNCE_SPEED;

    // TODO: make a hit ground sound, or a slicing sound, etc
    Sound.play("jump", 1);

    shake(disappear);
  }

  public function shake(onComplete: Void -> Void, force: Bool = false): Void {
    if (!force && shakeDuration > 0) return;

    shakeDuration = SHAKE_DURATION;
    shakeComplete = onComplete;
  }

  function fall() {
    acceleration.y = GRAVITY;
  }

  function disappear() {
    kill();
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    updateShake(elapsed);
    updateHitGround();
  }

  function updateShake(elapsed: Float) {
    if (shakeDuration > 0) {
      shakeDuration -= elapsed;

      if (shakeDuration <= 0) {
        if (shakeComplete != null) {
          shakeComplete();
        }
      } else {
        if (SHAKE_AXES != FlxAxes.Y) {
          x += FlxG.random.float(-SHAKE_INTENSITY * width, SHAKE_INTENSITY * width);
        }

        if (SHAKE_AXES != FlxAxes.X) {
          y += FlxG.random.float(-SHAKE_INTENSITY * height, SHAKE_INTENSITY * height);
        }
      }
    }
  }

  function updateHitGround() {
    if (acceleration.y == 0) return;

    if (y + height >= trigger.y + trigger.height) {
      hitGroundShake();
    }
  }

  public static function onTrigger(spikeTrigger: Trigger, feetTrigger: Trigger) {
    cast(spikeTrigger.parent, SpikeFalling).shakeToFall();
  }
}
