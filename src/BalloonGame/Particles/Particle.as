package BalloonGame.Particles
{
	import adobe.utils.ProductManager;
	import BalloonGame.GameStates.*;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.GameRelated.*;
	/**
	 * ...
	 * @author Free
	 */
	public class Particle
	{
		public var DrawObject:Sprite;
		public var Velocity:b2Vec2;
		public var AngularVelocity:Number;
		public var Time:Number;
		public var Lifespan:Number;
		
		public function Particle(drawObject:Sprite, velocity:b2Vec2, angularVelocity:Number, lifespan:Number) 
		{
			// Graphics
			this.DrawObject = drawObject;
			
			// Physics
			this.Velocity = velocity;
			this.AngularVelocity = angularVelocity;
			
			this.Time = 0;
			this.Lifespan = lifespan;
		}
		
		public function Update(timeStep:Number) : void
		{
			DrawObject.x += Velocity.x * timeStep;
			DrawObject.y += Velocity.y * timeStep;
			DrawObject.rotation += AngularVelocity * timeStep;
			
			Velocity.Multiply(0.94);
			AngularVelocity *= 0.94;
			
			Time += timeStep * (1.0 / Lifespan);
		}
		
		public function Draw(screen:Sprite):void
		{
			DrawObject.alpha = (1 - Time) * 0.5;
		}
	}

}