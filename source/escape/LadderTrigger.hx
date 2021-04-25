package escape;

class LadderTrigger extends Trigger {
  public var ladder: Ladder;

  public function new(x: Float, y: Float, width: Float, height: Float, ladder: Ladder) {
    super(x, y, width, height);

    this.ladder = ladder;
  }
}
