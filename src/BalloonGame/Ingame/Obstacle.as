package BalloonGame.Ingame 
{
	import BalloonGame.GameRelated.*;
	import BalloonGame.Main;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.Physics.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class Obstacle extends GameObject
	{
		public var Damage:Number = 10;
		
		public function Obstacle(drawObject:Sprite, shapeType:Number = GameObject.BOX, density:Number = 10) 
		{
			super(drawObject, shapeType, density);
			
			this.AddContactEvent(OnContact);
		}
		
		
		private function OnContact(a:GameObject, b:GameObject, contactInfo:ContactInfo) : void
		{
			if (b is ComplexGameObject)
			{
				ComplexGameObject(b).DamageTaken += Damage;
			}
		}
	}

}