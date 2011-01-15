package BalloonGame.Screen 
{
	import BalloonGame.GameRelated.DrawObject;
	import flash.display.*;
	import flash.events.*;
	
	// Greensock
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class BasicButton
	{
		private var button:SimpleButton;
		private var drawObject:DrawObject;
		
		private var callback:Function;
		private var mouseDown:Boolean = false;
		
		private var stopAtOne:Boolean = false;
		
		public function BasicButton(parent:Sprite, buttonName:String, callback:Function, containsMovieclip:Boolean = false) 
		{
			button = parent[buttonName];
			button.addEventListener(MouseEvent.CLICK, OnClick);
			button.addEventListener(MouseEvent.MOUSE_DOWN, OnDown);
			button.addEventListener(MouseEvent.MOUSE_UP, OnUp);
			button.addEventListener(Event.EXIT_FRAME, OnExit);
			
			this.callback = callback;
			
			if (containsMovieclip)
			{
				EditMovieClips("stop");
			}
		}
		
		private function EditMovieClips(edit:String) : void
		{
			EditMovieClip(button.upState, edit);
			EditMovieClip(button.overState, edit);
			EditMovieClip(button.downState, edit);
		}
		
		private function EditMovieClip(state:DisplayObject, edit:String) : void
		{
			for (var i:Number = 0; i < Sprite(state).numChildren; i++)
			{
				if (Sprite(state).getChildAt(i) is MovieClip)
				{
					var obj:MovieClip = MovieClip(Sprite(state).getChildAt(i));
					
					if (edit == "play")
					{
						obj.play();
					}
					else if(edit == "stop")
					{
						obj.stop();
					}
					else if(edit == "reset")
					{
						obj.gotoAndStop(0);
					}
				}
			}
		}
		private function OnExit(evt:Event) : void
		{
			EditMovieClips("stop");
		}
		
		private function OnClick(evt:MouseEvent) : void
		{
			callback();
		}
		
		private function OnDown(evt:MouseEvent) : void
		{
			evt.stopPropagation();
			mouseDown = true;
			
			//TweenMax.to(button, 1, {blurFilter:{blurX:20, repeat:1, yoyo:true }});
			TweenMax.to(button, 0.5, {blurFilter:{blurX:5, blurY:5}, repeat:1, yoyo:true });
			
		}
		
		private function OnUp(evt:MouseEvent) : void
		{
			mouseDown = false;
		}
		
		public function Dispose(parent:Sprite) : void
		{
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.CLICK, OnClick);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_DOWN, OnDown);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_UP, OnUp);
		}
	}

}