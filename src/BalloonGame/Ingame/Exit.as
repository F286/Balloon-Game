package BalloonGame.Ingame 
{
	import BalloonGame.GameRelated.*;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Free
	 */
	public class Exit extends GameObject
	{
		
		
		public function Exit(drawObject:Sprite, density:Number = 10) 
		{
			super(drawObject, GameObject.CIRCLE, density);
			
			this.Body.GetFixtureList().SetSensor(true);
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
		}
	}

}