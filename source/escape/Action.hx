package escape;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;

class Action {
  public static var actions: FlxActionManager;

  public static var up: FlxActionDigital;
  public static var down: FlxActionDigital;
  public static var left: FlxActionDigital;
  public static var right: FlxActionDigital;
  public static var jump: FlxActionDigital;
  public static var action: FlxActionDigital;

  public static var menuUp: FlxActionDigital;
  public static var menuDown: FlxActionDigital;
  public static var menuAction: FlxActionDigital;
  public static var menuCancel: FlxActionDigital;

  public static function addInputs() {
    // actions
    up = new FlxActionDigital();
    down = new FlxActionDigital();
    left = new FlxActionDigital();
    right = new FlxActionDigital();
    jump = new FlxActionDigital();
    action = new FlxActionDigital();

    menuUp = new FlxActionDigital();
    menuDown = new FlxActionDigital();
    menuAction = new FlxActionDigital();
    menuCancel = new FlxActionDigital();

    if (actions == null) actions = FlxG.inputs.add(new FlxActionManager());

    actions.addActions([up, down, left, right, jump, action, menuUp, menuDown, menuAction, menuCancel]);
    actions.resetOnStateSwitch = NONE;
    // FlxG.inputs.resetOnStateSwitch = true;

    // ACTIONS
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

    // Add gamepad DPAD inputs
    up.addGamepad(DPAD_UP, PRESSED);
    down.addGamepad(DPAD_DOWN, PRESSED);
    left.addGamepad(DPAD_LEFT, PRESSED);
    right.addGamepad(DPAD_RIGHT, PRESSED);
    jump.addGamepad(A, JUST_PRESSED);
    action.addKey(X, JUST_PRESSED);

    // Add gamepad analog stick (as simulated DPAD) inputs
    up.addGamepad(LEFT_STICK_DIGITAL_UP, PRESSED);
    down.addGamepad(LEFT_STICK_DIGITAL_DOWN, PRESSED);
    left.addGamepad(LEFT_STICK_DIGITAL_LEFT, PRESSED);
    right.addGamepad(LEFT_STICK_DIGITAL_RIGHT, PRESSED);

    // MENU ACTIONS
    // Add keyboard inputs
    menuUp.addKey(UP, JUST_PRESSED);
    menuUp.addKey(W, JUST_PRESSED);
    menuUp.addKey(TAB, JUST_PRESSED);
    menuDown.addKey(DOWN, JUST_PRESSED);
    menuDown.addKey(S, JUST_PRESSED);
    // TODO: add combo of SHIFT+TAB for down
    // down.addKey(SHIFT + TAB, JUST_PRESSED);
    menuAction.addKey(ENTER, JUST_PRESSED);
    menuAction.addKey(SPACE, JUST_PRESSED);
    menuAction.addKey(SHIFT, JUST_PRESSED);
    menuCancel.addKey(ESCAPE, JUST_PRESSED);
    menuCancel.addKey(BACKSPACE, JUST_PRESSED);

    // Add gamepad DPAD inputs
    up.addGamepad(DPAD_UP, JUST_PRESSED);
    down.addGamepad(DPAD_DOWN, JUST_PRESSED);
    menuAction.addGamepad(A, JUST_PRESSED);
    menuCancel.addKey(B, JUST_PRESSED);

    // Add gamepad analog stick (as simulated DPAD) inputs
    menuUp.addGamepad(LEFT_STICK_DIGITAL_UP, PRESSED);
    menuDown.addGamepad(LEFT_STICK_DIGITAL_DOWN, PRESSED);
  }
}
