package BalloonGame.Screen 
{
	import Box2D.Common.Math.*;
	import Box2D.Common.*;
	import Box2D.Dynamics.*;
	import flash.display.*;

	//import Box2D.Common.b2internal;
	//use namespace b2internal;
	
	import BalloonGame.Physics.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class ScreenCamera
	{
		private var target:b2Vec2;
		private var position:b2Vec2;
		private var velocity:b2Vec2;
		
		private var targetOffset:b2Vec2;
		public var offset:b2Vec2;
		private var velocityOffset:b2Vec2;
		
		public var screenSize:b2Vec2;
		
		public var OffsetEnabled:Boolean = false;
		
		public function ScreenCamera(screenSize:b2Vec2) 
		{
			this.screenSize = screenSize;
			
			target = new b2Vec2(0, 0);
			position = new b2Vec2(0, 0);
			velocity = new b2Vec2(0, 0);
			
			targetOffset = new b2Vec2(0, 0);
			offset = new b2Vec2(0, 0);
			velocityOffset = new b2Vec2(0, 0);
		}
		
		public function Update(timeStep:Number) : void
		{
			// Spring
			var diff:b2Vec2 = target.Copy();
			diff.Subtract(position);
			diff.Multiply(0.05);
			velocity.Add(diff);
			
			var diff2:b2Vec2 = targetOffset.Copy();
			diff2.Subtract(offset);
			diff2.Multiply(0.5);
			velocityOffset.Add(diff2);
			
			// Update position
			position.Add(velocity);
			offset.Add(velocityOffset);
			
			// Damping
			velocity.Multiply(0.8);
			offset.Multiply(0.2);
		}
		
		public function UpdateDraw(overlaySprite:Sprite) : void
		{
			var drawPosition:b2Vec2 = position.Copy();
			if (OffsetEnabled)
			{
				drawPosition.Add(offset);
			}
			
			// Update screen
			overlaySprite.x = drawPosition.x * PhysicsManager.Scale * -1 + screenSize.x / 2;
			overlaySprite.y = drawPosition.y * PhysicsManager.Scale * -1 + screenSize.y / 2;
		}
		
		public function UpdateTarget(setTo:b2Vec2) : void
		{
			this.target = setTo.Copy();
		}
		
		public function UpdateTargetOffset(setTo:b2Vec2) : void
		{
			this.targetOffset = setTo.Copy();
		}
		
		public function FindTargetOffset(scaleToScreen:Boolean = false) : b2Vec2
		{
			var diff:b2Vec2 = target.Copy();
			diff.Subtract(position);
			//diff.Add(positionOffset);
			if (scaleToScreen)
			{
				diff.Multiply(PhysicsManager.Scale);
			}
			return diff;
		}
	}

}