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
	public class DefaultGun extends GameObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='playerGun')]
		private var GunSprite:Class;
		private var stopOnOne:Boolean = false;
		
        private var attachP:b2Vec2;
        private var attachB:b2Body;
		
		private var cooldown:Number = 100;
		
		public function DefaultGun(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			// Creates the sprite
			var bSprite:MovieClip = new GunSprite();
			bSprite.x = position.x * PhysicsManager.Scale;
			bSprite.y = position.y * PhysicsManager.Scale;
			bSprite.stop();
			bSprite.addEventListener(Event.EXIT_FRAME, ExitFrame);
			
			super(bSprite, GameObject.BOX, 5, -1);
			
			// Sets damping
			this.Body.SetLinearDamping(0.6);
			this.Body.SetAngularDamping(1.0);
            
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
		}
		
		public function CanFire() : Boolean
		{
   			if (cooldown > 1.1)
			{
				return true;
			}
			return false;
		}
		
		public function Fire(callback:Function) : Bullet
		{
			cooldown = 0;
				
			var direction:b2Vec2 = Body.GetWorldVector(new b2Vec2(0, 230))
			attachB.ApplyImpulse(direction, this.Body.GetPosition());
			
			MovieClip(this.DrawObject).play();
			
			// Creates the bullet
			var start:b2Vec2 = Body.GetWorldPoint(new b2Vec2(0, 0));
			var end:b2Vec2 = start.Copy();
			end.Add( Body.GetWorldVector(new b2Vec2(0, -1000)) );
			return new Bullet(start, end, 500, 50, callback);
			
			// Sound
			Main.Audio.PlaySound("bigLaserShot");
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