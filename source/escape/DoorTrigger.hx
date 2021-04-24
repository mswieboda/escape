package escape;

class DoorTrigger extends Trigger {
  public var door: Door;

  public function new(x: Float, y: Float, width: Float, height: Float, door: Door) {
    super(x, y, width, height);

    this.door = door;
  }
}
