package escape;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;

class MenuActions {
  public static var up: FlxActionDigital;
  public static var down: FlxActionDigital;
  public static var left: FlxActionDigital;
  public static var right: FlxActionDigital;
  public static var action: FlxActionDigital;
  public static var cancel: FlxActionDigital;

  public static function addInputs(actions: ActionManager) {
    up = new FlxActionDigital();
    down = new FlxActionDigital();
    left = new FlxActionDigital();
    right = new FlxActionDigital();
    action = new FlxActionDigital();
    cancel = new FlxActionDigital();

    actions.addActions([
      up,
      down,
      left,
      right,
      action,
      cancel
    ]);

    // Add keyboard inputs
    up.addKey(UP, JUST_PRESSED);
    up.addKey(W, JUST_PRESSED);
    down.addKey(DOWN, JUST_PRESSED);
    down.addKey(S, JUST_PRESSED);
    left.addKey(LEFT, JUST_PRESSED);
    left.addKey(A, JUST_PRESSED);
    right.addKey(RIGHT, JUST_PRESSED);
    right.addKey(D, JUST_PRESSED);
    action.addKey(ENTER, JUST_PRESSED);
    action.addKey(SPACE, JUST_PRESSED);
    action.addKey(SHIFT, JUST_PRESSED);
    cancel.addKey(ESCAPE, JUST_PRESSED);

    // Add gamepad DPAD inputs
    up.addGamepad(DPAD_UP, JUST_PRESSED);
    down.addGamepad(DPAD_DOWN, JUST_PRESSED);
    left.addGamepad(DPAD_LEFT, JUST_PRESSED);
    right.addGamepad(DPAD_RIGHT, JUST_PRESSED);
    action.addGamepad(A, JUST_PRESSED);
    cancel.addGamepad(B, JUST_PRESSED);

    // Add gamepad analog stick (as simulated DPAD) inputs
    up.addGamepad(LEFT_STICK_DIGITAL_UP, JUST_PRESSED);
    down.addGamepad(LEFT_STICK_DIGITAL_DOWN, JUST_PRESSED);
    left.addGamepad(LEFT_STICK_DIGITAL_LEFT, JUST_PRESSED);
    right.addGamepad(LEFT_STICK_DIGITAL_RIGHT, JUST_PRESSED);
  }
}
