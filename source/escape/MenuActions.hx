package escape;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;

class MenuActions {
  public static var up: FlxActionDigital;
  public static var down: FlxActionDigital;
  public static var action: FlxActionDigital;
  public static var cancel: FlxActionDigital;

  public static function addInputs(actions: ActionManager) {
    up = new FlxActionDigital();
    down = new FlxActionDigital();
    action = new FlxActionDigital();
    cancel = new FlxActionDigital();

    actions.addActions([
      up,
      down,
      action,
      cancel
    ]);

    // Add keyboard inputs
    up.addKey(UP, JUST_PRESSED);
    up.addKey(W, JUST_PRESSED);
    up.addKey(TAB, JUST_PRESSED);
    down.addKey(DOWN, JUST_PRESSED);
    down.addKey(S, JUST_PRESSED);
    // TODO: add combo of SHIFT+TAB for down
    // down.addKey(SHIFT + TAB, JUST_PRESSED);
    action.addKey(ENTER, JUST_PRESSED);
    action.addKey(SPACE, JUST_PRESSED);
    action.addKey(SHIFT, JUST_PRESSED);
    cancel.addKey(ESCAPE, JUST_PRESSED);
    cancel.addKey(BACKSPACE, JUST_PRESSED);

    // Add gamepad DPAD inputs
    up.addGamepad(DPAD_UP, JUST_PRESSED);
    down.addGamepad(DPAD_DOWN, JUST_PRESSED);
    action.addGamepad(A, JUST_PRESSED);
    action.addGamepad(START, JUST_PRESSED);
    cancel.addGamepad(B, JUST_PRESSED);
    cancel.addGamepad(BACK, JUST_PRESSED);

    // Add gamepad analog stick (as simulated DPAD) inputs
    up.addGamepad(LEFT_STICK_DIGITAL_UP, JUST_PRESSED);
    down.addGamepad(LEFT_STICK_DIGITAL_DOWN, JUST_PRESSED);
  }
}
