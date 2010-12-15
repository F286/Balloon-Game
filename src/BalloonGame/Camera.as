package BalloonGame 
{
	import Box2D.Common.Math.*;
	import Box2D.Common.*;
	import Box2D.Dynamics.*;
	import flash.display.Sprite;

	import Box2D.Common.b2internal;
	use namespace b2internal;
	
	import BalloonGame.Physics.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class Camera
	{
		private var position:b2Vec2;
		private var velocity:b2Vec2;
		private var target:b2Vec2;
		
		private var screenSize:b2Vec2;
		
		public function Camera(screenSize:b2Vec2) 
		{
			this.screenSize = screenSize;
			
			position = new b2Vec2(0, 0);
			velocity = new b2Vec2(0, 0);
			target = new b2Vec2(0, 0);
		}
		
		public function Update(timeStep:Number) : void
		{
			// Spring
			var diff:b2Vec2 = target;
			diff.Subtract(position);
			diff.Multiply(0.05);
			velocity.Add(diff);
			
			// Update position
			position.Add(velocity);
			
			// Damping
			velocity.Multiply(0.8);
		}
		
		public function UpdateDraw(overlaySprite:Sprite) : void
		{
			// Update screen
			overlaySprite.x = position.x * PhysicsManager.Scale * -1 + screenSize.x / 2;
			overlaySprite.y = position.y * PhysicsManager.Scale * -1 + screenSize.y / 2;
		}
		
		public function UpdateTarget(setTo:b2Vec2) : void
		{
			this.target = new b2Vec2(setTo.x, setTo.y);
		}
	}

}