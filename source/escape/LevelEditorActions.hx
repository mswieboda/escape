package escape;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;

class LevelEditorActions {
  public static var layerForward: FlxActionDigital;
  public static var layerBack: FlxActionDigital;
  public static var tileForward: FlxActionDigital;
  public static var tileBack: FlxActionDigital;

  public static function addInputs(actions: ActionManager) {
    layerBack = new FlxActionDigital();
    layerForward = new FlxActionDigital();
    tileBack = new FlxActionDigital();
    tileForward = new FlxActionDigital();

    actions.addActions([
      layerBack,
      layerForward,
      tileBack,
      tileForward
    ]);

    // Add keyboard inputs
    layerForward.addKey(PERIOD, JUST_PRESSED);
    layerBack.addKey(COMMA, JUST_PRESSED);
    tileForward.addKey(TAB, JUST_PRESSED);
    // TODO: needs to be SHIFT + TAB
    tileBack.addKey(BACKSPACE, JUST_PRESSED);

    // Add gamepad DPAD inputs
    tileForward.addGamepad(RIGHT_SHOULDER, JUST_PRESSED);
    tileBack.addGamepad(LEFT_SHOULDER, JUST_PRESSED);
    layerForward.addGamepad(RIGHT_TRIGGER_BUTTON, JUST_PRESSED); // TODO: test, maybe just RIGHT_TRIGGER
    layerBack.addGamepad(LEFT_TRIGGER_BUTTON, JUST_PRESSED); // TODO: test, maybe just LEFT_TRIGGER
  }
}
