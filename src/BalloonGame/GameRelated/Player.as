package BalloonGame.GameRelated
{
	import BalloonGame.GameObject;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class Player extends GameObject
	{
		
		public function Player(drawObject:Sprite, gameObjectType:Number = GameObject.BOX, density:Number = 18) 
		{
			super(drawObject, gameObjectType, density);
			
			//this.Body.on
			this.Body.SetSleepingAllowed(false);
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			
		}
	}

}