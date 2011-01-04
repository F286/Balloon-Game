package BalloonGame.GameStates 
{
	import flash.display.*;
	import BalloonGame.*;
	import BalloonGame.Screen.*;
	import BalloonGame.GameRelated.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class MenuState extends GameState
	{
		[Embed(source='../Library/mainFlash.swf', symbol='mainMenuScreen')]
		private var ScreenClass:Class;
		
		private var buttonList:Vector.<BasicButton>;
		
		public function MenuState(gameManager:GameManager)
		{
			super(gameManager);
			
			// Overlay
			screenOverlay = new ScreenClass();
			gameManager.AddStaticSprite(screenOverlay);
			
			// Buttons
			buttonList = new Vector.<BasicButton>();
			buttonList.push(new BasicButton(screenOverlay, "playButton", OnPlay));
			buttonList.push(new BasicButton(screenOverlay, "helpButton", OnHelp));
			//buttonList.push(new BasicButton(screenOverlay, "exitButton", OnExit));
		}
		
		private function OnPlay() : void
		{
			gameManager.SetGameState(StateManager.ENTERGAME);
			Main.Audio.PlaySound("shortKnife");
		}
		private function OnHelp() : void
		{
			gameManager.SetGameState(StateManager.HELP);
			Main.Audio.PlaySound("shortKnife");
		}
		//private function OnExit() : void
		//{
			//
		//}
		
		override public function Dispose():void 
		{
			super.Dispose();
			
			// Buttons
			for (var i:int = 0; i < buttonList.length; i++) 
			{
				buttonList[i].Dispose(screenOverlay);
			}
		}
	}
}