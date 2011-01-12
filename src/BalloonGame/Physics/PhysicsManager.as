package BalloonGame.Physics
{
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class PhysicsManager
	{
		public static var World:b2World;
		public static var Scale:Number = 30;
		
		public var IsDebugDraw:Boolean = false;
		
		private var screen:Sprite;
        private var debugSprite:Sprite;
		
		private var mouseJoint:b2MouseJoint;
		
		public static var ContactM:ContactManager;
		
		private static var explosionControllers:Vector.<ExplosionController>;
		
		public function PhysicsManager(screen:Sprite) 
		{
			this.screen = screen;
			
			// World
			var gravity:b2Vec2 = new b2Vec2(0, 10);
			World = new b2World(gravity, true);
			
			// set debug draw
            var debugDraw:b2DebugDraw = new b2DebugDraw();
            debugSprite = new Sprite();
            screen.addChild(debugSprite);
            debugDraw.SetSprite(debugSprite);
            debugDraw.SetDrawScale(Scale);
            debugDraw.SetFillAlpha(0.5);
            debugDraw.SetLineThickness(2);
            debugDraw.SetAlpha(1);
            debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
            World.SetDebugDraw(debugDraw);
			
			ContactM = new ContactManager();
			World.SetContactListener(new ContactListener(ContactM));
			
			// Explosions
			explosionControllers = new Vector.<ExplosionController>();
		}
		
		public function CreateMouseJoint(evt:MouseEvent):void
		{
			var mouse:b2Vec2 = Input.GetMousePosition();
			var body:b2Body = GetBodyAtPoint(mouse);
			if (body != null)
			{
				var mouseJointDef:b2MouseJointDef = new b2MouseJointDef();
				mouseJointDef.bodyA = PhysicsManager.World.GetGroundBody();
				mouseJointDef.bodyB = body;
				mouseJointDef.target.Set(mouse.x, mouse.y);
				mouseJointDef.maxForce = 30000;
				mouseJointDef.frequencyHz = 3;
				mouseJoint = PhysicsManager.World.CreateJoint(mouseJointDef) as b2MouseJoint;
			}
		}
		
		public function DestroyMouseJoint(evt:MouseEvent):void
		{
			if (mouseJoint != null)
			{
				PhysicsManager.World.DestroyJoint(mouseJoint);
				mouseJoint = null;
			}
		}
		
		private var pointCheckBody:b2Body = null;
		public function GetBodyAtPoint(point:b2Vec2, includeStatic:Boolean = false) : b2Body
		{
			// Queries world for bodies overlapping "point"
			pointCheckBody = null;
			PhysicsManager.World.QueryPoint(QueryPointCallback, point);
			return pointCheckBody;
		}
		
		private function QueryPointCallback(fixture:b2Fixture):Boolean
		{
			pointCheckBody = fixture.GetBody();
			return false; // Return true if you want to keep querying
		}
		
		public function Update(timeStep:Number) : void
		{
			// Explosions
			for (var i:int = 0; i < explosionControllers.length; i++) 
			{
				explosionControllers[i].Update(World, timeStep);
				
				if (explosionControllers[i].CanDispose() == true)
				{
					explosionControllers.splice(i, 1);
					i--;
				}
			}
			
			World.Step(timeStep, 10, 10);
			
			var mouse:b2Vec2 = Input.GetMousePosition();
			
			if (mouseJoint != null)
			{
				mouseJoint.SetTarget(new b2Vec2(mouse.x, mouse.y));
			}
			
			if (IsDebugDraw)
			{
				World.DrawDebugData();
			}
			
			if (Input.IsKeyDown("k".charCodeAt()))
			{
				IsDebugDraw = true;
			}
			if (Input.IsKeyDown("l".charCodeAt()))
			{
				IsDebugDraw = false;
			}
		}
		
		public static function AddExplosionController(explosion:ExplosionController) : void
		{
			explosionControllers.push(explosion);
		}
	}
}