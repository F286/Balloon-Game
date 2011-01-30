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
	public class Thruster extends AttachObject
	{
		[Embed(source='../Library/mainFlash.swf', symbol='thruster')]
		private var ThrusterSprite:Class;
		
		public function Thruster(position:b2Vec2, attachBody:b2Body, attachPosition:b2Vec2)
		{
			super(position, attachBody, attachPosition, new ThrusterSprite(), GameObject.BOX, 5);
			
			this.instantAim = false;
			this.coolDown = 0.15;
		}
		
		public override function Fire(callback:Function) : Bullet
		{
			super.Fire(null);
			
			var direction:b2Vec2 = Body.GetWorldVector(new b2Vec2(0, -1.5))
			
			this.attachB.ApplyImpulse(direction, this.Body.GetPosition());
			
			return null;
		}
	}
}