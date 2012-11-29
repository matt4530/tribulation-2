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
		private static var _bitmap:Bitmap;
		private static var _texture:Texture;
		private static var _atlas:TextureAtlas;
		private static var _frames:Vector.<Texture>
		private var image:Image;
		
		[Embed(source="../../../../assets/graphics/tiles/tiles.xml", mimeType="application/octet-stream")]
		public const SpriteSheetXML:Class;
		
		[Embed(source="../../../../assets/graphics/tiles/tilesheet.png")]
		public const TileSheet:Class;
		
		public var frame:uint;
		
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
	}
}