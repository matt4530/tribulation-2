package com.profusiongames.trib.tile 
{
	import com.profusiongames.trib.beings.Player;
	import com.profusiongames.trib.util.Node;
	import flash.display.Stage;
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
		//private var _nodes:Array;
		
		private var _dir:Number = 0;
		
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
			drawMap(lightLayer);
			createGeometry(lightLayer);
		}
		
		public function getTileAt(dx:int, dy:int):Tile
		{
			return _tiles[int((dy-offsetY)/32) * layout[0].length + int((dx-offsetX)/32)];
		}
		
		public function getTileAtSlots(dx:int, dy:int):Tile
		{
			return _tiles[dy * layout[0].length + dx];
		}
		
		public function getFloorLevelTiles():Vector.<Tile>
		{
			return _floorLevelTiles;
		}
		
		
		
		public function update(player:Player):void 
		{
			//x = -player.x / 2;
			//y = -player.y / 2;
			x = -player.x + 640 / 2;
			y = -player.y + 480 / 2;
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
		
		private function drawMap(lightLayer:LightLayer):void
		{
			_tiles = new Vector.<Tile>();
			_floorLevelTiles = new Vector.<Tile>();
			var mapWidth:uint = this.layout[0].length;
			var mapHeight:uint = this.layout.length;
			var tmpTile:Tile;
			for (var i:uint = 0; i<mapHeight; ++i)
			{
				for (var j:uint = 0; j<mapWidth; ++j)
				{
					tmpTile = new Tile(layout[i][j]);
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
					
					/*var node:Node = new Node(j, i);
					node.x = tmpTile.x;
					node.y = tmpTile.y;
					_nodes.push(node);*/
				}
			}	
		}
		
		private function loadMap(map:String):void 
		{
			/*layout =  [
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2], 
				[2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2], 
				[2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2], 
				[2, 1, 2, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2], 
				[2, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2], 
				[2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2],
				[2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2],
				[2, 1, 1, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
				[2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
			];*/
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
				[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
			];
			maskBorder();
			createRooms();
			removeExcessDoors();
		}
		
		private function maskBorder():void 
		{
			var bottom:Array = layout[0].slice();
			var top:Array = layout[0].slice();
			trace(layout.length);
			layout.unshift(bottom);
			layout.push(top);
			for (var k:int = 1; k < layout.length-1; k++)
			{
				layout[k].push(2,2);
			}
			
		}
		
		private function removeExcessDoors():void 
		{
			for (var j:int = 1; j < layout[0].length-1; j++)
			{
				for (var k:int = 1; k < layout.length-1; k++)
				{
					if (layout[k][j] == 3)
					{
						var count:int = 0;
						for (var dj:int = 0; dj < 3; dj++)
						{
							for (var dk:int = 0; dk < 3; dk++)
							{
								if (layout[k - 1 + dk][j - 1 + dj] == 1)
									count++;
									//trace(count);
							}
						}
						if (count > 7)
							layout[k][j] = 1;
					}
				}
			}
		}
		
		private function createRooms():void 
		{
			var count:int = 9;
			var maxWidth:int = 8;
			var maxHeight:int = 8;
			var minWidth:int = 3;
			var minHeight:int = 3;
			
			for (var i:int = 0; i < count; i++)
			{
				var w:int = int(Math.random() * (maxWidth - minWidth)) + minWidth;
				var h:int = int(Math.random() * (maxHeight - minHeight)) + minHeight;
				var rx:int = 0;
				var ry:int = 0;
				do {
					rx = int(Math.random() * (layout[0].length - 2)) + 1;
					ry = int(Math.random() * (layout.length - 2)) +  1;
				} while (!isValidRoomLocation(rx,ry, w, h));
				trace("Selected Room @ ", rx, ry, w, h);
				fillRoom(rx, ry, w, h);
				generateDoorPlacements(rx, ry, w, h);
			}
		}
		
		private function generateDoorPlacements(rx:int, ry:int, w:int, h:int):void 
		{
			var area:int = w * h;
			var doorCount:int = area < 10 ? 1 : area < 20 ? 2 : 3;
			var perimiterCount:int = w * 2 + h * 2 - 8;
			var doors:Array = [];
			for (var i:int = 0; i < doorCount; i++)
			{
				var doorIndex:int = 0;
				do {
					doorIndex = int(Math.random() * perimiterCount);
				}while (!isValidDoorLocation(doors,doorIndex));
				doors.push(doorIndex);
			}
			
			var perimiterLocs:Array = [];
			var j:int = 0;
			for (j = rx; j < rx + w; j++)
			{
				perimiterLocs.push([j, ry]);
			}
			for (j = ry; j < ry + h; j++)
			{
				perimiterLocs.push([rx + w-1, j]);
			}
			for (j = rx + w-1; j >= rx; j--)
			{
				perimiterLocs.push([j, ry + h-1]);
			}
			for (j = ry + h-1; j >= ry ; j--)
			{
				perimiterLocs.push([rx, j]);
			}
			for (j = 0; j < doors.length; j++)
			{
				var loc:Array = perimiterLocs[doors[j]];
				layout[loc[1]][loc[0]] = 3;
			}
			/*for (j = 0; j < perimiterLocs.length; j++)
			{
				var loc:Array = perimiterLocs[j];
				layout[loc[1]][loc[0]] = 3;
			}*/
			
			/*for (var k:int = ry; k < ry + h; k++)
				{
					if (k == ry || k == ry + h - 1 || j == rx || j == rx + w -1)
					{
						if (doors.indexOf(index) != -1) 
							layout[k][j] = 3;
						index++;
					}
				}*/
		}
		
		private function isValidDoorLocation(doors:Array, doorIndex:int):Boolean
		{
			if (doors.indexOf(doorIndex) != -1) return false;
			
			for (var i:int = 0; i < doors.length; i++)
			{
				if (Math.abs(doors[i] - doorIndex) < 3) return false;
			}
			return true;
		}
		
		private function fillRoom(rx:int, ry:int, w:int, h:int):void 
		{
			for (var j:int = rx; j < rx + w; j++)
			{
				for (var k:int = ry; k < ry + h; k++)
				{
					layout[k][j] = 1;
				}
			}
		}
		
		private function isValidRoomLocation(rx:int, ry:int, w:int, h:int):Boolean
		{
			rx -= 1;
			ry -= 1;
			w += 1;
			h += 1;
			if (ry + h+1 > layout.length) return false;
			if (rx + w+1 > layout[0].length) return false;
			var count:int = 0;
			for (var j:int = rx; j < rx + w; j++)
			{
				for (var k:int = ry; k < ry + h; k++)
				{
					if (layout[k][j] != 2) count++;
				}
			}
			if (count / (w * h) > 0.15) return false; //if it already has 80% of the room in open air, regenerate
			return true;
		}
	}
}
