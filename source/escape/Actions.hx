package escape;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;

class Actions {
  public static var actions: ActionManager;
  public static inline var game = GameActions;
  public static inline var menu = MenuActions;

  public static function addInputs() {
    if (actions == null) actions = FlxG.inputs.add(new ActionManager());

    game.addInputs(actions);
    menu.addInputs(actions);
  }
}
