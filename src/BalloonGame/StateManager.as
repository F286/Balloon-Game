package BalloonGame
{
	import BalloonGame.Ingame.*
	import BalloonGame.GameStates.*
	import BalloonGame.GameRelated.*;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	
	/**
	 * ...
	 * @author Free
	 */
	public class StateManager
	{
		public static const MENU:Number = 0;
		public static const BUILDING:Number = 1;
		public static const PLAYING:Number = 2;
		public static const HELP:Number = 3;
		public static const SCORE:Number = 4;
		public static const LEVELNEXT:Number = 5;
		public static const RESETTHENBUILDING:Number = 6;
		public static const ENTERGAME:Number = 7;
		public static const EXITGAME:Number = 8;
		
		private var gameplay:Gameplay;
		
		private var currentState:GameState;
		public var currentStateNumber:Number;
		
		public function StateManager(gameplay:Gameplay, number:Number) 
		{
			this.gameplay = gameplay;
			
			// Stating Game State
			//currentStateNumber = StateManager.MENU;
			ChangeState(number);
		}
		
		public function ChangeState(stateNumber:Number) : void
		{
			currentStateNumber = stateNumber;
			
			if (currentState != null)
			{
				currentState.Dispose();
			}
			
			switch (stateNumber) 
			{
				case StateManager.MENU:
					trace("menu created");
					currentState = new MenuState(gameplay);
					break;
					
				case StateManager.BUILDING:
					currentState = new BuildingState(gameplay);
					break;
				
				case StateManager.PLAYING:
					currentState = new PlayingState(gameplay);
					break;
				
				case StateManager.HELP:
					currentState = new HelpState(gameplay);
					break;
				
				case StateManager.SCORE:
					currentState = new ScoreState(gameplay);
					break;
					
				default :
					break;
			}
		}
		
		public function Update(timeStep:Number) : void
		{
			currentState.Update(timeStep);
		}
		
		public function Draw(overlaySprite: Sprite):void
		{
			currentState.Draw(overlaySprite);
		}
	}
}