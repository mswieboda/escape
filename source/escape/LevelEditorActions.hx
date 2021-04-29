package escape;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;

class LevelEditorActions {
  public static var cycleForward: FlxActionDigital;
  public static var cycleBack: FlxActionDigital;

  public static function addInputs(actions: ActionManager) {
    cycleBack = new FlxActionDigital();
    cycleForward = new FlxActionDigital();

    actions.addActions([
      cycleBack,
      cycleForward
    ]);

    // Add keyboard inputs
    cycleForward.addKey(TAB, JUST_PRESSED);
    // TODO: needs to be SHIFT + TAB
    cycleBack.addKey(BACKSPACE, JUST_PRESSED);

    // Add gamepad DPAD inputs
    cycleForward.addGamepad(RIGHT_SHOULDER, JUST_PRESSED);
    cycleBack.addGamepad(LEFT_SHOULDER, JUST_PRESSED);
  }
}
