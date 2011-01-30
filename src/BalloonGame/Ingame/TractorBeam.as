package BalloonGame.Ingame
{
	import BalloonGame.*;
	import BalloonGame.GameRelated.*;
	import Box2D.Dynamics.Joints.*;
	import flash.display.*;
	import flash.events.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.Physics.*;
	
	// Greensock
	import com.greensock.*; 
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class TractorBeam extends AttachObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='tractorBeam')]
		private var GunSprite:Class;
		
		public var IsTractorBeamActive:Boolean = false;
		
		private var activeBody:b2Body;
		private var activeAttachPoint:b2Vec2;
		
		private var lastMouse:b2Vec2;
		
		public function TractorBeam(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			super(position, attachBody, attachPosition, new GunSprite(), GameObject.BOX, 5);
			
			this.drawObject.Play(true);
			
			this.coolDown = 0.03;
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
		}
		
		public override function Fire(callback:Function) : Bullet
		{
			super.Fire(callback);
			
			IsTractorBeamActive = true;
			
			// Sound
			//Main.Audio.PlaySound("bigLaserShot");
				
			//var direction:b2Vec2 = Body.GetWorldVector(new b2Vec2(0, 0))
			//attachB.ApplyImpulse(direction, this.Body.GetPosition());
			
			// Find start / end points of raycast
			var start:b2Vec2 = Body.GetWorldPoint(new b2Vec2(0, 0));
			var end:b2Vec2 = start.Copy();
			end.Add( Body.GetWorldVector(new b2Vec2(0, -1000)) );
			
			// Creates the bullet
			var bullet:Bullet = new Bullet(start, end, 0, 0, callback, 0x0099ff, 0.2);
			bullet.AddCallback(OnBulletHit);
			
			return bullet;
			
				//TweenMax.to(GameObject(body.GetUserData()).drawObject.sprite, 0.5, {colorMatrixFilter:{hue:100}, yoyo:true, repeat:1, repeatDelay:0.4});
		}
		
		private function OnBulletHit(bullet:Bullet, body:b2Body, contactPoint:b2Vec2, direction:b2Vec2) : void
		{
			if (body.GetMass() != 0 && body != null)
			{
				this.activeAttachPoint = body.GetLocalPoint(contactPoint);
				this.activeBody = body;
				
				TweenMax.to(this.drawObject.sprite, 0.3, {glowFilter:{color:0x0099ff, alpha:1, blurX:24, blurY:24, strength:2.0}});
			}
			else
			{
				this.activeAttachPoint = null;
				this.activeBody = null;
				IsTractorBeamActive = false;
			}
		}
		
		public function UpdateTractorBeam(mouse:b2Vec2) : void
		{
			deltaCooldown = 0;
			
			//if(activeBody != null && activeBody.get)
			//{
				// Find impulse to pull body
				var pullDirection:b2Vec2 = activeBody.GetWorldPoint(activeAttachPoint);
				pullDirection.Subtract(mouse);
				pullDirection.Normalize();
				pullDirection.Multiply(-0.18 * activeBody.GetMass());
				
				// Apply the tractor beam
				activeBody.ApplyImpulse(pullDirection, activeBody.GetWorldPoint(activeAttachPoint));
				
				// Save mouse for drawing
				this.lastMouse = mouse;
			//}
			//else
			//{
				//IsTractorBeamActive = false;
			//}
		}
		
		override public function Draw(overlaySprite:Sprite):void 
		{
			super.Draw(overlaySprite);
			
			if (IsTractorBeamActive && activeBody != null && lastMouse != null)
			{
				var p1:b2Vec2 = activeBody.GetWorldPoint(activeAttachPoint);
				var p2:b2Vec2 = lastMouse;
				
				// Draw tractor beam line
				overlaySprite.graphics.lineStyle(3, 0xFFFFFF, 0.11, false, "normal", CapsStyle.SQUARE);
				overlaySprite.graphics.moveTo(p1.x * PhysicsManager.Scale, p1.y * PhysicsManager.Scale); 
				overlaySprite.graphics.lineTo(p2.x * PhysicsManager.Scale, p2.y * PhysicsManager.Scale); 
			}
		}
		
		public function DisableTractorBeam() : void
		{
			if (IsTractorBeamActive == true)
			{
				TweenMax.to(this.drawObject.sprite, 0.4, { glowFilter: { alpha:0 }} );
			}
			IsTractorBeamActive = false;
			
			this.activeAttachPoint = null;
			this.activeBody = null;
		}
		
	}
}