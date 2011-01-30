package BalloonGame.GameRelated 
{
	import BalloonGame.*;
	import BalloonGame.GameRelated.*;
	import BalloonGame.Physics.PhysicsManager;
	import Box2D.Common.Math.b2Vec2;
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
		
		private var isMovieClip:Boolean = false;
		
		private var loop:Boolean = false;
		
		public function DrawObject(sprite:Sprite) 
		{
			this.sprite = sprite;
			
			if (sprite is MovieClip)
			{
				isMovieClip = true;
				Stop();
			}
			
			sprite.addEventListener(Event.EXIT_FRAME, ExitFrame);
		}
		
		public function SetPosition(position:b2Vec2) : void
		{
			this.sprite.x = position.x * PhysicsManager.Scale;
			this.sprite.y = position.y * PhysicsManager.Scale;
		}
		
		public function Play(loop:Boolean = false) : void
		{
			this.loop = loop;
			MovieClip(this.sprite).play();
		}
		
		public function Stop() : void
		{
			MovieClip(this.sprite).stop();
		}
		
		public function Reset() : void
		{
			MovieClip(this.sprite).gotoAndStop(0);
		}
		
		private function ExitFrame(event:Event) : void
		{
			if (isMovieClip )
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
					if (loop == false)
					{
						movieClip.stop();
					}
					stopOnOne = false;
				}
			}
		}
		
		public function Dispose() : void
		{
			sprite.removeEventListener(Event.EXIT_FRAME, ExitFrame);
		}
	}

}