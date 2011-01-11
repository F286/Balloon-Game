package BalloonGame.GameRelated 
{
	import flash.display.Sprite;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.Physics.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ComplexGameObject extends GameObject
	{
		public var Health:Number;
		public var DamageTaken:Number;
		public var IsAlive:Boolean = true;
		
		public function ComplexGameObject(health:Number, drawObject:Sprite, shapeType:Number = GameObject.BOX, density:Number = 10, groupIndex:Number = 0) 
		{
			//this = obj;
			this.Health = health;
			this.DamageTaken = 0;
			
			super(drawObject, shapeType, density, groupIndex);
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			if (DamageTaken >= Health)
			{
				this.IsAlive = false;
			}
		}
	}

}