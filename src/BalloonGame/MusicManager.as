package BalloonGame 
{
	import BalloonGame.Ingame.*
	import BalloonGame.GameStates.*
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class MusicManager 
	{
		private var music:SoundChannel;
		private var musicTag:String;
		private var lastState:Number;
		private var lastLevel:Number;
		
		public function MusicManager() 
		{
			
		}
		
		public function UpdateMusic(currentState:Number, currentLevel:Number) : void
		{
			if (currentState == StateManager.PLAYING)
			{
				if (currentLevel >= 0)
				{
					//SetMusic("technoLoop");
				}
			}
			else if(currentState == StateManager.MENU)
			{
				SetMusic("mysticalPrelude");
			}
			
			lastState = currentState;
			lastLevel = currentLevel;
		}
		
		private function SetMusic(name:String) : void
		{
			if (musicTag != name)
			{
				if (music != null)
				{
					music.stop();
				}
				
				musicTag = name;
				music = Main.Audio.PlaySound(name, 0, 100000);
                if (music != null)
                {
                    music.soundTransform = new SoundTransform(0.5);
                }
			}
		}
	}

}