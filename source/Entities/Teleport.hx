package;

class Teleport extends Entity
{
	public var target : String;

	public function new(X : Float, Y : Float, World : World, Width : Int, Height : Int, Target : String)
	{
		super(X, Y, World);

		makeGraphic(Width, Height, 0x00000000);

		setSize(Width, Height);

		target = Target;

		immovable = true;
	}

	override public function draw()
	{
		// haha no~
	}
}