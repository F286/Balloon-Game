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
	public class DefaultGun extends AttachObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='playerGun')]
		private var GunSprite:Class;
		
		public function DefaultGun(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			super(position, attachBody, attachPosition, new GunSprite(), GameObject.BOX, 5);
			
			this.coolDown = 1.1;
		}
		
		public override function Fire(callback:Function) : Bullet
		{
			super.Fire(callback);
			
			// Sound
			Main.Audio.PlaySound("bigLaserShot");
				
			var direction:b2Vec2 = Body.GetWorldVector(new b2Vec2(0, 230))
			attachB.ApplyImpulse(direction, this.Body.GetPosition());
			
			this.drawObject.Play();
			
			// Creates the bullet
			var start:b2Vec2 = Body.GetWorldPoint(new b2Vec2(0, 0));
			var end:b2Vec2 = start.Copy();
			end.Add( Body.GetWorldVector(new b2Vec2(0, -1000)) );
			return new Bullet(start, end, 150, 50, callback);
		}
	}
}