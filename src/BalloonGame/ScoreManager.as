package BalloonGame 
{
	import flash.net.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class ScoreManager
	{
		public var Score:Number;
		public var HighScore:Number;
		
		public var ScoreAtCheckpoint:Number;
		
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
				file.data.highScore = Number.POSITIVE_INFINITY;
			}
			
			this.HighScore = file.data.highScore;
		}
		
		public function Update(timeStep:Number) : void
		{
			
		}
		
		public function SaveScore() : void
		{
			if (this.Score < this.HighScore)
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
		
		public function IncrementScore(timeStep:Number) : void
		{
			Score += timeStep;
		}
		
	}

}