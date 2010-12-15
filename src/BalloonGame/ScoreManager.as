package BalloonGame 
{
	import flash.net.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class ScoreManager
	{
		public var Score:Number = 0;
		public var HighScore:Number = 0;
		
		public var ScoreAtCheckpoint:Number = 0;
		
		public var MoneyAtCheckpoint:Number = 0;
		public var Money:Number = 0;
		
		private var file:SharedObject;
		
		public function ScoreManager(resetDisk:Boolean = false) 
		{
			file = SharedObject.getLocal("balloonGame");
			
			if (resetDisk)
			{
				file.clear();
			}
			
			if (file.data.highScore == null)
			{
				file.data.highScore = 0;
			}
			
			this.HighScore = file.data.highScore;
		}
		
		public function Update(timeStep:Number) : void
		{
			
		}
		
		public function SaveScore() : void
		{
			if (this.HighScore < this.Score)
			{
				this.HighScore = this.Score;
				
				// Save to disk
				file.data.highScore = this.HighScore;
				file.flush();
			}
		}
		
		public function ResetStats(score:Number, money:Number) : void
		{
			this.Score = score;
			this.ScoreAtCheckpoint = score;
			this.Money = money;
			
			AtCheckpoint();
		}
		
		public function NextLevel() : void
		{
			if (Main.IsGameMode)
			{
				this.Money += Main.defaultMoneyLevelChange;
			}
		}
		
		public function AtCheckpoint() : void 
		{
			this.ScoreAtCheckpoint = this.Score;
			this.MoneyAtCheckpoint = this.Money;
		}
		
		public function LoadCheckpoint() : void 
		{
			this.Score = this.ScoreAtCheckpoint;
			this.Money = this.MoneyAtCheckpoint;
		}
		
		public function DecrementScore(timeStep:Number) : void
		{
			Score -= timeStep;
		}
		
	}

}