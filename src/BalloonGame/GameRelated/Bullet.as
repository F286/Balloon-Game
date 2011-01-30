package BalloonGame.GameRelated 
{
	import BalloonGame.*;
	import BalloonGame.GameRelated.*;
	import Box2D.Dynamics.Joints.*
	import flash.display.*;
	import flash.events.*;
	
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
		public var drawObject:Sprite;
		private var firedBullet:Boolean = false;
		
		private var impulse:Number;
		private var raycastManager:RaycastManager;
		
		private var callback:Vector.<Function>;
		
		private var bulletAlpha:Number = 1;
		
		private var p1:b2Vec2;
		private var p2:b2Vec2;
		
		public var damage:Number;
		
		private var color:uint;
		private var durationSubtract:Number;
		
		public function Bullet(startPoint:b2Vec2, endPoint:b2Vec2, impulse:Number, damage:Number, callback:Function = null, color:uint = 0xFFFF00, duration:Number = 0.33) 
		{
			this.raycastManager = new RaycastManager(startPoint, endPoint);
			this.impulse = impulse
			this.callback = new Vector.<Function>();
			this.callback.push(callback);
			//this.callback = callback;
			this.damage = damage;
			
			this.p1 = startPoint;
			
			this.color = color;
			this.durationSubtract = 1 / (duration * 60);
		}
		
		public function AddCallback(add:Function) : void
		{
			this.callback.push(add);
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
			bulletAlpha = Math.max(bulletAlpha - durationSubtract, 0);
			if (bulletAlpha == 0)
			{
				IsDisposing = true;
			}
			
			if (firedBullet)
			{
				// Bullet line
				overlaySprite.graphics.lineStyle(3, color, 0.7 * bulletAlpha, false, "normal", CapsStyle.SQUARE);
				overlaySprite.graphics.moveTo(p1.x * PhysicsManager.Scale, p1.y * PhysicsManager.Scale); 
				overlaySprite.graphics.lineTo(p2.x * PhysicsManager.Scale, p2.y * PhysicsManager.Scale); 
			}
		}
		
		private function OnRaycast(body:b2Body, contactPoint:b2Vec2, direction:b2Vec2) : void
		{
			firedBullet = true;
			
			direction.Multiply(impulse);
			body.ApplyImpulse(direction, contactPoint);
			
			for each (var funct:Function in callback)
			{
				funct(this, body, contactPoint, direction);
			}
			
			p2 = contactPoint;
			
			if (body.GetUserData() is ComplexGameObject)
			{
				ComplexGameObject(body.GetUserData()).DamageTaken += damage;
			}
		}
		
		public function OnDispose() : void
		{
			
		}
	}

}