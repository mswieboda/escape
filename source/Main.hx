package;

import escape.PlayState;
import escape.MenuState;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;

class Main extends Sprite {
  static inline var TEST = "TEST";

  public function new() {
    super();

    var env = Sys.getEnv("ENV");
    env = env != null ? env.toUpperCase() : env;

    var state: Class<FlxState> = env == TEST ? PlayState : MenuState;

    addChild(new FlxGame(0, 0, state, 1, 60, 60, true, false));
  }
}
