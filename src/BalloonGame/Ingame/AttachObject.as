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
        protected var attachP:b2Vec2;
        protected var attachB:b2Body;
		
		protected var deltaCooldown:Number = 100;
		protected var coolDown:Number = 1;
		
		protected var instantAim:Boolean = true;
		
		public function AttachObject(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2, sprite:Sprite, shapeType:Number = GameObject.BOX, density:Number = 10)
		{
			// Sets position of sprite
			sprite.x = position.x * PhysicsManager.Scale;
			sprite.y = position.y * PhysicsManager.Scale;
			
			super(sprite, shapeType, density, -1);
			
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
			
			return null;
		}
		
		public function UpdateAim(dir:b2Vec2, inWorldSpace:Boolean = false) : void
		{
				
			if (instantAim == true)
			{
				// Turret to Target
				var diff:b2Vec2 = dir;
				
				if (inWorldSpace)
				{
					diff.Subtract(this.Body.GetPosition());
				}
				
				var angle2:Number = Math.atan2(diff.x, -diff.y);
				this.Body.SetAngle(angle2);
			}
			else 
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
		}
	}
}