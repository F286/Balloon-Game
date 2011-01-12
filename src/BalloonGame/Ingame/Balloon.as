package BalloonGame.Ingame
{
	import BalloonGame.GameRelated.*;
	import BalloonGame.Main;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
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
	public class Balloon extends ComplexGameObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='balloon')]
		private var BalloonSprite:Class;
		
		public var DistanceJoint:b2DistanceJoint;
		
		public function Balloon(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			// Creates the balloon sprite
			var sprite:MovieClip = new BalloonSprite();
			sprite.x = position.x * PhysicsManager.Scale;
			sprite.y = position.y * PhysicsManager.Scale;
			
			super(10, sprite, GameObject.BOX, 1);
				
			// Finds joint length
			var bodyPoint:b2Vec2 = attachBody.GetWorldPoint(attachPosition);
			var diff:b2Vec2 = new b2Vec2(position.x - bodyPoint.x, position.y - bodyPoint.y);
			var length:Number = Math.sqrt(diff.x * diff.x + diff.y * diff.y);
			
			// Creates joint
			var distanceJointDef:b2DistanceJointDef = new b2DistanceJointDef();
			distanceJointDef.bodyA = this.Body;
			distanceJointDef.bodyB = attachBody;
			distanceJointDef.localAnchorA = new b2Vec2(0, 0.5);
			distanceJointDef.localAnchorB = attachPosition;
			distanceJointDef.length = Math.max(0.01, length / 1.5);
			distanceJointDef.collideConnected = true;
			distanceJointDef.frequencyHz = 3;
			this.DistanceJoint = PhysicsManager.World.CreateJoint(distanceJointDef) as b2DistanceJoint;
			this.DistanceJoint.noMinDistance = true;
			
			this.OnDeath = OnPop;
		}
		
		public function OnPop() : void
		{
			this.drawObject.Play();
			this.drawObject.OnLoop = OnLoop;
			this.Body.SetActive(false);
					
			// Plays sound
			Main.Audio.PlaySound("distortedSineHit");
		}
		
		private function OnLoop() : void
		{
			IsDisposing = true;
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
            
            // Damping
            this.Body.SetAngularVelocity(this.Body.GetAngularVelocity() * 0.95);
            var linearVelocity:b2Vec2 = this.Body.GetLinearVelocity().Copy();
            linearVelocity.Multiply(0.98);
            this.Body.SetLinearVelocity(linearVelocity)
			
			// Lifting
			this.Body.ApplyImpulse(new b2Vec2(0, -0.054 / timeStep), this.Body.GetPosition());
			
		}
		
		override public function Draw(overlaySprite:Sprite):void 
		{
			super.Draw(overlaySprite);
			
			// Draws the "string" on joint
			if (DistanceJoint != null && !IsDisposing)
			{
				var anchorA:b2Vec2 = DistanceJoint.GetAnchorA().Copy();
				var anchorB:b2Vec2 = DistanceJoint.GetAnchorB().Copy();
					
				// Creates line repersenting joint
				overlaySprite.graphics.lineStyle(3, 0x000000, 0.6);
				overlaySprite.graphics.moveTo(anchorA.x * PhysicsManager.Scale, anchorA.y * PhysicsManager.Scale); 
				overlaySprite.graphics.lineTo(anchorB.x * PhysicsManager.Scale, anchorB.y * PhysicsManager.Scale); 
			}
		}
		
		override public function OnDispose() : void
		{
			super.OnDispose();
			
			PhysicsManager.World.DestroyJoint(DistanceJoint);
		}
	}

}