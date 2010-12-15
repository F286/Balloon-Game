package BalloonGame.Screen 
{
	import BalloonGame.*;
	import flash.display.*;
	import BalloonGame.GameRelated.*;
	import BalloonGame.Particles.*;
	import BalloonGame.Physics.*;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Transistion 
	{
		private var transistion:MovieClip;
		
		[Embed(source='../Library/mainFlash.swf', symbol='transitionOut')]
		private var TransitionOut:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='transitionIn')]
		private var TransitionIn:Class;
		
		public var AnimationFinished:Boolean = false;
		
		public function Transistion(stage:Stage, type:String) 
		{
			if (type == "in")
			{
				transistion = new TransitionIn();
			}
			else if (type == "out")
			{
				transistion = new TransitionOut();
			}
				
			// Sets bitmap caching for alpha mask
			transistion["mask1"].cacheAsBitmap = true;
			transistion["checker1MC"].mask = transistion["mask1"];
			
			transistion["mask2"].cacheAsBitmap = true;
			transistion["checker2MC"].mask = transistion["mask2"];
			
			// Stops movie when done
			transistion.addEventListener(Event.EXIT_FRAME, OnExitFrame);
			
			// Add to the screen
			stage.addChild(transistion);
			
			//transistion.stage.quality = "medium";
		}
		
		private function OnExitFrame(event:Event) : void
		{
			//if (transistion.currentFrame == transistion.totalFrames - 2)
			//{
				//transistion.stage.quality = "high";
			//}
			if (transistion.currentFrame == transistion.totalFrames - 1)
			{
				transistion.stop();
				AnimationFinished = true;
			}
		}
		
		public function Dispose(stage:Stage) : void
		{
			stage.removeChild(transistion);
		}
	}

}