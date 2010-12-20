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
		
		public function ScoreState(gameplay:Gameplay) 
		{
			super(gameplay);
			
			this.screenOverlay = new ScreenClass();
			gameplay.AddStaticSprite(this.screenOverlay);
			
			// Score Text
			scoreText = TextField(screenOverlay["scoreText"]);
			
			// Next button
			nextButton = new BasicButton(screenOverlay, "nextButton", NextButtonClick);
			
			// Sounds
			Main.Audio.PlaySound("camera");
		}
		
		private function NextButtonClick() : void
		{
			gameplay.SetGameState(StateManager.EXITGAME);
			Main.Audio.PlaySound("shortKnife");
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			// Level timer update
			var score:Number = Math.round(Main.scoreManager.Score);
			scoreText.text = score.toString()
			scoreText.setTextFormat(new TextFormat(null, null, null, true));
		}
		
		override public function Dispose():void 
		{
			super.Dispose();
			
			//gameplay.Reset();
		}
	}

}