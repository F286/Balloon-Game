package BalloonGame.Screen 
{
	import BalloonGame.GameRelated.DrawObject;
	import flash.display.*;
	import flash.events.*;
	
	// Greensock
	import com.greensock.*; 
	import com.greensock.easing.*;
	import com.greensock.plugins.*;

	TweenPlugin.activate([GlowFilterPlugin]);
	
	/**
	 * ...
	 * @author Free
	 */
	public class GlowButton
	{
		private var button:SimpleButton;
		private var drawObject:DrawObject;
		
		private var callback:Function;
		private var glowColor:uint;
		
		public var currentlySelected:Boolean = false;
		
		public function GlowButton(parent:Sprite, buttonName:String, graphicName:String, callback:Function, glowColor:uint) 
		{
			button = parent[buttonName];
			drawObject = new DrawObject(parent[graphicName]);
			drawObject.sprite.mouseEnabled = false;
			
			button.addEventListener(MouseEvent.CLICK, OnClick);
			button.addEventListener(MouseEvent.MOUSE_DOWN, OnDown);
			button.addEventListener(MouseEvent.ROLL_OVER, OnOver);
			button.addEventListener(MouseEvent.ROLL_OUT, OnOut);
			
			this.callback = callback;
			this.glowColor = glowColor;
			
			//EditMovieClips("stop");
		}
		
		private function OnOver(evt:Event) : void
		{
			AddGlow();
		}
		
		private function OnOut(evt:Event) : void
		{
			TryRemoveGlow();
		}
		
		public function AddGlow() : void
		{
			TweenMax.to(drawObject.sprite, 0.6, {glowFilter:{color:glowColor, alpha:1, blurX:14, blurY:14, strength:1.5}});
		}
		
		public function TryRemoveGlow() : void
		{
			if (currentlySelected == false)
			{
				TweenMax.to(drawObject.sprite, 0.8, { glowFilter: { alpha:0, remove:true }} );
			}
			
		}
		
		private function OnClick(evt:MouseEvent) : void
		{
			callback();
		}
		
		private function OnDown(evt:MouseEvent) : void
		{
			evt.stopPropagation();
		}
		
		public function Dispose(parent:Sprite) : void
		{
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.CLICK, OnClick);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_DOWN, OnDown);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.ROLL_OVER, OnOver);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.ROLL_OUT, OnOut);
		}
		
		//private function EditMovieClips(edit:String) : void
		//{
			//EditMovieClip(button.upState, edit);
			//EditMovieClip(button.overState, edit);
			//EditMovieClip(button.downState, edit);
		//}
		//
		//private function EditMovieClip(state:DisplayObject, edit:String) : void
		//{
			//for (var i:Number = 0; i < Sprite(state).numChildren; i++)
			//{
				//if (Sprite(state).getChildAt(i) is MovieClip)
				//{
					//var obj:MovieClip = MovieClip(Sprite(state).getChildAt(i));
					//
					//if (edit == "play")
					//{
						//obj.play();
					//}
					//else if(edit == "stop")
					//{
						//obj.stop();
					//}
					//else if(edit == "reset")
					//{
						//obj.gotoAndStop(0);
					//}
				//}
			//}
		//}
		
	}
}