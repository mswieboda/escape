package;

import escape.MenuState;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
  public static var env: String;

  static inline var TEST = "TEST";

  public function new() {
    getEnv();

    super();

    if (env == TEST) FlxG.debugger.drawDebug = true;

    addChild(new FlxGame(0, 0, MenuState, 1, 60, 60, true, false));
  }


  public static function getEnv(): String {
    if (env != null) return env;

#if web
    env = "";
#else
    env = Sys.getEnv("ENV");
#end
    env = env != null ? env.toUpperCase() : env;

    return env;
  }
}
