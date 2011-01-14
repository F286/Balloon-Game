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
		private var onMouseOverCallback:Function = null;
		private var mouseDown:Boolean = false;
		
		private var stopAtOne:Boolean = false;
		
		public function BasicButton(parent:Sprite, buttonName:String, callback:Function, containsMovieclip:Boolean = false, onMouseOverCallback:Function = null) 
		{
			button = parent[buttonName];
			button.addEventListener(MouseEvent.CLICK, OnClick);
			button.addEventListener(MouseEvent.MOUSE_DOWN, OnDown);
			button.addEventListener(MouseEvent.MOUSE_OVER, OnOver);
			button.addEventListener(Event.EXIT_FRAME, OnExit);
			button.addEventListener(MouseEvent.MOUSE_OUT, OnUp);
			button.addEventListener(MouseEvent.MOUSE_UP, OnUp);
			button.addEventListener(MouseEvent.ROLL_OUT, OnUp);
			
			this.callback = callback;
			this.onMouseOverCallback = onMouseOverCallback;
			
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
		
		public function Update(timeStep:Number):void 
		{
			
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
		}
		
		
		private function OnDown(evt:MouseEvent) : void
		{
			evt.stopPropagation();
			mouseDown = true;
		}
		
		private function OnUp(evt:MouseEvent) : void
		{
			mouseDown = false;
			EditMovieClips("reset");
		}
		
		private function OnOver(evt:MouseEvent) : void
		{
			EditMovieClips("stop");
			
			if (onMouseOverCallback != null)
			{
				onMouseOverCallback();
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
			}				
			//else if (movieClip.currentFrame == 1 && stopOnOne)
			//{
				//movieClip.stop();
				//stopOnOne = false;
			//}

		}
		
		public function Dispose(parent:Sprite) : void
		{
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_UP, OnClick);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_DOWN, OnDown);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_OVER, OnOver);
			SimpleButton(parent[button.name]).removeEventListener(Event.EXIT_FRAME, OnExit);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_OUT, OnUp);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.MOUSE_UP, OnUp);
			SimpleButton(parent[button.name]).removeEventListener(MouseEvent.ROLL_OUT, OnUp);
		}
	}

}