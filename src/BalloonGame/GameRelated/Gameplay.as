package BalloonGame.GameRelated 
{
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
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
			for (var i:int = 0; i < gameManager.GameObjects.length; i++) 
			{
                // Player Gun
				if (gameManager.GameObjects[i] is GunRaycast)
				{
					var gunRaycast:GunRaycast = GunRaycast(gameManager.GameObjects[i]);
					
					if (Input.IsKeyDown(32) && gunRaycast.CanFire()) // Space
					{
						// Fires player's gun
						gunRaycast.Fire();
						
						// Creates bullet
						gameManager.AddBullet(gunRaycast.CreateBullet(OnBulletHit));
						
						// Plays sound
						Main.Audio.PlaySound("bigLaserShot");
			
						// Particles!
						gameManager.Particles.AddSparks(gunRaycast.Body.GetWorldPoint(new b2Vec2(0, -0.6)), 5);
					}
					gunRaycast.UpdateAim(Input.GetMousePosition());
				}
                // Rapid Gun
				if (gameManager.GameObjects[i] is RapidGun)
				{
					var rapidGun:RapidGun = RapidGun(gameManager.GameObjects[i]);
					
					if (Input.IsKeyDown(32) && rapidGun.CanFire()) // Space
					{
						// Fires player's gun
						rapidGun.Fire();
						
						// Creates bullet
						gameManager.AddBullet(rapidGun.CreateBullet(OnBulletHit));
						
						// Plays sound
						Main.Audio.PlaySound("bigLaserShot");
			
						// Particles!
						gameManager.Particles.AddSparks(rapidGun.Body.GetWorldPoint(new b2Vec2(0, -0.6)), 5);
					}
					rapidGun.UpdateAim(Input.GetMousePosition());
				}
                // Thruster
				else if (gameManager.GameObjects[i] is Thruster)
				{
					var thruster:Thruster = Thruster(gameManager.GameObjects[i]);
					
					if (isMouseDown == true)
					{
						thruster.ApplyThrust();
			
						// Particles!
						if (Helper.GetRandom(0, 1) < 0.4)
						{
							var position:b2Vec2 = thruster.Body.GetWorldPoint(new b2Vec2(0, 0.2));
							var direction:b2Vec2 = thruster.Body.GetWorldVector(new b2Vec2(0, 10));
							gameManager.Particles.AddDirectional(position, direction, "lighten", 1, 1);
						}
					}
					thruster.UpdateAim(Input.GetMousePosition());
				}
				
			}
        }
        
		
		private function OnBulletHit(body:b2Body, contactPoint:b2Vec2, direction:b2Vec2) : void
		{
			gameManager.Particles.AddElectricSparks(contactPoint, 5);
			
			if (body.GetUserData() is Balloon)
			{
				Balloon(body.GetUserData()).Pop();
			}
		}
        
    }
}