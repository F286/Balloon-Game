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
	public class AttachObject extends GameObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='rapidGun')]
		private var GunSprite:Class;
		
        protected var attachP:b2Vec2;
        protected var attachB:b2Body;
		
		protected var deltaCooldown:Number = 100;
		protected var coolDown = 1;
		
		public function AttachObject(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			// Creates the sprite
			var sprite:MovieClip = new GunSprite();
			sprite.x = position.x * PhysicsManager.Scale;
			sprite.y = position.y * PhysicsManager.Scale;
			
			super(sprite, GameObject.BOX, 5, -1);
			
			// Set damping
			this.Body.SetLinearDamping(0.6);
			this.Body.SetAngularDamping(1.0);
            
            this.attachP = attachPosition;
            this.attachB = attachBody;
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			deltaCooldown += timeStep;
            
            this.Body.SetPosition(attachB.GetWorldPoint(attachP));
			this.Body.SetLinearVelocity(new b2Vec2(0, 0));
			this.Body.SetAngularVelocity(0);
		}
		
		public function CanFire() : Boolean
		{
   			if (deltaCooldown > coolDown)
			{
				return true;
			}
			return false;
		}
		
		public function Fire(callback:Function) : Bullet
		{
			deltaCooldown = 0;
				
			var direction:b2Vec2 = Body.GetWorldVector(new b2Vec2(0, 0))
			attachB.ApplyImpulse(direction, this.Body.GetPosition());
			
			this.drawObject.Play();
			
			// Creates the bullet
			var start:b2Vec2 = Body.GetWorldPoint(new b2Vec2(0, 0));
			var end:b2Vec2 = start.Copy();
			end.Add( Body.GetWorldVector(new b2Vec2(0, -1000)) );
			return new Bullet(start, end, 0, 5, callback);
			
			// Sound
			//Main.Audio.PlaySound("bigLaserShot");
		}
		
		public function UpdateAim(target:b2Vec2) : void
		{
			// Turret to Target
			var diff:b2Vec2 = target;
			diff.Subtract(this.Body.GetPosition());
			
			var angle:Number = Math.atan2(diff.x, -diff.y);
			this.Body.SetAngle(angle);
		}
	}
}