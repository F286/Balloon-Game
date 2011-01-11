package BalloonGame.GameRelated 
{
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import flash.display.Sprite;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.Physics.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class GameObject
	{
		public static const BOX:Number = 1;
		public static const CIRCLE:Number = 2;
		
		private static var currentTagToSet:Number = 0;
		
		public var DrawObject:Sprite;
		public var Body:b2Body;
		
		public const piToDegrees:Number = (1 / (Math.PI * 2)) * 360;
		
		public var IsDisposing:Boolean = false;
		
		public var UniqueTag:String;
		
		// If Density == 0, then the object's static
		public function GameObject(drawObject:Sprite, shapeType:Number = GameObject.BOX, density:Number = 10, groupIndex:Number = 0) 
		{
			// Graphics
			this.DrawObject = drawObject;
			
			// Physics
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(drawObject.x / PhysicsManager.Scale, drawObject.y / PhysicsManager.Scale);
			bodyDef.userData = this;
			if (density == 0)
			{
				bodyDef.type = b2Body.b2_staticBody;
			}
			else
			{
				bodyDef.type = b2Body.b2_dynamicBody;
			}
			
			// Temp sets rotation to zero, so boxes can be rotated in flash
			var rotation:Number = drawObject.rotation;
			drawObject.rotation = 0;
			
			var shape:b2Shape;
			if (shapeType == GameObject.CIRCLE)
			{
				var radius:Number = Math.max(drawObject.width, drawObject.height) / PhysicsManager.Scale / 2;
				shape = new b2CircleShape(radius);
			}
			else
			{
				shape = new b2PolygonShape();
				b2PolygonShape(shape).SetAsBox(drawObject.width / PhysicsManager.Scale / 2, drawObject.height / PhysicsManager.Scale / 2);
			}
			
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = shape;
			fixtureDef.friction = 0.5;
			fixtureDef.restitution = 0.2;
			fixtureDef.density = density;
			
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = 0x1000;
			filter.maskBits = 0xFFFF;
			filter.groupIndex = groupIndex;
			fixtureDef.filter = filter;
			
			Body = PhysicsManager.World.CreateBody(bodyDef);
			Body.CreateFixture(fixtureDef);
			Body.SetAngle(rotation / piToDegrees);
			
			// Set tag for contact manager
			UniqueTag = String(currentTagToSet);
			currentTagToSet++;
			
			// add object to contact manager
			//Physics.ContactM.AddGameObject(this);
		}
		
		public function Update(timeStep:Number) : void
		{
			if (IsDisposing)
			{
				OnDispose();
			}
		}
		
		public function OnDispose() : void
		{
			//Physics.ContactM.RemoveGameObject(this);
			
			//var remove:b2JointEdge = this.Body.GetJointList();
			//while (remove != null)
			//{
				//PhysicsManager.World.DestroyJoint(remove.joint);
				//remove = remove.next;
			//}
			PhysicsManager.ContactM.RemoveEvents(this);
			PhysicsManager.World.DestroyBody(this.Body);
		}
		
		public function Draw(overlaySprite:Sprite) : void
		{
			var position:b2Vec2 = Body.GetPosition();
			this.DrawObject.x = position.x * PhysicsManager.Scale;
			this.DrawObject.y = position.y * PhysicsManager.Scale;
			
			this.DrawObject.rotation = Body.GetAngle() * piToDegrees;
		}
		
		// This callback returns two GameObjects
		// a = gameobject passed in (this object)
		// b = gameobject colliding with
		// contactInfo = information about collision
		//  -- example --
		// private function OnContact(a:GameObject, b:GameObject, contactInfo:ContactInfo) : void
		//  -------------
		public function AddContactEvent(callback:Function) : void
		{
			PhysicsManager.ContactM.AddEvent(this, callback);
		}
		
		//public function OnContact(collideBody:b2Body, contact:b2Vec2) : void
		//{
			// Called by ContactListener, only accessed in subclasses
		//}
	}

}















