// (c) 2007 Ian Thomas
// Freely usable in whatever way you like, as long as it's attributed.
package BalloonGame.Physics
{
	import BalloonGame.*;
	
    public class ContactCallback
    {
		public var Callbacks:Array;
		
		public function ContactCallback(cb:Function)
		{
			Callbacks = new Array();
			AddCallback(cb);
		}
		
		public function AddCallback(cb:Function) : void
		{
			Callbacks.push(cb);
		}
		
		public function RemoveCallback(cb:Function) : void
		{
			for (var i:int = 0; i < Callbacks.length; i++) 
			{
				if (Callbacks[i] == cb)
				{
					Callbacks.splice(i, 1);
					break;
				}
			}
		}
    }
}