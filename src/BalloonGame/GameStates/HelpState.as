package BalloonGame.GameStates 
{
	import BalloonGame.GameRelated.PlayerGun;
	import Box2D.Common.Math.*;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import BalloonGame.*;
	import flash.events.*;
	import flash.text.*;
	
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
		
		public function HelpState(gameplay:Gameplay) 
		{
			super(gameplay);
			
			// Overlay
			screenOverlay = new ScreenClass();
			gameplay.AddStaticSprite(screenOverlay);
			
			// Buttons
			backButton = new BasicButton(screenOverlay, "backButton", OnBack);
			resetButton = new BasicButton(screenOverlay, "resetButton", OnReset);
		}
		
		public function OnBack() : void
		{
			gameplay.SetGameState(StateManager.MENU);
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










