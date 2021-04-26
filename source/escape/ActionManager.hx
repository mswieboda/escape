package escape;

import flixel.input.actions.FlxActionManager;

class ActionManager extends FlxActionManager {
  public override function reset(): Void {
    untyped sets.length = 0;
  }
}
