package BalloonGame.Enemies 
{
	import BalloonGame.GameRelated.*;
	import BalloonGame.Ingame.Player;
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
	 * @author ...
	 */
	public class Airmine extends ComplexGameObject
	{
		[Embed(source = '../Library/mainFlash.swf', symbol = 'airmine')]
		private var AirMineSprite:Class;
		
		[Embed(source = '../Library/mainFlash.swf', symbol = 'airmineExploded')]
		private var AirMineExplodedSprite:Class;
		
		private var isExploded:Boolean = false;
		private var currentSprite:Sprite;
		
		public function Airmine(position:b2Vec2, sprite:Sprite = null) 
		{
			if (sprite == null)
			{
				sprite = new AirMineSprite();
			}
			
			
			sprite.x = position.x * PhysicsManager.Scale;
			sprite.y = position.y * PhysicsManager.Scale;
			
			super(1, sprite, GameObject.CIRCLE, 12.84);
			
			this.AddContactEvent(OnContact);
			
			
			//if (sprite == null)
			//{
				//sprite = new AirMineSprite();
			//}
			//
			//sprite.x = 0;
			//sprite.y = 0;
			//
			//currentSprite = new Sprite();
			//currentSprite.addChild(sprite);
			//
			//currentSprite.x = position.x * PhysicsManager.Scale;
			//currentSprite.y = position.y * PhysicsManager.Scale;
			//
			//super(1, currentSprite, GameObject.CIRCLE, 12.84);
			//
			//this.AddContactEvent(OnContact);
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			if (IsAlive == false && !isExploded)
			{
				Explode();
			}
		}
		
		private function Explode() : void
		{
			isExploded = true;
			//for (var i:Number = 0; i < this.DrawObject.numChildren; i++)
			//{
				//this.DrawObject.removeChildAt(this.DrawObject.getChildIndex[i]);
			//}
			//this.DrawObject.removeChild(currentSprite);
			this.drawObject.sprite.addChild(new AirMineExplodedSprite());
			
			PhysicsManager.AddExplosionController(new ExplosionController(this.Body.GetPosition(), 0));
		}
		
		private function OnContact(a:GameObject, b:GameObject, contactInfo:ContactInfo) : void
		{
			if (b.Body.GetUserData() is Player && !isExploded)
			{
				Explode();
			}
		}
	}

}