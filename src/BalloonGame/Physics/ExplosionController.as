package BalloonGame.Physics 
{
	import BalloonGame.GameRelated.ComplexGameObject;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.Sprite;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ExplosionController 
	{
		private var position:b2Vec2;
		private var damage:Number;
		private var radius:Number;
		private var impulse:Number;
		private var duration:Number;
		
		private var deltaDuration:Number;
		private var callback:Function;
		
		public function ExplosionController(position:b2Vec2, damage:Number = 0, callback:Function = null, radius:Number = 3.5, impulse:Number = 1200, duration:Number = 0.0) 
		{
			this.position = position;
			this.damage = damage;
			this.radius = radius;
			this.impulse = impulse;
			this.duration = duration;
			
			this.deltaDuration = 0;
			this.callback = callback;
		}
		
		public function Update(world:b2World, timeStep:Number) : void
		{
			deltaDuration += timeStep;
			
			var radiusSquared:Number = radius * radius;
			
			var body:b2Body = world.GetBodyList();
			while (body != null)
			{
				var diff:b2Vec2 = body.GetPosition().Copy();
				diff.Subtract(position);
				
				if (diff.LengthSquared() != 0 &&  diff.LengthSquared() < radiusSquared)
				{
					var intensity:Number = Math.max((radius - diff.Length()) / radius, 0);
					diff.Normalize();
					diff.Multiply(impulse * intensity);
					body.ApplyImpulse(diff, position.Copy());
					
					if (body.GetUserData() is ComplexGameObject)
					{
						ComplexGameObject(body.GetUserData()).DamageTaken += damage;
					}
					if (callback != null)
					{
						callback(body.GetUserData());
					}
				}
				
				body = body.GetNext();
			}
		}
		
		public function CanDispose() : Boolean
		{
			if (deltaDuration > duration)
			{
				return true;
			}
			return false;
		}
	}

}