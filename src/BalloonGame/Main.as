﻿package BalloonGame
{
	import BalloonGame.GameRelated.*
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import BalloonGame.Physics.*;
	import BalloonGame.Screen.*;
	
	
	/**
	 * ...
	 * @author Free
	 */
	public class Main extends Sprite
	{
		public var screen:Sprite;
		
		private var mainTimer:Timer;
		
		public static var physics:PhysicsManager;
		public static var Audio:AudioManager;
		
		private var gameplay:Gameplay;
		private var input:Input;
		
		private var stateManager:StateManager;
		private var gameStateTarget:Number = -1;
		
		private var overlaySprite:Sprite;
		private var staticOverlaySprite:Sprite;
		
		private var mapLoader:MapLoader;
		
		public static var scoreManager:ScoreManager;
		
		private const defaultScore:Number = 99;
		private const defaultMoney:Number = 20000;
		public static const defaultMoneyLevelChange:Number = 11000;
		
		private var transitionIn:Transistion;
		private var transitionOut:Transistion;
		
		private var musicManager:MusicManager;
		
		public static var IsGameMode:Boolean = false;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// ENTRY POINT!
			
			stage.frameRate = 60;
			
			// Timer
			mainTimer = new Timer(1000 / 60);
			mainTimer.addEventListener( TimerEvent.TIMER, Tick);
			mainTimer.start();
			
			// Audio Manager
			Audio = new AudioManager();
			
			scoreManager = new ScoreManager();
			
			Restart(StateManager.MENU);
			
			// Music
			musicManager = new MusicManager();
			musicManager.UpdateMusic(stateManager.currentStateNumber, mapLoader.MapNumber);
		}
		
		private function OnGameStateChange(target:Number) : void
		{
			gameStateTarget = target;
		}
		
		private function Restart(state:Number) : void
		{
			// Unloads previous level if necessary
			if (screen != null)
			{
				this.removeChild(screen);
			}
			if (staticOverlaySprite != null)
			{
				stage.removeChild(staticOverlaySprite);
			}
			
			// Gameplay
			gameplay = new Gameplay(this, OnGameStateChange);

			// Map Loader
			if (mapLoader == null)
			{
				mapLoader = new MapLoader();
			}
			else 
			{
				mapLoader = new MapLoader(mapLoader.MapNumber);
			}
			
			// State Manager
			stateManager = new StateManager(gameplay, state);
			
			// Loads screen sprite
			screen = mapLoader.LoadMapSprite();
			this.addChild(screen);

			// Sets input to current screen
			input = new Input(screen);
			
			// Physics
			physics = new PhysicsManager(screen);
			
			// Overlay sprite
			overlaySprite = new Sprite();
			screen.addChild(overlaySprite);
			staticOverlaySprite = new Sprite();
			stage.addChild(staticOverlaySprite);
			
			// Loads map
			mapLoader.LoadMap(gameplay, screen);
			
			// Transistion
			if (transitionOut != null)
			{
				transitionOut.Dispose(stage);
				transitionOut = null;
			}
			transitionIn = new Transistion(stage, "in");
		}
		
		private function Tick(event:TimerEvent):void 
		{
			var timeStep:Number = 1 / 60;
			
			// Clears the screen (drawing)
			this.overlaySprite.graphics.clear();
			
			// Sets practice mode
			if (mapLoader.MapNumber > 10)
			{
				IsGameMode = true;
			}
			else
			{
				IsGameMode = false;
			}
			
			// Physics
			physics.Update(timeStep);
			
			// Gameplay
			gameplay.Draw(screen, overlaySprite, staticOverlaySprite);
			gameplay.Update(timeStep);
			
			// Score
			if (stateManager.currentStateNumber == StateManager.PLAYING && IsGameMode)
			{
				scoreManager.DecrementScore(timeStep);
			}   
			
			// Score
			scoreManager.Update(timeStep);
			
			// State
			stateManager.Update(timeStep);
			stateManager.Draw(screen);
			
			// Resets input
			input.Update(timeStep);
			
			// Transistions
			if (gameplay.levelFinishTimer != -1 && stateManager.currentStateNumber == StateManager.PLAYING && transitionOut == null)
			{
				transitionOut = new Transistion(stage, "out");
			}
			if (transitionIn != null && transitionIn.AnimationFinished == true)
			{
				transitionIn.Dispose(stage);
				transitionIn = null;
			}
			if (transitionOut != null && transitionOut.AnimationFinished == true && stateManager.currentStateNumber != StateManager.PLAYING)
			{
				transitionOut.Dispose(stage);
				transitionOut = null;
			}
			
			// Change states
			if (gameStateTarget != -1)
			{
				// Updates music
				musicManager.UpdateMusic(gameStateTarget, mapLoader.MapNumber);
					
				if (gameStateTarget == StateManager.ENTERGAME)
				{
					scoreManager.ResetStats(defaultScore, defaultMoney);
					gameStateTarget = StateManager.RESETTHENBUILDING;
				}
				
				if (gameStateTarget == StateManager.RESETTHENBUILDING)
				{
					Restart(StateManager.BUILDING);
					gameStateTarget = -1;
				}
				else if (gameStateTarget == StateManager.LEVELNEXT)
				{
					mapLoader.IncrementMapNumber();
					scoreManager.NextLevel();
					
					if (mapLoader.CanLoadMap())
					{
						scoreManager.AtCheckpoint();
						gameStateTarget = StateManager.RESETTHENBUILDING;
					}
					else
					{
						gameStateTarget = StateManager.SCORE;
					}
				}
				// Can only change the state manager if it's an "actual" game state
				// (Not a transistion)
				else if(gameStateTarget <= StateManager.SCORE)
				{
					stateManager.ChangeState(gameStateTarget);
					gameStateTarget = -1;
				}
				
				if (gameStateTarget == StateManager.EXITGAME)
				{
					scoreManager.SaveScore();
					mapLoader.ResetMapNumber();
					Restart(StateManager.MENU);
					gameStateTarget = -1;
				}
				
			}
		}
	}
}