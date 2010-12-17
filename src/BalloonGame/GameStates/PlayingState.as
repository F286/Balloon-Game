package BalloonGame.GameStates 
{
	import BalloonGame.GameRelated.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import flash.display.Sprite;
	import BalloonGame.*;
	import flash.events.*;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class PlayingState extends GameState
	{
		[Embed(source='../Library/mainFlash.swf', symbol='playingScreen')]
		private var ScreenClass:Class;
		
		private var scoreText:TextField;
		private var highestText:TextField;
		
		private var isMouseDown:Boolean = false;
		
		public function PlayingState(gameplay:Gameplay) 
		{
			super(gameplay);
			
			// Overlay
			screenOverlay = new ScreenClass();
			gameplay.AddStaticSprite(screenOverlay);
			
			// Mouse Events
			gameplay.AttachEvents.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			gameplay.AttachEvents.addEventListener(MouseEvent.MOUSE_UP, MouseUp);
			
			// Level timer
			scoreText = TextField(screenOverlay["timerText"]);
			highestText = TextField(screenOverlay["highestText"]);
		}
		
		public function MouseDown(evt:MouseEvent):void
		{
			isMouseDown = true;
		}
		
		public function MouseUp(evt:MouseEvent):void
		{
			isMouseDown = false;
		}
		
		public override function Update(timeStep:Number) : void
		{
			super.Update(timeStep);
			
			for (var i:int = 0; i < gameplay.GameObjects.length; i++) 
			{
				if (gameplay.GameObjects[i] is PlayerGun)
				{
					var playerGun:PlayerGun = PlayerGun(gameplay.GameObjects[i]);
					
					if (Input.IsKeyDown(32) && playerGun.CanFire()) // Space
					{
						// Fires player's gun
						playerGun.Fire();
						
						// Creates bullet
						gameplay.AddBullet(playerGun.CreateBullet(OnBulletHit));
						
						// Plays sound
						Main.Audio.PlaySound("bigLaserShot");
			
						// Particles!
						gameplay.Particles.AddSparks(playerGun.Body.GetWorldPoint(new b2Vec2(0, -0.6)), 5);
					}
					playerGun.UpdateAim(Input.GetMousePosition());
				}
				else if (gameplay.GameObjects[i] is Thruster)
				{
					var thruster:Thruster = Thruster(gameplay.GameObjects[i]);
					
					if (isMouseDown == true)
					{
						// Fires player's gun
						thruster.ApplyThrust();
						
						// Creates bullet
						//gameplay.AddBullet(playerGun.CreateBullet(OnBulletHit));
						
						// Plays sound
						//Main.Audio.PlaySound("distortedExplosion");
			
						// Particles!
						//gameplay.Particles.AddSparks(thruster.Body.GetWorldPoint(new b2Vec2(0, 0.2)), 1, "overlay");
						if (Helper.GetRandom(0, 1) < 0.4)
						{
							var position:b2Vec2 = thruster.Body.GetWorldPoint(new b2Vec2(0, 0.2));
							var direction:b2Vec2 = thruster.Body.GetWorldVector(new b2Vec2(0, 10));
							gameplay.Particles.AddDirectional(position, direction, "lighten", 1, 1);
						}
					}
					thruster.UpdateAim(Input.GetMousePosition());
				}
				
			}
			
			// Mouse controlling player
			//if (isMouseDown == true)
			//{
				// Moves player towards the mouse
				//var mouse:b2Vec2 = BalloonGame.Input.GetMousePosition();
				//var playerPosition:b2Vec2 = gameplay.player.Body.GetPosition();
				//
				//var diff:b2Vec2 = mouse.Copy();
				//diff.Subtract(playerPosition);
				//diff.Normalize();
				//diff.Multiply(7.0);
				//
				//gameplay.player.Body.ApplyImpulse(diff, gameplay.player.Body.GetPosition());
				//
				//gameplay.camera.
			//}
			
			// Level timer update
			var score:Number = Math.round(Main.scoreManager.Score);
			scoreText.text = score.toString()
			scoreText.setTextFormat(new TextFormat(null, null, null, true));
			scoreText.antiAliasType = "ADVANCED";
			
			// High Score update
			var roundedHighest:Number = Math.round(Main.scoreManager.HighScore);
			highestText.text = roundedHighest.toString()
			highestText.setTextFormat(new TextFormat(null, null, null, true));
			highestText.antiAliasType = "ADVANCED";
			
			// Reset Level
			if (Input.IsKeyDown("r".charCodeAt())) // R
			{
				Main.scoreManager.LoadCheckpoint();
				gameplay.SetGameState(StateManager.RESETTHENBUILDING);
			}
		}
		
		private function OnBulletHit(body:b2Body, contactPoint:b2Vec2, direction:b2Vec2) : void
		{
			gameplay.Particles.AddElectricSparks(contactPoint, 5);
			
			if (body.GetUserData() is Balloon)
			{
				Balloon(body.GetUserData()).Pop();
			}
		}
	}
}