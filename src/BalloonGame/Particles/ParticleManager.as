package BalloonGame.Particles
{
	import BalloonGame.GameStates.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.Physics.*;
	import BalloonGame.Ingame.*;
	import BalloonGame.*;
	import BalloonGame.GameRelated.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class ParticleManager
	{
		[Embed(source='../Library/mainFlash.swf', symbol='particle1')]
		private var particle1:Class;
		
		public var Particles:Vector.<Particle>;
		
		private var gamemanager:GameManager;
		
		public static var MaxParticles:int = 30;
		
		public function ParticleManager(gamemanager:GameManager) 
		{
			this.gamemanager = gamemanager;
			
			Particles = new Vector.<Particle>();
		}
		
		public function Update(timeStep:Number) : void
		{
			for (var i:int = 0; i < Particles.length; i++) 
			{
				Particles[i].Update(timeStep);
				
				if (Particles[i].Time >= 1)
				{
					gamemanager.RemoveSprite(Particles[i].DrawObject);
					Particles.splice(i, 1);
					i--;
				}
			}
		}
		
		public function Draw(screen:Sprite):void
		{
			for each (var p:Particle in Particles)
			{
				p.Draw(screen);
			}
		}
		
		public function AddElectricSparks(position:b2Vec2, count:Number = 1, intensity:Number = 1) : void 
		{
			for (var i:int = 0; i < count; i++) 
			{
				var sprite:Sprite = new particle1();
				sprite.blendMode = "difference";
				
				var velocity:b2Vec2 = Helper.GetRandomV(4 * intensity);
				var angle:Number = Helper.GetRandom(0, 360);
				var angularVelocity:Number = Helper.GetRandomN(400);
				
				AddParticle(position.Copy(), velocity.Copy(), angle, angularVelocity, sprite, 0.8);
			}
		}
		
		public function AddSparks(position:b2Vec2, count:Number = 1, blendMode:String = "hardlight") : void 
		{
			for (var i:int = 0; i < count; i++) 
			{
				var sprite:Sprite = new particle1();
				sprite.blendMode = blendMode;
				
				var velocity:b2Vec2 = Helper.GetRandomV(3);
				var angle:Number = Helper.GetRandom(0, 360);
				var angularVelocity:Number = Helper.GetRandomN(100);
				
				AddParticle(position.Copy(), velocity.Copy(), angle, angularVelocity, sprite, 0.5);
			}
		}
		
		public function AddDirectional(position:b2Vec2, direction:b2Vec2, blendMode:String = "hardlight", randomness:Number = 1, count:Number = 1) : void 
		{
			for (var i:int = 0; i < count; i++) 
			{
				var sprite:Sprite = new particle1();
				sprite.blendMode = blendMode;
				
				var velocity:b2Vec2 = Helper.GetRandomV(3);
				velocity.Add(direction);
				var angle:Number = Helper.GetRandom(0, 360);
				var angularVelocity:Number = Helper.GetRandomN(100);
				
				AddParticle(position.Copy(), velocity.Copy(), angle, angularVelocity, sprite, 0.5);
			}
		}
		
		public function AddParticle(position:b2Vec2, velocity:b2Vec2, angle:Number, angularVelocity:Number, sprite:Sprite, lifespan:Number = 1) : void
		{
			if (Particles.length > MaxParticles)
			{
				return;
			}
			
			position.Multiply(PhysicsManager.Scale);
			velocity.Multiply(PhysicsManager.Scale);
			
			gamemanager.AddSprite(sprite);
			
			// Physics
			sprite.x = position.x;
			sprite.y = position.y;
			sprite.rotation = angle;
			
			Particles.push(new Particle(sprite, velocity, angularVelocity, lifespan));
		}
	}

}