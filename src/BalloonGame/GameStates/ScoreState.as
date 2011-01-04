package BalloonGame.GameStates 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.*;
	
	import Box2D.Common.Math.*;
	
	import BalloonGame.*;
	import BalloonGame.Screen.*;
	import BalloonGame.GameRelated.*;
	import BalloonGame.Ingame.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class ScoreState extends GameState
	{
		[Embed(source = '../Library/mainFlash.swf', symbol = 'levelOverScreen')]
		private var ScreenClass:Class;
		
		private var scoreText:TextField;
		private var nextButton:BasicButton;
		
		public function ScoreState(gameManager:GameManager) 
		{
			super(gameManager);
			
			this.screenOverlay = new ScreenClass();
			gameManager.AddStaticSprite(this.screenOverlay);
			
			// Score Text
			scoreText = TextField(screenOverlay["scoreText"]);
			
			// Next button
			nextButton = new BasicButton(screenOverlay, "nextButton", NextButtonClick);
			
			// Sounds
			Main.Audio.PlaySound("camera");
		}
		
		private function NextButtonClick() : void
		{
			gameManager.SetGameState(StateManager.EXITGAME);
			Main.Audio.PlaySound("shortKnife");
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			// Level timer update
			scoreText.text = Main.scoreManager.Score.toFixed(1).toString();
            var scoreTextFormat:TextFormat = new TextFormat(null, null, null, true);
            scoreTextFormat.letterSpacing = -2;
			scoreText.setTextFormat(scoreTextFormat);
		}
		
		override public function Dispose():void 
		{
			super.Dispose();
			
			//gameManager.Reset();
		}
	}

}