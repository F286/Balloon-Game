package BalloonGame.Ingame
{
	import BalloonGame.GameRelated.*;
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
	
	// Greensock
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	TweenPlugin.activate([DropShadowFilterPlugin]);
	
	/**
	 * ...
	 * @author Free
	 */
	public class Player extends GameObject
	{
		
		public function Player(drawObject:Sprite, gameObjectType:Number = GameObject.BOX, density:Number = 18) 
		{
			super(drawObject, gameObjectType, density, -1);
				
			TweenMax.to(drawObject, 1, {dropShadowFilter:{color:0x000000, alpha:1, blurX:12, blurY:12, distance:3}});
			
			//this.Body.on
			this.Body.SetSleepingAllowed(false);
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			
		}
	}

}