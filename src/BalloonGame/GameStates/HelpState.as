package BalloonGame.GameStates 
{
	import Box2D.Common.Math.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import BalloonGame.*;
	import BalloonGame.Screen.*;
	import BalloonGame.GameRelated.*;
	import BalloonGame.Ingame.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class HelpState extends GameState
	{
		[Embed(source='../Library/mainFlash.swf', symbol='helpScreen')]
		private var ScreenClass:Class;
		
		private var backButton:BasicButton;
		private var resetButton:BasicButton;
		
		public function HelpState(gameManager:GameManager) 
		{
			super(gameManager);
			
			// Overlay
			screenOverlay = new ScreenClass();
			gameManager.AddStaticSprite(screenOverlay);
			
			// Buttons
			backButton = new BasicButton(screenOverlay, "backButton", OnBack);
			resetButton = new BasicButton(screenOverlay, "resetButton", OnReset);
		}
		
		public function OnBack() : void
		{
			gameManager.SetGameState(StateManager.MENU);
			Main.Audio.PlaySound("longKnife");
		}
		
		public function OnReset() : void
		{
			Main.scoreManager = new ScoreManager(true);
		}
		
		override public function Dispose():void 
		{
			super.Dispose();
			
			// Button
			backButton.Dispose(screenOverlay);
		}
	}

}










