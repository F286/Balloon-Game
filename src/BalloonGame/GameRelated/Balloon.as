package BalloonGame.GameRelated
{
	import BalloonGame.GameObject;
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
	public class Balloon extends GameObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='balloon')]
		private var BalloonSprite:Class;
		
		public var DistanceJoint:b2DistanceJoint;
		
		public function Balloon(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			// Creates the balloon sprite
			var bSprite:MovieClip = new BalloonSprite();
			bSprite.x = position.x * PhysicsManager.Scale;
			bSprite.y = position.y * PhysicsManager.Scale;
			bSprite.stop();
			bSprite.addEventListener(Event.EXIT_FRAME, ExitFrame);
			
			super(bSprite, GameObject.BOX, 1);
			
			// Sets damping on balloon
			this.Body.SetLinearDamping(0.05);
			this.Body.SetAngularDamping(0.15);
				
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
			
			// Adds contact event
			this.AddContactEvent(OnContact);
		}
		
		private function ExitFrame(event:Event) : void
		{
			// Delete the balloon when the animation finishes
			var movieClip:MovieClip = MovieClip(this.DrawObject);
			if (movieClip.currentFrame == movieClip.totalFrames)
			{
				movieClip.removeEventListener(Event.EXIT_FRAME, ExitFrame);
				IsDisposing = true;
			}
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			// Lifting
			this.Body.ApplyImpulse(new b2Vec2(0, -0.05 / timeStep), this.Body.GetPosition());
		}
		
		override public function OnDispose() : void
		{
			super.OnDispose();
			
			PhysicsManager.World.DestroyJoint(DistanceJoint);
		}
		
		override public function Draw(overlaySprite:Sprite):void 
		{
			super.Draw(overlaySprite);
			
			// Draws the "string" on joint
			if (DistanceJoint != null && !IsDisposing)
			{
				var anchorA:b2Vec2 = DistanceJoint.GetAnchorA();
				var anchorB:b2Vec2 = DistanceJoint.GetAnchorB();
					
				// Creates line repersenting joint
				overlaySprite.graphics.lineStyle(2, 0x000000, 0.6);
				overlaySprite.graphics.moveTo(anchorA.x * PhysicsManager.Scale, anchorA.y * PhysicsManager.Scale); 
				overlaySprite.graphics.lineTo(anchorB.x * PhysicsManager.Scale, anchorB.y * PhysicsManager.Scale); 
			}
		}
		
		public function Pop() : void
		{
			MovieClip(this.DrawObject).play();
			this.Body.SetActive(false);
					
			// Plays sound
			Main.Audio.PlaySound("distortedSineHit");
		}
		
		private function OnContact(a:GameObject, b:GameObject, contactInfo:ContactInfo) : void
		{
			if (b is Obstacle)
			{
				Pop();
			}
		}
	}

}