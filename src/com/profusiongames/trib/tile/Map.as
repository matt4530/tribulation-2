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
		
		private function loadMap(map:String):void 
		{
			layout =  [
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
			];
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
	}
}
