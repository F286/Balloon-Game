package BalloonGame 
{
	import BalloonGame.GameObject;
	import BalloonGame.Main;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.CapsStyle;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.Physics.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class Bullet
	{
		public var IsDisposing:Boolean = false;
		public var DrawObject:Sprite;
		private var firedBullet:Boolean = false;
		
		private var impulse:Number;
		private var raycastManager:RaycastManager;
		
		private var callback:Function;
		
		private var bulletAlpha:Number = 1;
		
		private var p1:b2Vec2;
		private var p2:b2Vec2;
		
		public function Bullet(startPoint:b2Vec2, endPoint:b2Vec2, impulse:Number, callback:Function = null) 
		{
			this.raycastManager = new RaycastManager(startPoint, endPoint);
			this.impulse = impulse
			this.callback = callback;
			
			p1 = startPoint;
		}
		
		public function Update(timeStep:Number) : void
		{
			if (!firedBullet)
			{
				raycastManager.SendRaycast(OnRaycast);
			}
			
		}
		
		public function Draw(overlaySprite:Sprite):void 
		{
			bulletAlpha = Math.max(bulletAlpha - 0.05, 0);
			if (bulletAlpha == 0)
			{
				IsDisposing = true;
			}
			
			if (firedBullet)
			{
				// Bullet line
				overlaySprite.graphics.lineStyle(3, 0xFFFF00, 0.7 * bulletAlpha, false, "normal", CapsStyle.SQUARE);
				overlaySprite.graphics.moveTo(p1.x * PhysicsManager.Scale, p1.y * PhysicsManager.Scale); 
				overlaySprite.graphics.lineTo(p2.x * PhysicsManager.Scale, p2.y * PhysicsManager.Scale); 
			}
		}
		
		private function OnRaycast(body:b2Body, contactPoint:b2Vec2, direction:b2Vec2) : void
		{
			firedBullet = true;
			
			direction.Multiply(impulse);
			body.ApplyImpulse(direction, contactPoint);
			
			callback(body, contactPoint, direction);
			
			p2 = contactPoint;
		}
		
		public function OnDispose() : void
		{
			
		}
	}

}