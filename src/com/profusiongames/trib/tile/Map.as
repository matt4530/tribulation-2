package com.profusiongames.trib.tile 
{
	import com.profusiongames.trib.beings.Player;
	import com.profusiongames.trib.util.AStar;
	import com.profusiongames.trib.util.MapUtil;
	import com.profusiongames.trib.util.Node;
	import flash.display.Stage;
	import flash.geom.Point;
	import org.flashdevelop.utils.FlashConnect;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.extensions.lighting.core.LightLayer;
	import starling.extensions.lighting.geometry.QuadShadowGeometry;
	import starling.extensions.lighting.lights.PointLight;
	import starling.extensions.lighting.lights.SpotLight;
	import starling.textures.RenderTexture;
	
	public class Map extends Sprite
	{
		private static var instance:Map;
		private var layout:Array;
		private var tileW:int;
		private var tileH:int;
		private var offsetX:int = 0;
		private var offsetY:int = 0;
		
		private var _floor:Sprite = new Sprite();
		private var _renderTexture:RenderTexture;
		//this layer
		private var _items:Sprite = new Sprite();
		private var _walls:Sprite = new Sprite();
		private var _entities:Sprite = new Sprite();
		
		private var nativeStage:Stage;
		//private var mouseLight:PointLight;
		//private var mouseLight2:SpotLight;
		//private var lightLayer:LightLayer;
		//private var lights:Vector.<PointLight>;
		private var _tiles:Vector.<Tile>;
		private var _floorLevelTiles:Vector.<Tile>
		private var _rooms:Vector.<Room>
		//private var _nodes:Array;
		
		private var _dir:Number = 0;
		
		public var mapWidth:int = 0;
		public var mapHeight:int = 0;
		
		public function Map()
		{
			instance = this;
			
			tileW = 32;
			tileH = 32;
			
			//nativeStage = Starling.current.nativeStage;
			//lightLayer = new LightLayer(640, 480, 0x000000,1,1);
			//lights = new Vector.<PointLight>();
			
			//createDefaultLights();
			
			addChild(_floor);
			addChild(_items);
			_renderTexture = new RenderTexture(640, 480);
			_items.addChild(new Image(_renderTexture));
			//addChild(_walls);
			//addChild(lightLayer);
			addChild(_walls);
			addChild(_entities);
			//addChild(lightLayer);
			//this.flatten();
			touchable = false;
		}
		
		public static function getInstance():Map
		{
			return instance;
		}
		
		private function createDefaultLights():void 
		{
			//var spotLight:SpotLight;
			
			/*spotLight = new SpotLight(0, 0, 600, 45, 60, 20, 0xff0000, 1);
			lightLayer.addLight(spotLight);

			spotLight = new SpotLight(640 / 2, 0, 600, 90, 60, 20, 0x00ff00, 1);
			lightLayer.addLight(spotLight);

			spotLight = new SpotLight(640, 0, 600, 135, 60, 20, 0x0000ff, 1);
			lightLayer.addLight(spotLight);*/
			
			//create a white light that will follow the mouse position
			//mouseLight = new PointLight(0, 0, 300, 0xffffff, 1);
			//mouseLight2 = new SpotLight(0, 0, 300, 0, 60, 20, 0xffffff, 1);
		}
		
		public function getFloorLayer():Sprite
		{
			return _floor;
		}
		public function getItemLayer():Sprite
		{
			return _items;
		}
		public function getRenderTexture():RenderTexture
		{
			return _renderTexture;
		}
		public function getWallLayer():Sprite
		{
			return _walls;
		}
		public function getEntityLayer():Sprite
		{
			return _entities;
		}
		
		public function buildMap(map:String, lightLayer:LightLayer):void
		{
			loadMap(map);
			drawMap();
			FlashConnect.atrace("generate rooms");
			generateRooms();
			//setAllTiles();
			FlashConnect.atrace("generate rooms 2");
			generatePathways();
			generateEntrace();
			generateExit();
			//setAllTiles();
			redraw();
			createGeometry(lightLayer);
		}
		
		public function getTileAt(dx:int, dy:int):Tile
		{
			return _tiles[int((dy-offsetY)/32) * layout[0].length + int((dx-offsetX)/32)];
		}
		
		public function getTileAtSlots(dx:int, dy:int):Tile
		{
			if (dx == -1 || dy == -1 || dx >= layout[0].length || dy >= layout.length) return null;
			return _tiles[dy * layout[0].length + dx];
		}
		
		public function getFloorLevelTiles():Vector.<Tile>
		{
			return _floorLevelTiles;
		}
		public function getTiles():Vector.<Tile>
		{
			return _tiles;
		}
		
		
		public function update(player:Player):void 
		{
			//x = -player.x / 2;
			//y = -player.y / 2;
			x = -player.x + 640 / 2;
			y = -player.y + 480 / 2;
		}
		
		private function loadMap(map:String):void 
		{
			layout =  [
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
			];
			
			mapWidth = layout[0].length;
			mapHeight = layout.length;
		}
		
		private function generateRooms():void 
		{
			_rooms = new Vector.<Room>();
			var numRooms:int = 10;
			var rWidthMax:int = 7;
			var rWidthMin:int = 3;
			var rHeightMax:int = 7;
			var rHeightMin:int = 3;
			numRoomsWhile: while (numRooms > 0)
			{
				numRooms--;
				var r:Room = new Room();
				var innerWhileCount:int = 0;
				do {
					r.width = int(Math.random() * (rWidthMax - rWidthMin)) + rWidthMin;
					r.height = int(Math.random() * (rHeightMax - rHeightMin)) + rHeightMin;
					r.x = 1 + int(Math.random() * (mapWidth - 2 - r.width));
					r.y = 1 + int(Math.random() * (mapHeight - 2 - r.height));
					r.generateDoors();
					innerWhileCount++;
					if (innerWhileCount > 50)
					{
						break numRoomsWhile;
					}
				}while (!MapUtil.isValidRoomLocation(this, r));
				r.draw(this);
				_rooms.push(r);
			}
		}
		
		private function generatePathways():void 
		{
			for (var k:int = 0; k < _rooms.length; k++)
			{
				for (var j:int = k+1; j < _rooms.length; j++)
				{
					if (Math.random() < 0.4) continue;//don't do pathing 20% of the time.
					var r:Room = _rooms[k];
					var r2:Room = _rooms[j];
					var rDoor:Point = r.doorAt(0);
					var r2Door:Point = r2.doorAt(0);
					FlashConnect.atrace(rDoor.x, rDoor.y, r2Door.x, r2Door.y, getTileAtSlots(rDoor.x, rDoor.y).frame, getTileAtSlots(rDoor.x, rDoor.y).isDoor);
					var t:Array = AStar.aStar(getTileAtSlots(rDoor.x, rDoor.y), getTileAtSlots(r2Door.x, r2Door.y));// , _tiles[567]);
					if (t == null)
						FlashConnect.atrace("no path");
					else
					{
						for (var i:int = 0; i < t.length; i++)
						{
							t[i].frame = 1;
							//layout[t[i].dy][t[i].dx] = t[i].frame;
						}
					}
				}
			}
		}
		
		private function generateExit():void 
		{
			
		}
		
		private function generateEntrace():void 
		{
			
		}
		
		private function createGeometry(lightLayer:LightLayer):void 
		{
			//lightLayer.addLight(mouseLight);
			//lightLayer.addLight(mouseLight2);
			for (var i:int = 0; i < _tiles.length; i++)
			{
				if (_tiles[i].isLightBlocking())
				{
					var q:Quad = new Quad(tileW, tileH, 0xFFFFFF);
					q.x = _tiles[i].x;
					q.y = _tiles[i].y;
					lightLayer.addShadowGeometry(new QuadShadowGeometry(q));
				}
			}
			
		}
		
		private function drawMap():void
		{
			FlashConnect.atrace("[Map] drawMap()");
			_tiles = new Vector.<Tile>();
			_floorLevelTiles = new Vector.<Tile>();
			var tmpTile:Tile;
			for (var i:uint = 0; i<mapHeight; ++i)
			{
				for (var j:uint = 0; j<mapWidth; ++j)
				{
					tmpTile = new Tile(layout[i][j]);
					tmpTile.dx = j;
					tmpTile.dy = i;
					tmpTile.x = j*tileW + offsetX;
					tmpTile.y = i * tileH + offsetY; 
					if (tmpTile.isFloorLevel())
					{
						//var p:PointLight = new PointLight(tmpTile.x, tmpTile.y, 200, 0xDDDDDD, 1);
						//lightLayer.addLight(p);
						_floorLevelTiles.push(tmpTile);
						_floor.addChild(tmpTile);
					}
					else
						_walls.addChild(tmpTile);
					_tiles.push(tmpTile);
					
					if (i == 0 || j == 0 || i == mapHeight - 1 || j == mapWidth -1)
						tmpTile.isBorderTile = true;
					
					/*var node:Node = new Node(j, i);
					node.x = tmpTile.x;
					node.y = tmpTile.y;
					_nodes.push(node);*/
				}
			}	
		}
		
		private function redraw():void
		{
			var count:int = 0;
			for (var i:uint = 0; i<mapHeight; ++i)
			{
				for (var j:uint = 0; j<mapWidth; ++j)
				{
					_tiles[count].draw();
					count++;
				}
			}
		}
		
		/*private function setAllTiles():void
		{
			var mapWidth:uint = this.layout[0].length;
			var mapHeight:uint = this.layout.length;
			var count:int = 0;
			for (var i:uint = 0; i<mapHeight; ++i)
			{
				for (var j:uint = 0; j<mapWidth; ++j)
				{
					_tiles[count].setTile(layout[i][j]);
					count++;
				}
			}
		}*/
		
		public function reset():void
		{
			for (var i:int = 0; i < _tiles.length; i++)
			{
				_tiles[i].reset();
			}
		}
		
		public function get rooms():Vector.<Room> 
		{
			return _rooms;
		}
	}
}
