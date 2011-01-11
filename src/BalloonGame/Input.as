package BalloonGame 
{
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
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
	public class Input
	{
		private static var screen:Sprite;
		private static var keysPressed:Vector.<uint>;
		
		public function Input(screen:Sprite) 
		{
			Input.screen = screen;
			keysPressed = new Vector.<uint>();
			
			screen.stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			screen.stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
		}
		
		public function Update(timeStep:Number) : void
		{
			//if (keysPressed.length != 0)
			//{
				//keysPressed = new Vector.<uint>();
			//}
		}
		
		private function OnKeyDown(event:KeyboardEvent):void
		{
			var containKey:Boolean = false;
			
			for (var i:int = 0; i < keysPressed.length; i++) 
			{
				if (keysPressed[i] == event.charCode)
				{
					containKey = true;
					break;
				}
			}
			
			if (containKey == false)
			{
				keysPressed.push(event.charCode);
			}
		}
		
		private function OnKeyUp(event:KeyboardEvent):void
		{
			for (var i:int = 0; i < keysPressed.length; i++) 
			{
				if (keysPressed[i] == event.charCode)
				{
					keysPressed.splice(i, 1);
					break;
				}
			}
		}
		
		public static function IsKeyDown(charCode:uint) : Boolean
		{
			for (var i:int = 0; i < keysPressed.length; i++) 
			{
				if (keysPressed[i] == charCode)
				{
					return true;
				}
			}
			return false;
		}
		
		public static function GetMousePosition(scaleToBox2D:Boolean = true) : b2Vec2
		{
			if (scaleToBox2D)
			{
				return new b2Vec2(screen.mouseX / PhysicsManager.Scale, screen.mouseY / PhysicsManager.Scale);
			}
			else
			{
				return new b2Vec2(screen.mouseX, screen.mouseY);
			}
		}
		
		public static function GetScreenMousePosition() : b2Vec2
		{
			return new b2Vec2(screen.stage.mouseX, screen.stage.mouseY);
		}
		
		//public function Dispose() : void
		//{
			//screen.stage.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			//screen.stage.removeEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
		//}
		
	}
}