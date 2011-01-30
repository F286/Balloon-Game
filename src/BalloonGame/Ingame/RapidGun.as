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
	
	// Greensock
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class RapidGun extends AttachObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='rapidGun')]
		private var GunSprite:Class;
		
		public function RapidGun(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			super(position, attachBody, attachPosition, new GunSprite(), GameObject.BOX, 5);
			
			this.drawObject.Play(true);
			
			this.coolDown = 0.1;
		}
		
		public override function Fire(callback:Function) : Bullet
		{
			super.Fire(callback);
			
			// Sound
			//Main.Audio.PlaySound("bigLaserShot");
				
			var direction:b2Vec2 = Body.GetWorldVector(new b2Vec2(0, 0))
			attachB.ApplyImpulse(direction, this.Body.GetPosition());
			
			this.drawObject.Play();
			
			// Find start / end points of raycast
			var start:b2Vec2 = Body.GetWorldPoint(new b2Vec2(0, 0));
			var end:b2Vec2 = start.Copy();
			end.Add( Body.GetWorldVector(new b2Vec2(0, -1000)) );
			
			// Creates the body
			return new Bullet(start, end, 0, 3, callback, 0xffff66, 0.2);
		}
	}
}