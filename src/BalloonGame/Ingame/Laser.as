package BalloonGame.Ingame 
{
	import BalloonGame.GameRelated.*;
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
	import flash.media.SoundChannel;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.Physics.*;
	
	
	public class Laser extends GameObject
	{
		//public var Position:b2Vec2;
		public var LaserDraw:Sprite;
		
		private var raycastManager:RaycastManager;
		
		public var Enabled:Boolean = true;
		public var EnableTimer:Number = 0;
		
		private var p1:b2Vec2;
		private var p2:b2Vec2;
		
		public var OnTime:Number;
		public var OffTime:Number;
		
		private var brightLaser:Number = 0;
		
		private var laserSound:SoundChannel;
		
		public static var LaserSoundDelay:Number = 0;
		
		public function Laser(drawObject:Sprite, onTime:Number = 1.2, offTime:Number = 2.0) 
		{
			super(drawObject, GameObject.BOX, 0);
			
			this.OnTime = onTime;
			this.OffTime = offTime;
			
			p1 = this.Body.GetWorldPoint(new b2Vec2(0, -0.3));
			p2 = this.Body.GetWorldPoint(new b2Vec2(0, -100));
			raycastManager = new RaycastManager(p1, p2);
		}
		
		
		public override function Update(timeStep:Number) : void
		{
			super.Update(timeStep);
			
			// Turns on / off
			EnableTimer += timeStep
			if (EnableTimer > ((Enabled) ? OnTime : OffTime))
			{
				EnableTimer = 0;
				Enabled = !Enabled;
				
				if (Enabled)
				{
					if (laserSound == null && OffTime != 0 && LaserSoundDelay > 0.1)
					{
						LaserSoundDelay = 0;
						Main.Audio.PlaySound("laser");
					}
				}
			}
			
			var hitObject:Boolean = raycastManager.SendRaycast(OnRaycast);
			
			if (!hitObject)
			{
				p2 = raycastManager.P2;
			}
		}
		
		private function OnRaycast(body:b2Body, contactPoint:b2Vec2, direction:b2Vec2) : void
		{
			// Sets for drawing
			p2 = contactPoint;
			
			if (Enabled)
			{
				// Pops balloons
				if (body.GetUserData() is Balloon)
				{
					var balloon:Balloon = Balloon(body.GetUserData());
					balloon.Pop();
				}
			}
		}
		
		public override function Draw(overlaySprite:Sprite):void 
		{
			super.Draw(overlaySprite);
			
			var tillOn:Number = EnableTimer / OffTime;
			if (Enabled)
			{
				tillOn = 1;
			}
			
			// Background line
			overlaySprite.graphics.lineStyle(6, 0xFF0000, 0.22 * tillOn, false, "normal", CapsStyle.SQUARE);
			overlaySprite.graphics.moveTo(p1.x * PhysicsManager.Scale, p1.y * PhysicsManager.Scale); 
			overlaySprite.graphics.lineTo(p2.x * PhysicsManager.Scale, p2.y * PhysicsManager.Scale); 
			
			if (Enabled)
			{
				brightLaser = Math.min(brightLaser + 0.1, 1);
			}
			else 
			{
				brightLaser = Math.max(brightLaser - 0.1, 0);
			}
			
			if (brightLaser > 0)
			{
				// Laser beam line
				overlaySprite.graphics.lineStyle(3, 0xFF0000, 0.7 * brightLaser, false, "normal", CapsStyle.SQUARE);
				overlaySprite.graphics.moveTo(p1.x * PhysicsManager.Scale, p1.y * PhysicsManager.Scale); 
				overlaySprite.graphics.lineTo(p2.x * PhysicsManager.Scale, p2.y * PhysicsManager.Scale); 
			}
		}
		
	}
}