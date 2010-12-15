package BalloonGame.Physics
{
	import BalloonGame.GameObject;
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
	public class RaycastManager
	{
		public var P1:b2Vec2;
		public var P2:b2Vec2;
		
		public function RaycastManager(startPoint:b2Vec2, endPoint:b2Vec2) 
		{
			this.P1 = startPoint;
			this.P2 = endPoint;
		}
		
		// This is the callback to use
		//
		//    private function OnRaycast(body:b2Body, contactPoint:b2Vec2, direction:b2Vec2) : void
		//
		public function SendRaycast(callback:Function) : Boolean
		{
			callbackFixture = null;
			callbackFraction = 1000000;
			PhysicsManager.World.RayCast(ClosestPointCallback, P1, P2);
			
			if (callbackFixture != null)
			{
				var direction:b2Vec2 = P2.Copy();
				direction.Subtract(P1);
				direction.Normalize();
				
				if (callback != null)
				{
					callback(callbackFixture.GetBody(), callbackPoint, direction);
					return true;
				}
			}
			return false;
		}
		
		
		private var callbackFixture:b2Fixture;
		private var callbackPoint:b2Vec2;
		private var callbackFraction:Number;
		private function ClosestPointCallback(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number) : Number
		{
			if (fixture.IsSensor())
			{
				return fraction;
			}
			
			if (fraction < callbackFraction)
			{
				this.callbackFraction = fraction;
				this.callbackFixture = fixture;
				this.callbackPoint = point;
			}
			
			return fraction;
		}
	}

}