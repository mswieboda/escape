package escape;

import flixel.FlxG;
import flixel.FlxState;

class BaseLevelState extends FlxState {
  var player: Player;
  var level: BaseLevel;

  public function new(
    player: Player,
    level: BaseLevel
  ) {
    super();

    this.player = player;
    this.level = level;
  }

  override public function create() {
    super.create();

    // TODO: why are none of these working? move where they need to be
    FlxG.mouse.visible = false;
    FlxG.mouse.enabled = false;
    FlxG.mouse.useSystemCursor = false;

    Actions.addInputs();

    addLevel();
  }

  function addLevel() {
    Camera.setup(player);

    var background = new Background(level.widthInTiles, level.heightInTiles);

    add(background);
    add(level);
    add(player);
    add(player.feetTrigger);
    add(level.foregrounds);
    add(player.actionMessage);

    player.setPosition(level.playerPosition.x, level.playerPosition.y);
  }

  public function restart() {
    // to be overridden
  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    player.updateBeforeCollisionChecks();
    level.updateCollisions(player);

    if (!player.alive && subState == null) openSubState(new GameOverMenu());
    if (Actions.game.menu.triggered) openSubState(new PauseMenu(this));
  }
}
