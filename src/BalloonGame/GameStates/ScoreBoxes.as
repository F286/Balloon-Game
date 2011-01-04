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
     * @author Robin
     */
    public class ScoreBoxes
    {
		private var scoreText:TextField;
		private var highestText:TextField;
        
        
        public function ScoreBoxes(screenOverlay:Sprite) 
        {
			// Level timer
			scoreText = TextField(screenOverlay["scoreBoxes"]["timerText"]);
			highestText = TextField(screenOverlay["scoreBoxes"]["highestText"]);
        }
        
		public  function Update(timeStep:Number) : void
		{
            // Current time update
			scoreText.text = Main.scoreManager.Score.toFixed(1).toString();
            var scoreTextFormat:TextFormat = new TextFormat(null, null, null, true);
            scoreTextFormat.letterSpacing = -2;
			scoreText.setTextFormat(scoreTextFormat);
			scoreText.antiAliasType = "ADVANCED";
			
			// High Score update
            if (Main.scoreManager.HighScore == Number.POSITIVE_INFINITY)
            {
                highestText.text = "---";
            }
            else 
            {
                highestText.text = Main.scoreManager.HighScore.toFixed(1).toString();
            }
			highestText.setTextFormat(new TextFormat(null, null, null, true));
			highestText.antiAliasType = "ADVANCED";
        }
        
    }

}