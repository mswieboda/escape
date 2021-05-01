package escape;

import flixel.FlxG;

class Sound {
  public static function play(asset: String, volume: Float = 1) {
    var ext = "ogg";
#if web
    ext = "mp3";
#end

    FlxG.sound.play('assets/sounds/${asset}.${ext}', volume);
  }
}
