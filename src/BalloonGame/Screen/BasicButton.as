package BalloonGame.Screen 
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class BasicButton
	{
		private var button:SimpleButton;
		
		private var callback:Function;
		private var mouseDown:Boolean = false;
		
		public function BasicButton(parent:Sprite, buttonName:String, callback:Function, containsMovieclip:Boolean = false) 
		{
			button = parent[buttonName];
			button.addEventListener(MouseEvent.CLICK, OnClick);
			//button.addEventListener(MouseEvent.MOUSE_OVER, OnOver);
			//button.addEventListener(MouseEvent.MOUSE_UP, OnExit);
			//button.addEventListener(MouseEvent.MOUSE_OUT, OnExit);
			button.addEventListener(MouseEvent.MOUSE_DOWN, OnDown);
			button.addEventListener(MouseEvent.MOUSE_OVER, OnOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, OnUp);
			button.addEventListener(MouseEvent.MOUSE_UP, OnUp);
			button.addEventListener(Event.ENTER_FRAME, OnEnter);
			button.addEventListener(Event.EXIT_FRAME, OnExit);
			
			this.callback = callback;
			
			if (containsMovieclip)
			{
				EditMovieClips("stop");
			}
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
		
		private function EditMovieClips(edit:String) : void
		{
			EditMovieClip(button.upState, edit);
			EditMovieClip(button.overState, edit);
			EditMovieClip(button.downState, edit);
		}
		
		private function OnClick(evt:MouseEvent) : void
		{
			callback();
			//StopMovieClips();
		}
		
		
		private function OnDown(evt:MouseEvent) : void
		{
			mouseDown = true;
			//EditMovieClips("reset");
		}
		
		private function OnUp(evt:MouseEvent) : void
		{
			mouseDown = false;
			EditMovieClips("reset");
		}
		
		private function OnOver(evt:MouseEvent) : void
		{
			EditMovieClips("stop");
		}
		
		private function OnEnter(evt:Event) : void
		{
			if (!mouseDown)
			{
				//EditMovieClips("stop");
			}
		}
		
		private function OnExit(evt:Event) : void
		{
			if (!mouseDown)
			{
				if (Sprite(button.downState).getChildAt(0) is MovieClip)
				{
					var obj:MovieClip = MovieClip(Sprite(button.downState).getChildAt(0));
					
					if (obj.currentFrame == obj.totalFrames)
					{
						EditMovieClips("reset");
					}
				}
				//EditMovieClips("stop");
			}
		}
		
		public function Dispose(parent:Sprite) : void
		{
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_UP, OnClick);
		}
	}

}