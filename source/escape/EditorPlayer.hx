package escape;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class EditorPlayer extends Player {
  // size, position
  public static inline var WIDTH = 24;
  public static inline var HEIGHT = 48;
  public static inline var TILE = 'P';

  public function new() {
    super();

    drag.set(0, 0);
    acceleration.y = 0;
    maxVelocity.set(0, 0);
  }

  override function updateMovement() {
  }

  override public function updateBeforeCollisionChecks() {
  }

  override public function hitSpike(spike: Spike) {
  }

  override function doorTrigger(door: Door) {
  }

  override function ladderTrigger(ladder: Ladder) {
  }

  override public function onLeftWallJumpTrigger(trigger: Trigger, feetTrigger: Trigger) {
  }

  override public function onRightWallJumpTrigger(trigger: Trigger, feetTrigger: Trigger) {
  }
}
