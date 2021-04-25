package escape;

class TopSpike extends Spike {
  public function new(x: Float, y: Float) {
    super(x, y, Spike.TOP);

    flipY = true;

    // keeps it static at the top, kind of like a HUD
    // instead of `setScroll(0, 0);` since that gets ignored by collisions
    velocity.y = Camera.SCROLL_SPEED;
  }
}
