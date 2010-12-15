package BalloonGame.Physics
{
	import flash.utils.Dictionary;
	
	import BalloonGame.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class ContactManager
	{
		private var events:Dictionary;
		
		public function ContactManager() 
		{
			events = new Dictionary();
		}
		
		// This callback returns two GameObjects
		// a = gameobject passed in
		// b = gameobject colliding with
		// contactInfo = information about collision
		//  -- example --
		// private function OnContact(a:GameObject, b:GameObject, contactInfo:ContactInfo) : void
		//  -------------
		public function AddEvent(gameObject:GameObject, callback:Function) : void
		{
			if (events[gameObject.UniqueTag] == null)
			{
				events[gameObject.UniqueTag] = new ContactCallback(callback);
			}
			else
			{
				ContactCallback(events[gameObject.UniqueTag]).AddCallback(callback);
			}
		}
		
		public function RemoveEvents(gameObject:GameObject) : void
		{
			events[gameObject.UniqueTag] = null;
		}
		
		public function RaiseContactEvent(a:GameObject, b:GameObject, contactInfo:ContactInfo) : void
		{
			OnCollision(a, b, contactInfo.Clone());
			
			// Flip normal for object B
			contactInfo.Normal.Multiply(-1);
			contactInfo.Impulse.Multiply(-1);
			OnCollision(b, a, contactInfo);
		}
		
		private function OnCollision(a:GameObject, b:GameObject, contactInfo:ContactInfo) : void
		{
			if (events[a.UniqueTag] != null)
			{
				for each (var callback:Function in ContactCallback(events[a.UniqueTag]).Callbacks) 
				{
					callback(a, b, contactInfo);
				}
			}
		}
		
	}
}