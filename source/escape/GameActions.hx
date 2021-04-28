package escape;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;

class GameActions {
  public static var up: FlxActionDigital;
  public static var down: FlxActionDigital;
  public static var left: FlxActionDigital;
  public static var right: FlxActionDigital;
  public static var jump: FlxActionDigital;
  public static var action: FlxActionDigital;
  public static var menu: FlxActionDigital;

  public static function addInputs(actions: ActionManager) {
    up = new FlxActionDigital();
    down = new FlxActionDigital();
    left = new FlxActionDigital();
    right = new FlxActionDigital();
    jump = new FlxActionDigital();
    action = new FlxActionDigital();
    menu = new FlxActionDigital();

    actions.addActions([
      up,
      down,
      left,
      right,
      jump,
      action,
      menu
    ]);

    // Add keyboard inputs
    up.addKey(UP, PRESSED);
    up.addKey(W, PRESSED);
    down.addKey(DOWN, PRESSED);
    down.addKey(S, PRESSED);
    left.addKey(LEFT, PRESSED);
    left.addKey(A, PRESSED);
    right.addKey(RIGHT, PRESSED);
    right.addKey(D, PRESSED);
    jump.addKey(UP, JUST_PRESSED);
    jump.addKey(W, JUST_PRESSED);
    jump.addKey(SPACE, JUST_PRESSED);
    action.addKey(ENTER, JUST_PRESSED);
    menu.addKey(ESCAPE, JUST_PRESSED);
    menu.addKey(BACKSPACE, JUST_PRESSED);

    // Add gamepad DPAD inputs
    up.addGamepad(DPAD_UP, PRESSED);
    down.addGamepad(DPAD_DOWN, PRESSED);
    left.addGamepad(DPAD_LEFT, PRESSED);
    right.addGamepad(DPAD_RIGHT, PRESSED);
    jump.addGamepad(A, JUST_PRESSED);
    action.addGamepad(X, JUST_PRESSED);
    menu.addGamepad(START, JUST_PRESSED);
    menu.addGamepad(BACK, JUST_PRESSED);

    // Add gamepad analog stick (as simulated DPAD) inputs
    up.addGamepad(LEFT_STICK_DIGITAL_UP, PRESSED);
    down.addGamepad(LEFT_STICK_DIGITAL_DOWN, PRESSED);
    left.addGamepad(LEFT_STICK_DIGITAL_LEFT, PRESSED);
    right.addGamepad(LEFT_STICK_DIGITAL_RIGHT, PRESSED);
  }
}
