package BalloonGame.GameStates 
{
	import BalloonGame.GameStates.*;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.*;
	
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