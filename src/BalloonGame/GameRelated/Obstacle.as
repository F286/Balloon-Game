package BalloonGame.GameRelated 
{
	import BalloonGame.GameObject;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Free
	 */
	public class Obstacle extends GameObject
	{
		
		
		public function Obstacle(drawObject:Sprite, shapeType:Number = GameObject.BOX, density:Number = 10) 
		{
			super(drawObject, shapeType, density);
			
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
		}
	}

}