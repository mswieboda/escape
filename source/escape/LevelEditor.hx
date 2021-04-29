package escape;

import flixel.system.FlxAssets;

class LevelEditor extends BaseLevel {
  public function new(
    player: Player,
    levelData: String,
    tileGraphic: FlxTilemapGraphicAsset
  ) {
    super(player, levelData, tileGraphic);


  }

  override function update(elapsed: Float) {
    super.update(elapsed);

    // player.updateBeforeCollisionChecks(elapsed);

    // FlxG.collide(colliders, player);
    // FlxG.collide(spikes, player, Player.onHitSpikes);
    // FlxG.overlap(doorTriggers, player, Player.onDoorTrigger, Door.onDoorTrigger);
    // FlxG.overlap(ladderTriggers, player, Player.onLadderTrigger);
    // FlxG.overlap(leftWallJumpTriggers, player.feetTrigger, player.onLeftWallJumpTrigger);
    // FlxG.overlap(rightWallJumpTriggers, player.feetTrigger, player.onRightWallJumpTrigger);
  }
}
