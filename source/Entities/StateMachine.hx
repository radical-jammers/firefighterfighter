package;

class StateMachine
{
	public var activeState : Void -> Void;
	var onStateChange : String -> Void;

	public function new(?InitState : Void -> Void, ?OnStateChange : String -> Void)
	{
		activeState = InitState;
		onStateChange = OnStateChange;
	}

	public function update() : Void
	{
		if (activeState != null)
			activeState();
	}

	public function transition(newState : Void -> Void, ?stateName : String = null)
	{
		activeState = newState;
		if (onStateChange != null)
			onStateChange(stateName);
	}
}