package BalloonGame 
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class Helper
	{
		public static function GetRandomN(x:Number) : Number
		{
			return GetRandom( -x, x);
		}
		
		public static function GetRandom(a:Number, b:Number) : Number
		{
			return a + (b - a) * Math.random();
		}
		
		public static function GetRandomV(x:Number) : b2Vec2
		{
			return new b2Vec2(GetRandomN(x), GetRandomN(x));
		}
	}

}