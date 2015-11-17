package;

import flash.display.BitmapData;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxVirtualPad;
import flixel.ui.FlxButton;

@:bitmap("assets/images/ui/virtualpad/x.png")
private class GraphicX extends BitmapData {}

class GamePad
{	
	static var previousPadState : Map<Int, Bool>;
	static var currentPadState : Map<Int, Bool>;
	
	public static function setupVirtualPad() : Void
	{	
		initPadState();
	}
	
	public static function handlePadState() : Void
	{
		previousPadState = currentPadState;
		
		currentPadState = new Map<Int, Bool>();
		
		var metapad : MetaGamePad = MetaGamePad.Current;
		
		/*currentPadState.set(Left, 
			virtualPad.buttonLeft.status == FlxButton.PRESSED || FlxG.keys.anyPressed(["LEFT"]));
		currentPadState.set(Right, 
			virtualPad.buttonRight.status == FlxButton.PRESSED || FlxG.keys.anyPressed(["RIGHT"]));
		currentPadState.set(Up, 
			virtualPad.buttonUp.status == FlxButton.PRESSED || FlxG.keys.anyPressed(["UP"]));
		currentPadState.set(Down, 
			virtualPad.buttonDown.status == FlxButton.PRESSED || FlxG.keys.anyPressed(["DOWN"]));
			
		currentPadState.set(A, 
			virtualPad.buttonA.status == FlxButton.PRESSED || FlxG.keys.anyPressed(["A", "Z"]));
		currentPadState.set(B, 
			virtualPad.buttonB.status == FlxButton.PRESSED || FlxG.keys.anyPressed(["S", "X"]));
		
		currentPadState.set(Start, 
			virtualPad.buttonStart.status == FlxButton.PRESSED || FlxG.keys.anyPressed(["ENTER"]));
		currentPadState.set(Select, 
			virtualPad.buttonSelect.status == FlxButton.PRESSED || FlxG.keys.anyPressed(["SPACE"]));*/
	}
	
	public static function checkButton(button : Int) : Bool
	{
		return MetaGamePad.Current.checkButton(button);
	}

	public static function justPressed(button : Int) : Bool
	{
		return MetaGamePad.Current.justPressed(button);
	}

	public static function justReleased(button : Int) : Bool
	{
		return MetaGamePad.Current.justReleased(button);
	}
	
	public static function resetInputs() : Void
	{
		initPadState();
	}
	
	private static function initPadState() : Void
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