package BalloonGame 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * ...
	 * @author Free
	 */
	public class AudioManager
	{
		[Embed(source = 'Library/mainFlash.swf', symbol = 'distortedSineHit')]
		private var DistortedSineHit:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'distortedExplosion')]
		private var DistortedExplosion:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'pop')]
		private var Pop:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'shortKnife')]
		private var ShortKnife:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'longKnife')]
		private var LongKnife:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'longBeep')]
		private var LongBeep:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'camera')]
		private var CameraS:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'thump')]
		private var Thump:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'mysticalPrelude')]
		private var MysticalPrelude:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'shortBlip')]
		private var ShortBlip:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'bigLaserShot')]
		private var BigLaserShot:Class;
		
		[Embed(source = 'Library/mainFlash.swf', symbol = 'laser')]
		private var Laser:Class;
		
		public function AudioManager() 
		{
			
		}
		
		public function PlaySound(name:String, startTime:Number = 0, loops:Number = 1) : SoundChannel
		{
			if (name == "distortedSineHit")
			{
				return PlaySoundFile(new DistortedSineHit(), startTime, loops);
			}
			else if (name == "distortedExplosion")
			{
				return PlaySoundFile(new DistortedExplosion(), startTime, loops);
			}
			else if (name == "pop")
			{
				return PlaySoundFile(new Pop(), startTime, loops);
			}
			else if (name == "shortKnife")
			{
				return PlaySoundFile(new ShortKnife(), startTime, loops);
			}
			else if (name == "longKnife")
			{
				return PlaySoundFile(new LongKnife(), startTime, loops);
			}
			else if (name == "longBeep")
			{
				return PlaySoundFile(new LongBeep(), startTime, loops);
			}
			else if (name == "camera")
			{
				return PlaySoundFile(new CameraS(), startTime, loops);
			}
			else if (name == "thump")
			{
				return PlaySoundFile(new Thump(), startTime, loops);
			}
			else if (name == "mysticalPrelude")
			{
				return PlaySoundFile(new MysticalPrelude(), startTime, loops);
			}
			else if (name == "shortBlip")
			{
				return PlaySoundFile(new ShortBlip(), startTime, loops);
			}
			else if (name == "bigLaserShot")
			{
				return PlaySoundFile(new BigLaserShot(), startTime, loops);
			}
			else if (name == "laser")
			{
				return PlaySoundFile(new Laser(), startTime, loops);
			}
			
			return null;
		}
		
		private function PlaySoundFile(sound:Sound, startTime:Number, loops:Number) : SoundChannel
		{
			return sound.play(startTime, loops);
		}
	}

}