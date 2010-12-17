package BalloonGame.GameStates 
{
	import BalloonGame.GameStates.*;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.filters.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.*;
	import BalloonGame.GameRelated.*;
	
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
		private var moneyGlowTime:Number;
		
		public function BuildingState(gameplay:Gameplay) 
		{
			super(gameplay);
			
			// Overlay
			screenOverlay = new ScreenClass();
			gameplay.AddStaticSprite(screenOverlay);
			
			// Mouse Events
			gameplay.AttachEvents.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			gameplay.AttachEvents.addEventListener(MouseEvent.MOUSE_UP, MouseUp);
			
			// Buttons
			buildMode = 0;
			buttonList = new Vector.<BasicButton>();
			buttonList.push(new BasicButton(screenOverlay, "balloonButton", OnBalloonButton, true));
			buttonList.push(new BasicButton(screenOverlay, "gunButton", OnGunButton, true));
			buttonList.push(new BasicButton(screenOverlay, "thrusterButton", OnThrusterButton, true));
			
			nextButton = new BasicButton(screenOverlay, "nextButton", NextButtonClick);
			menuButton = new BasicButton(screenOverlay, "menuButton", MenuButtonClick);
			
			buildPrices = new Vector.<Number>();
			buildPrices.push(1000);
			buildPrices.push(5000);
			buildPrices.push(10000);
			
			moneyText = TextField(screenOverlay["moneyText"]);
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
		
		private function NextButtonClick() : void
		{
			gameplay.SetGameState(StateManager.PLAYING);
			Main.Audio.PlaySound("longBeep");
		}
		
		private function MenuButtonClick() : void
		{
			gameplay.SetGameState(StateManager.EXITGAME);
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
			if (attachBody != null && attachBody == gameplay.player.Body && Main.scoreManager.Money >= buildPrices[buildMode])
			{
				switch (buildMode) 
				{
					case 0:
						var bObject:Balloon = new Balloon(mouse, attachBody, attachPosition);
						gameplay.AddSprite(bObject.DrawObject);
						gameplay.AddGameObject(bObject);
						break;
					case 1:
						var bObject2:PlayerGun = new PlayerGun(mouse, attachBody, attachPosition);
						gameplay.AddSprite(bObject2.DrawObject);
						gameplay.AddGameObject(bObject2);
						break;
					case 2:
						var bObject3:Thruster = new Thruster(mouse, attachBody, attachPosition);
						gameplay.AddSprite(bObject3.DrawObject);
						gameplay.AddGameObject(bObject3);
						break;
				}
				Main.Audio.PlaySound("pop");
				moneyGlowTime = 0;
				
				if (Main.IsGameMode)
				{
					// Money
					Main.scoreManager.Money -= buildPrices[buildMode];
				}
				
				// Particles!
				gameplay.Particles.AddSparks(mouse, 5);
			}
			
			this.attachBody = null;
			this.attachPosition = new b2Vec2();
		}
		
		override public function Update(timeStep:Number):void 
		{
			super.Update(timeStep);
			
			moneyGlowTime += timeStep;
			
			// Mouse controlling player
			if (isMouseDown == true)
			{
				// Particles!
				var mouse:b2Vec2 = BalloonGame.Input.GetMousePosition();
				gameplay.Particles.AddSparks(mouse);
			}
			
			// Level timer update
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
			//moneyText.textColor = 0xFF0000;
			moneyText.antiAliasType = "ADVANCED";
			
			// Glow color
			if (moneyGlowTime <= 1.1)
			{
				var clampTime:Number = Math.min(moneyGlowTime, 1);
				
				var color:uint = (0xFF * (1 - clampTime)) << 16; // red
			    color = color | (0xFF * (clampTime)) << 8; //green
				var glow:GlowFilter = new GlowFilter(color);
				DisplayObject(moneyText).filters = [glow];
			}
		}
		
		public override function Dispose() : void
		{
			super.Dispose();
			
			// Mouse Events
			gameplay.AttachEvents.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			gameplay.AttachEvents.removeEventListener(MouseEvent.MOUSE_UP, MouseUp);

			// Buttons
			for (var i:int = 0; i < buttonList.length; i++) 
			{
				buttonList[i].Dispose(screenOverlay);
			}
			nextButton.Dispose(screenOverlay);
			menuButton.Dispose(screenOverlay);
		}
	}

}