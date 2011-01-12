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
	
	/**
	 * ...
	 * @author Free
	 */
	public class Thruster extends GameObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='thruster')]
		private var ThrusterSprite:Class;
		private var stopOnOne:Boolean = false;
		
		public var DistanceJoint:b2DistanceJoint;
		private var jointDestroyed:Boolean = false;
        
        private var attachP:b2Vec2;
        private var attachB:b2Body;
		
		private var cooldown:Number = 100;
		
		public function Thruster(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			// Creates the balloon sprite
			var bSprite:MovieClip = new ThrusterSprite();
			bSprite.x = position.x * PhysicsManager.Scale;
			bSprite.y = position.y * PhysicsManager.Scale;
			bSprite.stop();
			bSprite.addEventListener(Event.EXIT_FRAME, ExitFrame);
			
			super(bSprite, GameObject.BOX, 5);
			
			// Sets damping on thruster
			this.Body.SetLinearDamping(0.6);
			this.Body.SetAngularDamping(1.0);
			
			// Finds joint length
			var bodyPoint:b2Vec2 = attachBody.GetWorldPoint(attachPosition);
			var diff:b2Vec2 = new b2Vec2(position.x - bodyPoint.x, position.y - bodyPoint.y);
			var length:Number = Math.sqrt(diff.x * diff.x + diff.y * diff.y);
			
			// Creates joint
			var distanceJointDef:b2DistanceJointDef = new b2DistanceJointDef();
			distanceJointDef.bodyA = this.Body;
			distanceJointDef.bodyB = attachBody;
			//distanceJointDef.localAnchorA = new b2Vec2(0, 0.5);
			distanceJointDef.localAnchorB = attachPosition;
			distanceJointDef.length = 0.0;
			distanceJointDef.frequencyHz = 1;
			distanceJointDef.dampingRatio = 0.1;
			distanceJointDef.collideConnected = false;
			this.DistanceJoint = PhysicsManager.World.CreateJoint(distanceJointDef) as b2DistanceJoint;
			this.DistanceJoint.noMinDistance = true;
			
			this.Body.GetFixtureList().SetSensor(true);
            
            this.attachP = attachPosition;
            this.attachB = attachBody;
		}
		
		private function ExitFrame(event:Event) : void
		{
			var movieClip:MovieClip = MovieClip(this.DrawObject);
			if (movieClip.currentFrame == movieClip.totalFrames)
			{
				stopOnOne = true;
			}
			else if (movieClip.currentFrame == 1 && stopOnOne)
			{
				movieClip.stop();
				stopOnOne = false;
			}
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			cooldown += timeStep;
			
			var aV:Number = this.Body.GetAngularVelocity();
			this.Body.SetAngularVelocity(aV * 0.95);
            
            this.Body.SetPosition(attachB.GetWorldPoint(attachP));
			this.Body.SetLinearVelocity(new b2Vec2(0, 0));
			this.Body.SetAngularVelocity(0);
		}
		
		public function CanFire() : Boolean
		{
   			if (cooldown > 0.15)
			{
				return true;
			}
			return false;
		}
		
		public function ApplyThrust() : void
		{
			cooldown = 0;
				
			var direction:b2Vec2 = Body.GetWorldVector(new b2Vec2(0, -1.5))
			
			if (!jointDestroyed)
			{
				DistanceJoint.GetBodyB().ApplyImpulse(direction, this.Body.GetPosition());
			}
			
			MovieClip(this.DrawObject).play();
		}
		
		public function UpdateAim(dir:b2Vec2, inWorldSpace:Boolean = false) : void
		{
			if (inWorldSpace)
			{
				dir.Subtract(this.Body.GetPosition());
				dir.y *= -1;
			}
			
			var angle:Number = this.Body.GetAngle();
			
			var currentAngle:b2Vec2 = new b2Vec2(Math.sin(angle), Math.cos(angle));
			var perpDir:b2Vec2 = new b2Vec2(-dir.y, dir.x);
			
			var dot:Number = currentAngle.x * perpDir.x + currentAngle.y * perpDir.y;
			
			if (dot > 0)
			{
				angle += 0.2;
			}
			else 
			{
				angle -= 0.2;
			}
			
			this.Body.SetAngle(angle);
			
		}
		
		override public function OnDispose() : void
		{
			super.OnDispose();
			
			PhysicsManager.World.DestroyJoint(DistanceJoint);
		}
		
		override public function Draw(overlaySprite:Sprite):void 
		{
			super.Draw(overlaySprite);
		}
	}
}