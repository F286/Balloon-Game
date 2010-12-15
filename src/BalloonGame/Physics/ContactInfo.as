package BalloonGame.Physics 
{
	import flash.display.Sprite;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import BalloonGame.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class ContactInfo
	{
		public var P1:b2Vec2;
		public var P2:b2Vec2;
		public var Normal:b2Vec2;
		public var Impulse:b2Vec2;
		public var Intensity:Number;
		
		public function ContactInfo(p1:b2Vec2, p2:b2Vec2, normal:b2Vec2, impulse:b2Vec2, intesity:Number) 
		{
			this.P1 = p1;
			this.P2 = p2;
			this.Normal = normal;
			this.Impulse = impulse;
			this.Intensity = intesity;
		}
		
		public function Clone() : ContactInfo
		{
			return new ContactInfo(P1.Copy(), (P2 == null) ? null : P2.Copy(), Normal.Copy(), Impulse.Copy(), Intensity);
		}
	}

}