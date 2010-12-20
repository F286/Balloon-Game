package BalloonGame.Screen 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import BalloonGame.*;
	import BalloonGame.Physics.*;
	import BalloonGame.Screen.*;
	import BalloonGame.GameRelated.*;
	import BalloonGame.Ingame.*
	
	/**
	 * ...
	 * @author ...
	 */
	public class ArrowManager 
	{
		[Embed(source='../Library/mainFlash.swf', symbol='arrow')]
		private var Arrow:Class;
		
		public var DrawObject:Sprite;
		public var IsEnabled:Boolean = false;
		
		private var gameplay:Gameplay;
		
		public function ArrowManager(gameplay:Gameplay) 
		{
			this.DrawObject = new Arrow();
			this.gameplay = gameplay;
		}
		
		public function Update(timeStep:Number) : void
		{
			if (IsEnabled)
			{
				this.DrawObject.visible = true;
			}
			else
			{
				this.DrawObject.visible = false;
			}
		}
		
		public function Draw(overlaySprite:Sprite):void 
		{
			var player:b2Vec2 = this.gameplay.player.Body.GetPosition().Copy();
			player.Add(gameplay.camera.offset);
			var exit:b2Vec2 = this.gameplay.ExitObjects[0].Body.GetPosition().Copy();
			
			// Padded screen size
			var padding:Number = 40;
			var screenClamped:b2Vec2 = gameplay.camera.screenSize.Copy();
			screenClamped.x -= padding * 2;
			screenClamped.y -= padding * 2;
			
			// Player to exit
			var diff:b2Vec2 = exit.Copy();
			diff.Subtract(player);
			diff.Multiply(PhysicsManager.Scale);
			
			
			// Rotation
			var rotation:Number = Math.atan2(diff.y, diff.x) / Math.PI * 180;
			
			// Min distance
			var length:Number = diff.Length();
			diff.Normalize();
			diff.Multiply(length - 50);
			
			// Clamp to edges of screen
			diff.x = Helper.Clamp(diff.x, -screenClamped.x / 2, screenClamped.x / 2);
			diff.y = Helper.Clamp(diff.y, -screenClamped.y / 2, screenClamped.y / 2);
			
			// Center of screen
			var center:b2Vec2 = gameplay.camera.screenSize.Copy();
			center.Multiply(0.5);
			
			// Screen position of arrow
			var position:b2Vec2 = center;
			position.Add(diff);
			position.Add(gameplay.camera.FindTargetOffset(true));
			
			// Set arrow
			DrawObject.x = center.x;
			DrawObject.y = center.y;
			DrawObject.rotation = rotation;
		}
		
	}
}