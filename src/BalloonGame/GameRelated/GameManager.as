package BalloonGame.GameRelated 
{
	import Box2D.Dynamics.Joints.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.*;
	import BalloonGame.Ingame.*;
	import BalloonGame.Particles.*;
	import BalloonGame.Physics.*;
	import BalloonGame.Screen.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class GameManager
	{
		public var GameObjects:Vector.<GameObject>;
		public var ObstacleObjects:Vector.<Obstacle>;
		public var ExitObjects:Vector.<Exit>;
		public var Bullets:Vector.<Bullet>;
		public var Lasers:Vector.<Laser>;
		public var ComplexGameObjects:Vector.<ComplexGameObject>;
		
		public var player:Player;
		
		public var Particles:ParticleManager;
		
		public var AttachEvents:Stage;
		public var levelFinishTimer:Number = -1;
		private var gameStateCallback:Function;
		
		public var camera:ScreenCamera;
		public var arrowManager:ArrowManager;
		
		private var spriteToAdd:Vector.<Sprite>;
		private var spriteToRemove:Vector.<Sprite>;
		
		private var staticSpriteToAdd:Vector.<Sprite>;
		private var staticSpriteToRemove:Vector.<Sprite>;
		
        private var gameplay:Gameplay;
        
        public var IsIngame:Boolean = false;
		
		public function GameManager(main:Main, gameStateCallback:Function)
		{
			// Sprite Add/Remove
			spriteToAdd = new Vector.<Sprite>();
			spriteToRemove = new Vector.<Sprite>();
			staticSpriteToAdd = new Vector.<Sprite>();
			staticSpriteToRemove = new Vector.<Sprite>();
			
			// GameObject list
			GameObjects = new Vector.<GameObject>();
			ObstacleObjects = new Vector.<Obstacle>();
			ExitObjects = new Vector.<Exit>();
			Bullets = new Vector.<Bullet>();
			Lasers = new Vector.<Laser>();
			ComplexGameObjects = new Vector.<ComplexGameObject>();
			
			// Camera
			camera = new ScreenCamera(new b2Vec2(main.stage.stageWidth, main.stage.stageHeight));
			
			// Events
			AttachEvents = main.stage;
			
			// Particles
			Particles = new ParticleManager(this);
			
			// Gamestate change callback
			this.gameStateCallback = gameStateCallback;
			
			// Arrow
			arrowManager = new ArrowManager(this);
			AddStaticSprite(arrowManager.DrawObject);
            
            // Gameplay
            this.gameplay = new Gameplay(this);
		}
		
		public function Initalize() : void
		{
			this.player.AddContactEvent(OnPlayerContact);
		}
		
		private var playerHitSoundRepeat:Number = 0;
		private function OnPlayerContact(a:GameObject, b:GameObject, contactInfo:ContactInfo) : void
		{
			if ((b is Balloon) == false)
			{
				// Dust when ground is contacted
				var intensity:Number = Math.min(contactInfo.Intensity / 50, 1.05) + 0.2;
				if (contactInfo.P2 == null)
				{
					this.Particles.AddElectricSparks(contactInfo.P1, 1, intensity);
				}
				else
				{
					// Sparks in a line
					var diff:b2Vec2 = contactInfo.P2.Copy();
					diff.Subtract(contactInfo.P1);
					diff.Multiply(Math.random());
					diff.Add(contactInfo.P1);
					this.Particles.AddElectricSparks(diff, 1, intensity);
				}
				
				// Sound for ground hit
				if (contactInfo.Intensity / 50 > 1 && playerHitSoundRepeat > 0.1)
				{
					playerHitSoundRepeat = 0;
					
					var channel:SoundChannel = Main.Audio.PlaySound("thump");
                    if (channel != null)
                    {
                        channel.soundTransform = new SoundTransform(Math.min(contactInfo.Intensity / 1200, 0.7));
                    }
				}
			}
			
			if (b is Exit && levelFinishTimer == -1 && Main.stateManager.currentStateNumber == StateManager.PLAYING)
			{
				levelFinishTimer = 1.2;
				Main.Audio.PlaySound("shortBlip");
			}
		}
		
		public function Update(timeStep:Number) : void
		{
			UpdateArrays(timeStep);
			
			// Update Camera
			var mouseOffset:b2Vec2 = Input.GetScreenMousePosition();
			mouseOffset.Subtract(new b2Vec2(camera.screenSize.x / 2, camera.screenSize.y / 2));
			mouseOffset.Multiply(0.12 * (1 / PhysicsManager.Scale));
			
			camera.UpdateTarget(player.Body.GetPosition());
			camera.UpdateTargetOffset(mouseOffset);
			camera.Update(timeStep);
			
			// Particles
			Particles.Update(timeStep);
			
			// Laser
			Laser.LaserSoundDelay += timeStep;
			
			// Level finish
			if (levelFinishTimer != -1)
			{
				levelFinishTimer -= timeStep;
				
				if (levelFinishTimer < 0)
				{
					levelFinishTimer = Number.POSITIVE_INFINITY;
					this.SetGameState(StateManager.LEVELNEXT);
				}
			}
			
			// Player sound
			playerHitSoundRepeat += timeStep;
			
			// Arrow
			arrowManager.Update(timeStep);
            
            // Gameplay
            //if (IsIngame)
            //{
                this.gameplay.Update(timeStep);
            //}
			
			CleanArrays();
		}
		
		private function UpdateArrays(timeStep:Number) : void
		{
			// Updates GameObjects
			for (var i:int = 0; i < GameObjects.length; i++) 
			{
				GameObjects[i].Update(timeStep);
			}
			
			// Updates ComplexGameObjects
			for (var c:int = 0; c < ComplexGameObjects.length; c++) 
			{
				ComplexGameObjects[c].Update(timeStep);
			}
			
			// Updates Obstacle
			for (var j:int = 0; j < ObstacleObjects.length; j++) 
			{
				ObstacleObjects[j].Update(timeStep);
			}
			
			// Updates Exit
			for (var k:int = 0; k < ExitObjects.length; k++) 
			{
				ExitObjects[k].Update(timeStep);
			}
			
			// Updates Lasers
			for (var l:int = 0; l < Lasers.length; l++) 
			{
				Lasers[l].Update(timeStep);
			}
			
			// Updates Bullets
			for (var b:int = 0; b < Bullets.length; b++) 
			{
 				Bullets[b].Update(timeStep);
			}
		}
		
		private function CleanArrays() : void
		{
			// Updates GameObjects
			for (var i:int = 0; i < GameObjects.length; i++) 
			{
				// Handles disposing
				if (GameObjects[i].IsDisposing == true)
				{
					GameObjects[i].OnDispose();
					RemoveSprite(GameObjects[i].DrawObject);
					GameObjects.splice(i, 1);
					i--;
				}
			}
			
			// Updates ComplexGameObjects
			for (var c:int = 0; c < ComplexGameObjects.length; c++) 
			{
				// Handles disposing
				if (ComplexGameObjects[c].IsDisposing == true)
				{
					ComplexGameObjects[c].OnDispose();
					RemoveSprite(ComplexGameObjects[c].DrawObject);
					ComplexGameObjects.splice(c, 1);
					c--;
				}
			}
			
			// Updates Obstacle
			for (var j:int = 0; j < ObstacleObjects.length; j++) 
			{
				// Handles disposing
				if (ObstacleObjects[j].IsDisposing == true)
				{
					ObstacleObjects[j].OnDispose();
					RemoveSprite(ObstacleObjects[j].DrawObject);
					ObstacleObjects.splice(j, 1);
					j--;
				}
			}
			
			// Updates Exit
			for (var k:int = 0; k < ExitObjects.length; k++) 
			{
				// Handles disposing
				if (ExitObjects[k].IsDisposing == true)
				{
					ExitObjects[k].OnDispose();
					RemoveSprite(ExitObjects[k].DrawObject);
					ExitObjects.splice(k, 1);
					k--;
				}
			}
			
			// Updates Lasers
			for (var l:int = 0; l < Lasers.length; l++) 
			{
				// Handles disposing
				if (Lasers[l].IsDisposing == true)
				{
					Lasers[l].OnDispose();
					RemoveSprite(Lasers[l].DrawObject);
					Lasers.splice(l, 1);
					l--;
				}
			}
			
			// Updates Bullets
			for (var b:int = 0; b < Bullets.length; b++) 
			{
				// Disposes Bullets if needed
				if (Bullets[b].IsDisposing == true)
				{
					Bullets[b].OnDispose();
					if (Bullets[b].DrawObject != null)
					{
						RemoveSprite(Bullets[b].DrawObject);
					}
					Bullets.splice(b, 1);
					b--;
				}
			}
		}
		
		public function Draw(screen:Sprite, overlaySprite:Sprite, staticOverlaySprite:Sprite):void
		{
			// Add sprites
			while (spriteToAdd.length > 0)
			{
				overlaySprite.addChild(spriteToAdd.pop());
			}
			
			// Remove sprites
			while (spriteToRemove.length > 0)
			{
				overlaySprite.removeChild(spriteToRemove.pop());
			}
			
			// Add static sprites
			while (staticSpriteToAdd.length > 0)
			{
				staticOverlaySprite.addChild(staticSpriteToAdd.pop());
			}
			
			// Remove static sprites
			while (staticSpriteToRemove.length > 0)
			{
				staticOverlaySprite.removeChild(staticSpriteToRemove.pop());
			}
		}
        
		public function DrawGame(screen:Sprite, overlaySprite:Sprite, staticOverlaySprite:Sprite):void
		{
			// Draws GameObjects
			for (var i:int = 0; i < GameObjects.length; i++) 
			{
				GameObjects[i].Draw(overlaySprite);
			}
			// Draws ComplexGameObjects
			for (var c:int = 0; c < ComplexGameObjects.length; c++) 
			{
				ComplexGameObjects[c].Draw(overlaySprite);
			}
			// Draws Obstacles
			for (var j:int = 0; j < ObstacleObjects.length; j++) 
			{
				ObstacleObjects[j].Draw(overlaySprite);
			}
			// Draws Exit
			for (var k:int = 0; k < ExitObjects.length; k++) 
			{
				ExitObjects[k].Draw(overlaySprite);
			}
			// Draws Lasers
			for (var l:int = 0; l < Lasers.length; l++) 
			{
				Lasers[l].Draw(overlaySprite);
			}
			
			// Draws Bullets
			for (var b:int = 0; b < Bullets.length; b++) 
			{
				Bullets[b].Draw(overlaySprite);
			}
			
			// Particles
			Particles.Draw(overlaySprite);
			
			// Repositions camera
			camera.UpdateDraw(screen);
			
			// Arrow
			arrowManager.Draw(staticOverlaySprite);
        }
		
		public function AddSprite(sprite:Sprite) : void
		{
			spriteToAdd.push(sprite);
		}
		
		public function RemoveSprite(sprite:Sprite) : void
		{
			spriteToRemove.push(sprite);
		}
		
		public function AddStaticSprite(sprite:Sprite) : void
		{
			staticSpriteToAdd.push(sprite);
		}
		
		public function RemoveStaticSprite(sprite:Sprite) : void
		{
			staticSpriteToRemove.push(sprite);
		}
		
		public function AddGameObject(obj:GameObject) : void
		{
			if (obj is Exit)
			{
				ExitObjects.push(obj);
			}
			else if (obj is Obstacle)
			{
				ObstacleObjects.push(obj);
			}
			else if (obj is Laser)
			{
				Lasers.push(obj);
			}
			else if (obj is ComplexGameObject)
			{
				ComplexGameObjects.push(obj);
			}
			else 
			{
				GameObjects.push(obj);
			}
		}
		
		public function AddBullet(bullet:Bullet) : void
		{
			Bullets.push(bullet);
			if (bullet.DrawObject != null)
			{
				AddSprite(bullet.DrawObject);
			}
		}
		
		public function SetGameState(target:Number) : void
		{
			gameStateCallback(target);
		}
		
	}
}