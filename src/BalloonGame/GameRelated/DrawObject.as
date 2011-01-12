package BalloonGame.GameRelated 
{
	import BalloonGame.*;
	import BalloonGame.GameRelated.*;
	import Box2D.Dynamics.Joints.*;
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DrawObject 
	{
		public var sprite:Sprite;
		
		public var CanLoop:Boolean = false;
		private var stopOnOne:Boolean = false;
		
		public var OnLoop:Function;
		
		public function DrawObject(sprite:Sprite) 
		{
			this.sprite = sprite;
			
			Stop();
			
			sprite.addEventListener(Event.EXIT_FRAME, ExitFrame);
		}
		
		public function Play() : void
		{
			MovieClip(this.sprite).play();
		}
		
		public function Stop() : void
		{
			MovieClip(this.sprite).stop();
		}
		
		private function ExitFrame(event:Event) : void
		{
			var movieClip:MovieClip = MovieClip(this.sprite);
			if (movieClip.currentFrame == movieClip.totalFrames)
			{
				stopOnOne = true;
				
				if (OnLoop != null)
				{
					OnLoop();
				}
			}
			else if (movieClip.currentFrame == 1 && stopOnOne)
			{
				movieClip.stop();
				stopOnOne = false;
			}
		}
		
		public function Dispose() : void
		{
			sprite.removeEventListener(Event.EXIT_FRAME, ExitFrame);
		}
	}

}