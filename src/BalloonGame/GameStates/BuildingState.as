package BalloonGame.GameStates 
{
	import BalloonGame.GameStates.*;
	import Box2D.Dynamics.Joints.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.filters.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.*;
	import BalloonGame.Ingame.*;
	import BalloonGame.Screen.*;
	import BalloonGame.GameRelated.*;
    import BalloonGame.Physics.*;
	
	// Greensock
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	TweenPlugin.activate([GlowFilterPlugin]);
	
	/**
	 * ...
	 * @author Free
	 */
	public class BuildingState extends GameState
	{
		[Embed(source='../Library/mainFlash.swf', symbol='buildingScreen')]
		private var ScreenClass:Class;
		
		private var attachBody:b2Body;
		private var attachPosition:b2Vec2;
		
		private var buildMode:Number;
		
		private var buttonList:Vector.<BasicButton>;
		private var nextButton:BasicButton;
		private var menuButton:BasicButton;
		
		private var isMouseDown:Boolean = false;
		
		private var buildPrices:Vector.<Number>
		
		private var moneyText:TextField;
		
        private var startPosition:b2Vec2;
        
        private var scoreBoxes:ScoreBoxes;
		
		public function BuildingState(gameManager:GameManager) 
		{
			super(gameManager);
			
			// Overlay
			screenOverlay = new ScreenClass();
            MovieClip(screenOverlay).gotoAndStop(1);
            MovieClip(screenOverlay).addEventListener(Event.EXIT_FRAME, ScreenOverlayExitFrame);
			gameManager.AddStaticSprite(screenOverlay);
			
			// Mouse Events
			gameManager.AttachEvents.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			gameManager.AttachEvents.addEventListener(MouseEvent.MOUSE_UP, MouseUp);
			
			// Buttons
			buildMode = 0;
			buttonList = new Vector.<BasicButton>();
			buttonList.push(new BasicButton(screenOverlay, "balloonButton", OnBalloonButton, true));
			buttonList.push(new BasicButton(screenOverlay, "gunButton", OnGunButton, true));
			buttonList.push(new BasicButton(screenOverlay, "thrusterButton", OnThrusterButton, true));
			buttonList.push(new BasicButton(screenOverlay, "rapidGunButton", OnRapidFireButton, true));
			
			//nextButton = new BasicButton(screenOverlay, "nextButton", NextButtonClick);
			menuButton = new BasicButton(screenOverlay, "menuButton", MenuButtonClick);
			
			buildPrices = new Vector.<Number>();
			buildPrices.push(50);
			buildPrices.push(500);
			buildPrices.push(200);
			buildPrices.push(600);
			
			moneyText = TextField(screenOverlay["moneyBox"]["moneyText"]);
            
            // Enabled / Disabled
			gameManager.camera.OffsetEnabled = true;
            gameManager.IsIngame = false;
            
            // Start position
            startPosition = gameManager.player.Body.GetPosition().Copy();
            
            // Score Boxes
            scoreBoxes = new ScoreBoxes(screenOverlay);
		}
        
        private function ScreenOverlayExitFrame(evt:Event) : void
        {
            if (MovieClip(screenOverlay).currentFrame == MovieClip(screenOverlay).totalFrames - 3)
            {
                gameManager.SetGameState(StateManager.PLAYING);
                Main.Audio.PlaySound("longBeep");
            }
        }
		
		private function OnBalloonButton() : void
		{
			buildMode = 0;
		}
		
		private function OnGunButton() : void
		{
			buildMode = 1;
		}
		
		private function OnThrusterButton() : void
		{
			buildMode = 2;
		}
        
		private function OnRapidFireButton() : void
		{
			buildMode = 3;
		}
		
		private function MenuButtonClick() : void
		{
			gameManager.SetGameState(StateManager.EXITGAME);
			Main.Audio.PlaySound("longKnife");
		}
		
		public function MouseDown(evt:MouseEvent):void
		{
			isMouseDown = true;
			
			var mouse:b2Vec2 = BalloonGame.Input.GetMousePosition();
			var body:b2Body = BalloonGame.Main.physics.GetBodyAtPoint(mouse);
			
			this.attachBody = body;
			if (body != null)
			{
				this.attachPosition = body.GetLocalPoint(mouse);
			}
		}
		
		public function MouseUp(evt:MouseEvent):void
		{
			isMouseDown = false;
			
			var mouse:b2Vec2 = Input.GetMousePosition();
			
			// Adds object on mouse click
			if (attachBody != null && attachBody == gameManager.player.Body && Main.scoreManager.Money >= buildPrices[buildMode])
			{
				switch (buildMode) 
				{
					case 0:
						var bObject:Balloon = new Balloon(mouse, attachBody, attachPosition);
						gameManager.AddSprite(bObject.drawObject.sprite);
						gameManager.AddGameObject(bObject);
						break;
                        
					case 1:
						var bObject2:DefaultGun = new DefaultGun(mouse, attachBody, attachPosition);
						gameManager.AddSprite(bObject2.drawObject.sprite);
						gameManager.AddGameObject(bObject2);
						break;
                        
					case 2:
						var bObject3:Thruster = new Thruster(mouse, attachBody, attachPosition);
						gameManager.AddSprite(bObject3.drawObject.sprite);
						gameManager.AddGameObject(bObject3);
						break;
                        
					case 3:
						var bObject4:RapidGun = new RapidGun(mouse, attachBody, attachPosition);
						gameManager.AddSprite(bObject4.drawObject.sprite);
						gameManager.AddGameObject(bObject4);
						break;
                        
				}
				Main.Audio.PlaySound("pop");
				
				if (Main.IsGameMode)
				{
					// Money
					Main.scoreManager.Money -= buildPrices[buildMode];
					
					TweenMax.to(screenOverlay["moneyBox"], 0.5, { scaleX:1.1, scaleY:1.0, ease:Expo.easeOut, yoyo:true } );
					
					var moneyTimeline:TimelineLite = new TimelineLite();
					moneyTimeline.append(new TweenMax(moneyText, 0.4, {glowFilter:{color:0xff0000, alpha:1.3, blurX:15, blurY:15}}) );
					moneyTimeline.append(new TweenMax(moneyText, 1.0, {glowFilter:{color:0x00ff00, alpha:1, blurX:5, blurY:5}}) );
				}
				
				// Particles!
				gameManager.Particles.AddSparks(mouse, 5);
			}
			
			this.attachBody = null;
			this.attachPosition = new b2Vec2();
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			// Particles on mouse down
			if (isMouseDown == true)
			{
				var mouse:b2Vec2 = Input.GetMousePosition();
				gameManager.Particles.AddSparks(mouse);
			}
			
			// Amount of money player has
			if (Main.IsGameMode)
			{
				var money:Number = Math.round(Main.scoreManager.Money);
				moneyText.text = "$" + money.toString();
			}
			else
			{
				moneyText.text = "---";
			}
			moneyText.setTextFormat(new TextFormat(null, null, null, true));
			moneyText.antiAliasType = "ADVANCED";
			
            // Player out of "range" of start
            var startDiff:b2Vec2 = gameManager.player.Body.GetPosition().Copy();
            startDiff.Subtract(startPosition.Copy());
            if (startDiff.LengthSquared() > 3)
            {
                MovieClip(screenOverlay).play();
            }
            
            // Score boxes
            scoreBoxes.Update(timeStep);
            
			// Reset Level
			if (Input.IsKeyDown("r".charCodeAt()))
			{
				Main.scoreManager.LoadCheckpoint();
				gameManager.SetGameState(StateManager.RESETTHENBUILDING);
			}
		}
        
        override public function Draw(overlaySprite:Sprite):void 
        {
            super.Draw(overlaySprite);
            
            // Balloon String
			if (attachBody != null && attachBody == gameManager.player.Body && Main.scoreManager.Money >= buildPrices[buildMode])
			{
                var anchorA:b2Vec2 = attachBody.GetWorldPoint(attachPosition.Copy()).Copy();
                var anchorB:b2Vec2 = Input.GetMousePosition().Copy();
                    
                // Creates line repersenting joint
                overlaySprite.graphics.lineStyle(3, 0x000000, 0.6);
                overlaySprite.graphics.moveTo(anchorA.x * PhysicsManager.Scale, anchorA.y * PhysicsManager.Scale); 
                overlaySprite.graphics.lineTo(anchorB.x * PhysicsManager.Scale, anchorB.y * PhysicsManager.Scale); 
            }
        }
		
		public override function Dispose() : void
		{
			super.Dispose();
			
			// Mouse Events
			gameManager.AttachEvents.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			gameManager.AttachEvents.removeEventListener(MouseEvent.MOUSE_UP, MouseUp);

			// Buttons
			for (var i:int = 0; i < buttonList.length; i++) 
			{
				buttonList[i].Dispose(screenOverlay);
			}
			menuButton.Dispose(screenOverlay);
            
            // Movieclip events
            MovieClip(screenOverlay).removeEventListener(Event.EXIT_FRAME, ScreenOverlayExitFrame);
		}
	}

}