package BalloonGame.GameRelated 
{
	import BalloonGame.Ingame.*;
	import BalloonGame.GameRelated.*;
	import flash.display.*;
	
	/**
	 * ...
	 * @author Free
	 */
	public class MapLoader
	{
		[Embed(source = '../Library/mainFlash.swf', symbol = 'Screen1')]
		private var Map1:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='Screen2')]
		private var Map2:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='Screen3')]
		private var Map3:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='Screen4')]
		private var Map4:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='Screen5')]
		private var Map5:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='TutorialScreen0')]
		private var Tutorial0:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='TutorialScreen1')]
		private var Tutorial1:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='TutorialScreen2')]
		private var Tutorial2:Class;
		
		[Embed(source='../Library/mainFlash.swf', symbol='TutorialScreen3')]
		private var Tutorial3:Class;
		
		public var MapNumber:Number;
		private const totalMaps:Number = 15;
		
		public function MapLoader(mapNumber:Number = 11) 
		{
			this.MapNumber = mapNumber;
		}
		
		public function LoadMapSprite() : Sprite
		{
			var screen:Sprite;
			if (MapNumber == 0)
			{
				screen = new Tutorial0();
			}
			else if (MapNumber == 1)
			{
				screen = new Tutorial1();
			}
			else if (MapNumber == 2)
			{
				screen = new Tutorial2();
			}
			else if (MapNumber == 3)
			{
				screen = new Tutorial3();
			}
			else if (MapNumber == 11)
			{
				screen = new Map1();
			}
			else if (MapNumber == 12)
			{
				screen = new Map2();
			}
			else if (MapNumber == 13)
			{
				screen = new Map3();
			}
			else if (MapNumber == 14)
			{
				screen = new Map4();
			}
			else if (MapNumber == 15)
			{
				screen = new Map5();
			}
			else
			{
				screen = new Sprite();
			}
			
			return screen;
		}
		
		public function IncrementMapNumber() : void
		{
			MapNumber++;
			
			if (MapNumber == 4)
			{
				MapNumber = 11;
			}
		}
		
		public function CanLoadMap() : Boolean
		{
			if (MapNumber <= totalMaps)
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		public function ResetMapNumber() : void
		{
			MapNumber = 0;
		}
		
		public function LoadMap(gameManager:GameManager, screen:Sprite) : void
		{
			// Create player
			if (screen.getChildByName("player1") != null)
			{
				gameManager.player = new Player(screen["player1"])
			}
			else 
			{
				gameManager.player = new Player(screen["player1circle"], GameObject.CIRCLE)
			}
			gameManager.AddGameObject(gameManager.player);
			
			// Create exit
			gameManager.AddGameObject(new Exit(screen["exit"], 0));
			
			for (var i:Number = 0; i < screen.numChildren; i++)
			{
				if (screen.getChildAt(i) is Sprite)
				{
					var obj:Sprite = Sprite(screen.getChildAt(i));
					
					if (obj.name == "exit")
					{
						gameManager.AddGameObject(new Exit(obj, 0));
					}
					else if (obj.name == "staticBox")
					{
						gameManager.AddGameObject(new GameObject(obj, GameObject.BOX, 0));
					}
					else if (obj.name == "dynamicBox")
					{
						gameManager.AddGameObject(new GameObject(obj, GameObject.BOX, 10));
					}
					else if (obj.name == "staticCircle")
					{
						gameManager.AddGameObject(new GameObject(obj, GameObject.CIRCLE, 0));
					}
					else if (obj.name == "dynamicCircle")
					{
						gameManager.AddGameObject(new GameObject(obj, GameObject.CIRCLE, 10));
					}
					else if (obj.name == "staticObstacle")
					{
						gameManager.AddGameObject(new Obstacle(obj, GameObject.BOX, 0));
					}
					else if (obj.name == "staticObstacleCircle")
					{
						gameManager.AddGameObject(new Obstacle(obj, GameObject.CIRCLE));
					}
					else if (obj.name == "dynamicObstacle")
					{
						gameManager.AddGameObject(new Obstacle(obj, GameObject.BOX, 10));
					}
					else if (obj.name == "dynamicObstacleCircle")
					{
						gameManager.AddGameObject(new Obstacle(obj, GameObject.CIRCLE, 10));
					}
					else if (obj.name == "laser")
					{
						gameManager.AddGameObject(new Laser(obj));
					}
					else if (obj.name == "laserOn")
					{
						gameManager.AddGameObject(new Laser(obj, 1, 0));
					}
				}
			}
			
			gameManager.Initalize();
		}
	}

}