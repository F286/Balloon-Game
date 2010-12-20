package BalloonGame.GameStates 
{
	import BalloonGame.GameStates.*;
	import Box2D.Dynamics.Joints.*;
	import flash.display.*;
	import flash.events.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import BalloonGame.*;
	import BalloonGame.Ingame.*;
	import BalloonGame.GameRelated.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class GameState
	{
		protected var screenOverlay:Sprite;
		
		protected var gameplay:Gameplay;
		
		public function GameState(gameplay:Gameplay) : void
		{
			this.gameplay = gameplay;
		}
		
		public function Update(timeStep:Number) : void
		{
			
		}
		
		public function Draw(overlaySprite:Sprite) : void
		{
			
		}
		
		public function Dispose() : void
		{
			// Remove the screen sprite
			gameplay.RemoveStaticSprite(screenOverlay);
		}
	}
}