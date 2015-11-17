package;

import openfl.display.Sprite;
import openfl.Lib;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Multitouch;

import flixel.FlxG;

class MetaGamePad extends Sprite
{
	var currentPadState : Map<Int, Bool>;
	var previousPadState : Map<Int, Bool>;
	
	var buttons : Array<GamePadButton>;
	public var touchPoints : Array<Point>;
	
	public function new()
	{
		super();
		
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var leftPanelWidth : Int = Std.int(stageWidth / 4);
		var rightPanelWidth : Int = leftPanelWidth;
		var rightPanelX : Int = 3*leftPanelWidth;
		
		var buttonWidth : Int = Std.int(leftPanelWidth/2);
		var buttonHeight : Int = Std.int(stageHeight / 3);
		
		var upBtn    : GamePadButton = new GamePadButton(Up, 	0, 0, leftPanelWidth, buttonHeight); 
		var downBtn  : GamePadButton = new GamePadButton(Down,  0, buttonHeight*2, leftPanelWidth, buttonHeight);
		var leftBtn  : GamePadButton = new GamePadButton(Left,  0, buttonHeight, buttonWidth, buttonHeight);
		var rightBtn : GamePadButton = new GamePadButton(Right, buttonWidth, buttonHeight, buttonWidth, buttonHeight);
		
		buttons = [upBtn, downBtn, leftBtn, rightBtn];
		
		for (button in buttons)
		{
			addChild(button);
		}
		
		initPadState();
		
		touchPoints = new Array<Point>();
	}
	
	public function checkButton(button : Int) : Bool
	{
		return currentPadState.get(button);
	}

	public function justPressed(button : Int) : Bool
	{
		return currentPadState.get(button) && !previousPadState.get(button);
	}

	public function justReleased(button : Int) : Bool
	{
		return !currentPadState.get(button) && previousPadState.get(button);
	}
	
	public function resetInputs() : Void
	{
		initPadState();
	}
	
	public function handlePadState() : Void
	{
		previousPadState = currentPadState;
		
		currentPadState = new Map<Int, Bool>();
		
		for (point in touchPoints)
		{
			
		}
		
		currentPadState.set(Left, FlxG.keys.anyPressed(["LEFT"]));
		currentPadState.set(Right, FlxG.keys.anyPressed(["RIGHT"]));
		currentPadState.set(Up, FlxG.keys.anyPressed(["UP"]));
		currentPadState.set(Down, FlxG.keys.anyPressed(["DOWN"]));
			
		currentPadState.set(A, FlxG.keys.anyPressed(["A", "Z"]));
		currentPadState.set(B, FlxG.keys.anyPressed(["S", "X"]));
		
		currentPadState.set(Start, FlxG.keys.anyPressed(["ENTER"]));
		currentPadState.set(Select, FlxG.keys.anyPressed(["SPACE"]));
	}
	
	private function initPadState() : Void
	{
		currentPadState = new Map<Int, Bool>();
		currentPadState.set(Left, false);
		currentPadState.set(Right, false);
		currentPadState.set(Up, false);
		currentPadState.set(Down, false);
		currentPadState.set(A, false);
		currentPadState.set(B, false);
		currentPadState.set(Start, false);
		currentPadState.set(Select, false);

		previousPadState = new Map<Int, Bool>();
		previousPadState.set(Left, false);
		previousPadState.set(Right, false);
		previousPadState.set(Up, false);
		previousPadState.set(Down, false);
		previousPadState.set(A, false);
		previousPadState.set(B, false);
		previousPadState.set(Start, false);
		previousPadState.set(Select, false);
	}

	public static var Left 	: Int = 0;
	public static var Right : Int = 1;
	public static var Up	: Int = 2;
	public static var Down	: Int = 3;
	public static var A 	: Int = 4;
	public static var B 	: Int = 5;
	public static var Start : Int = 6;
	public static var Select : Int = 7;
}