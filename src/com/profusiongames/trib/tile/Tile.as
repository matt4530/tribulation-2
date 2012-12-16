package com.profusiongames.trib.tile 
{
	import flash.display.Bitmap;
	import starling.display.BlendMode;
	import starling.display.Image;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Tile extends Sprite
	{
		//pathfinding util
		public var f:Number = 0;
		public var g:Number = 0;
		public var h:Number = 0;
		public var dx:int = 0;
		public var dy:int = 0;
		public var isClosed:Boolean = false;
		public var isOpen:Boolean = false;
		private var _isPathWalkable:Boolean = true;
		private var _neighbors:Array;
		public var dParent:Tile;
		
		private var _isBorderTile:Boolean;
		private var _isDoor:Boolean;
		private static var _bitmap:Bitmap;
		private static var _texture:Texture;
		private static var _atlas:TextureAtlas;
		private static var _frames:Vector.<Texture>
		private var image:Image;
		private var dirtyImage:Boolean = false;
		[Embed(source="../../../../assets/graphics/tiles/tiles.xml", mimeType="application/octet-stream")]
		public const SpriteSheetXML:Class;
		
		[Embed(source="../../../../assets/graphics/tiles/tilesheet.png")]
		public const TileSheet:Class;
		
		private var _frame:uint;
		
		public function Tile(frame:uint=0)
		{
			this.frame = frame;
			if (_bitmap == null)
			{
				_bitmap = new TileSheet();
				_texture = Texture.fromBitmap(_bitmap);
				var xml:XML = XML(new SpriteSheetXML());
				_atlas = new TextureAtlas(_texture, xml);
				_frames = _atlas.getTextures();
			}
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void
		{
			image = new Image(_frames[frame]);
			image.blendMode = BlendMode.NONE; //kills shadows completely. don't do this.
			addChild(image);
		}
		public function isLightBlocking():Boolean
		{
			return frame == 2;
		}
		public function isFloorLevel():Boolean
		{
			return (frame == 0 || frame == 1 || frame == 3);
		}
		
		public function get neighbors():Array 
		{
			if(!_neighbors) {
				_neighbors = [];
				var m:Map = Map.getInstance();
				//_neighbors.push(m.getTileAtSlots(dx - 1, dy - 1));
				_neighbors.push(m.getTileAtSlots(dx, dy - 1));
				//_neighbors.push(m.getTileAtSlots(dx + 1, dy - 1));
				_neighbors.push(m.getTileAtSlots(dx + 1, dy));
				//_neighbors.push(m.getTileAtSlots(dx + 1, dy + 1));
				_neighbors.push(m.getTileAtSlots(dx, dy + 1));
				//_neighbors.push(m.getTileAtSlots(dx - 1, dy + 1));
				_neighbors.push(m.getTileAtSlots(dx - 1, dy));
				var len:int = _neighbors.length
				for(var i:int = len - 1; i >= 0; i--) {
					if(_neighbors[i] == null) {
						_neighbors.splice(i, 1);
					}
				}
			}
			return _neighbors;
		}
		
		public function get isDoor():Boolean 
		{
			return _isDoor;
		}
		
		public function set isDoor(value:Boolean):void 
		{
			_isDoor = value;
		}
		
		public function get frame():uint 
		{
			return _frame;
		}
		
		public function set frame(value:uint):void 
		{
			_frame = value;
			dirtyImage = true;
		}
		
		public function get isPathWalkable():Boolean 
		{
			if (isDoor) return true;
			return frame != -1 && !isBorderTile;
		}
		
		public function set isPathWalkable(value:Boolean):void 
		{
			_isPathWalkable = value;
		}
		
		public function get isBorderTile():Boolean 
		{
			return _isBorderTile;
		}
		
		public function set isBorderTile(value:Boolean):void 
		{
			_isBorderTile = value;
		}
		
		public function reset():void
		{
			f = 0;
			g = 0;
			h = 0;
			isClosed = false;
			isOpen = false;
			dParent = null;
		}
		
		public function draw():void 
		{
			dirtyImage = false;
			if (image != null)
			{
				removeChild(image);
				image.dispose();
			}
			image = new Image(_frames[frame]);
			image.blendMode = BlendMode.NONE;
			addChild(image);
		}
	}
}