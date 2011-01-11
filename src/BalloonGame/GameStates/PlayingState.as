package BalloonGame.GameStates 
{
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import BalloonGame.*;
	import BalloonGame.Ingame.*;
	import BalloonGame.GameRelated.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class PlayingState extends GameState
	{
		[Embed(source='../Library/mainFlash.swf', symbol='playingScreen')]
		private var ScreenClass:Class;
		
        private var scoreBoxes:ScoreBoxes;
		
		public function PlayingState(gameManager:GameManager) 
		{
			super(gameManager);
			
			// Overlay
			screenOverlay = new ScreenClass();
			gameManager.AddStaticSprite(screenOverlay);
			
            // Enabled / Disabled
			gameManager.arrowManager.IsEnabled = true;
			gameManager.camera.OffsetEnabled = true;
            gameManager.IsIngame = true;
            
            // Score Boxes
            scoreBoxes = new ScoreBoxes(screenOverlay);
		}
		
		public override function Update(timeStep:Number) : void
		{
			super.Update(timeStep);
            
            // Update scores
            scoreBoxes.Update(timeStep);
			
			// Reset Level
			if (Input.IsKeyDown("r".charCodeAt()))
			{
				Main.scoreManager.LoadCheckpoint();
				gameManager.SetGameState(StateManager.RESETTHENBUILDING);
			}
            
			// Skip Level
			if (Input.IsKeyDown("o".charCodeAt()))
			{
                this.gameManager.player.Body.SetPosition(this.gameManager.ExitObjects[0].Body.GetPosition());
			}
		}
	}
}