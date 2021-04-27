package escape;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class MenuItem extends FlxText {
  static inline var FONT_SIZE = 32;
  static inline var TEXT_COLOR = 0xFF00CC00;
  static inline var BORDER_SELECTED_SIZE = 4;
  static inline var BORDER_SELECTED_COLOR = 0xFF006600;

  public var name: String;
  public var selected: Bool = false;
  public var actionCondition: (name: String) -> Bool;
  public var action: (name: String) -> Void;

  public function new(y: Float, name: String) {
    super(0, y, 0, name, FONT_SIZE);

    this.selected = false;
    this.name = name;

    color = TEXT_COLOR;
    borderSize = BORDER_SELECTED_SIZE;
    borderStyle = FlxTextBorderStyle.SHADOW;
    screenCenter(FlxAxes.X);
  }

  override function update(elapsed: Float) {
    if (actionCondition != null && selected && actionCondition(name)) fireAction();

    super.update(elapsed);
  }

  public function setSelected(selected: Bool) {
    borderColor = selected ? BORDER_SELECTED_COLOR : FlxColor.TRANSPARENT;
    this.selected = selected;

    if (selected) playSound("blip", 0.69);
  }

  public function fireAction() {
    if (action != null) {
      action(name);
      playSound("blip", 0.69);
    }
  }

  function playSound(asset: String, volume: Float = 1) {
    var ext = "ogg";
#if web
    ext = "mp3";
#end

    FlxG.sound.play('assets/sounds/${asset}.${ext}', volume);
  }
}
