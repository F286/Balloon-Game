package BalloonGame.GameRelated 
{
	import BalloonGame.Enemies.Airmine;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import flash.utils.getQualifiedClassName;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import BalloonGame.*;
	import BalloonGame.Ingame.*;
	import BalloonGame.GameRelated.*;
    
	/**
     * ...
     * @author Robin
     */
    public class Gameplay
    {
		private var gameManager:GameManager;
        
		private var isMouseDown:Boolean = false;
        
        public function Gameplay(gameManager:GameManager) 
        {
            this.gameManager = gameManager;
            
			// Mouse Events
			gameManager.AttachEvents.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			gameManager.AttachEvents.addEventListener(MouseEvent.MOUSE_UP, MouseUp);
        }
		
		public function MouseDown(evt:MouseEvent):void
		{
			isMouseDown = true;
		}
		
		public function MouseUp(evt:MouseEvent):void
		{
			isMouseDown = false;
		}
        
		public function Update(timeStep:Number) : void
		{
			var keyboardDirection:b2Vec2 = new b2Vec2(0, 0);
			
			if (Input.IsKeyDown("w".charCodeAt()))
			{
				keyboardDirection.y += 1;
			}
			if (Input.IsKeyDown("s".charCodeAt()))
			{
				keyboardDirection.y += -1;
			}
			if (Input.IsKeyDown("a".charCodeAt()))
			{
				keyboardDirection.x += -1;
			}
			if (Input.IsKeyDown("d".charCodeAt()))
			{
				keyboardDirection.x += 1;
			}
			
			for (var i:int = 0; i < gameManager.GameObjects.length; i++) 
			{
				switch (getQualifiedClassName(gameManager.GameObjects[i])) 
				{
					case getQualifiedClassName(DefaultGun):
						var gun:DefaultGun = DefaultGun(gameManager.GameObjects[i]);
						
						if (isMouseDown && gun.CanFire() && gameManager.IsIngame)
						{
							// Fires player's gun
							gameManager.AddBullet(gun.Fire(OnBulletHit));
							
							// Particles!
							gameManager.Particles.AddSparks(gun.Body.GetWorldPoint(new b2Vec2(0, -0.6)), 5);
						}
						gun.UpdateAim(Input.GetMousePosition(), true);
						
						break;
						
					
					case getQualifiedClassName(RapidGun):
						var rapidGun:RapidGun = RapidGun(gameManager.GameObjects[i]);
						
						if (isMouseDown && rapidGun.CanFire() && gameManager.IsIngame)
						{
							// Fires player's gun
							gameManager.AddBullet(rapidGun.Fire(OnBulletHit));
							
							// Particles!
							gameManager.Particles.AddSparks(rapidGun.Body.GetWorldPoint(new b2Vec2(0, -0.6)), 5);
						}
						rapidGun.UpdateAim(Input.GetMousePosition(), true);
						break;
						
						
					case getQualifiedClassName(Thruster):
						var thruster:Thruster = Thruster(gameManager.GameObjects[i]);
						
						if (keyboardDirection.x != 0 || keyboardDirection.y != 0)
						{
							thruster.UpdateAim(keyboardDirection);
							thruster.Fire(null);
				
							// Particles!
							if (Helper.GetRandom(0, 1) < 0.1)
							{
								var position:b2Vec2 = thruster.Body.GetWorldPoint(new b2Vec2(0, 0.2));
								var direction:b2Vec2 = thruster.Body.GetWorldVector(new b2Vec2(0, 10));
								gameManager.Particles.AddDirectional(position, direction, "lighten", 1, 1);
							}
						}
						else
						{
							thruster.UpdateAim(Input.GetMousePosition(true), true);
						}
						break;
						
						
					case getQualifiedClassName(Airmine):
						var airmine:Airmine = Airmine(gameManager.GameObjects[i]);
						break;
						
						
					case getQualifiedClassName(Balloon):
						if (gameManager.GameObjects[i].IsDisposing == true)
						{
							gameManager.Particles.AddElectricSparks(gameManager.GameObjects[i].Body.GetPosition(), 5, 4);
						}
						break;
					
						
					default:
						break;
				}
				
			}
        }
		
		private function OnBulletHit(bullet:Bullet, body:b2Body, contactPoint:b2Vec2, direction:b2Vec2) : void
		{
			gameManager.Particles.AddElectricSparks(contactPoint, 5);
			
			if (body.GetUserData() is ComplexGameObject)
			{
				ComplexGameObject(body.GetUserData()).DamageTaken += bullet.damage;
			}
		}
        
    }
}