package com.profusiongames.trib 
{
	import com.profusiongames.trib.beings.Player;
	import com.profusiongames.trib.beings.Zombie;
	import com.profusiongames.trib.editor.Editor;
	import com.profusiongames.trib.tile.Map;
	import com.profusiongames.trib.tile.Tile;
	import com.profusiongames.trib.util.ZombieList;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.extensions.lighting.core.LightLayer;
	import starling.extensions.lighting.lights.SpotLight;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Game extends Sprite
	{
		private var editor:Editor;
		private var map:Map;
		private var player:Player;
		private var lightLayer:LightLayer;
		public function Game() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			lightLayer = new LightLayer(640, 480, 0xFFFFFF,0,0);
			
			map = new Map();
			map.buildMap("1", lightLayer);
			addChild(map);
			
			player = new Player(lightLayer);
			map.getEntityLayer().addChild(player);
			
			//lightLayer.addLight(new SpotLight(400, 400, 600, -90, 60, 20, 0x00ff00, 1));
			//spawnInitialZombies();
			//map.addChild(lightLayer);
			map.scaleX = map.scaleY = 0.6;
			
			editor = new Editor();
			addChild(editor);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, frame);
		}
		
		private function frame(e:EnterFrameEvent):void 
		{
			player.update();
			var _zombieList:Vector.<Zombie> = ZombieList.getList()
			for (var i:int = 0; i < _zombieList.length; i++)
			{
				_zombieList[i].separate(_zombieList, i+1);
				_zombieList[i].update();
				if (!_zombieList[i].isAlive)
				{
					ZombieList.removeZombie(_zombieList[i]);
					i--;
				}
			}
			//map.update(player);
			//map.x -= 0.2;
			lightLayer.setShift(map.x, map.y);
		}
		
		public function spawnInitialZombies():void
		{
			var freeTiles:Vector.<Tile> = map.getFloorLevelTiles();
			var randomLocs:Array = [];
			var startingNumberZombies:int = 25;
			for (var i:int = 0; i < startingNumberZombies; i++)
			{
				var r:int = int(Math.random() * freeTiles.length);
				while (randomLocs.indexOf(r) > -1)
				{
					r = int(Math.random() * freeTiles.length);
				}
				randomLocs.push(r);
			}
			
			for (i = 0; i < startingNumberZombies; i++)
			{
				var index:int = randomLocs[i];
				var z:Zombie = ZombieList.makeZombie();
				z.isAlive = true;
				z.x = freeTiles[index].x + freeTiles[index].width/2;
				z.y = freeTiles[index].y + freeTiles[index].height/2;
				map.getEntityLayer().addChild(z);
				ZombieList.addZombie(z);
			}
			
		}
		
	}

}