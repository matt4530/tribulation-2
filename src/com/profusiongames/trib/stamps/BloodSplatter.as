package com.profusiongames.trib.stamps 
{
	import com.profusiongames.trib.tile.Map;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BloodSplatter
	{
		//splatter 1 by http://trak.mercenariesguild.net/
		[Embed(source = "../../../../assets/graphics/stamps/blood_splatter.png")]private static const Blood:Class;
		//splatter 2 by http://opengameart.org/users/johndh
		[Embed(source = "../../../../assets/graphics/stamps/blood_splatter2.png")]private static const Blood2:Class;
		public function BloodSplatter() 
		{
			
		}
		
		public static function draw(x:Number, y:Number):void
		{
			var r:RenderTexture = Map.getInstance().getRenderTexture();
			var chosen:Class = Math.random() > 0.2 ? Blood : Blood2;
			var i:Image = new Image(Texture.fromBitmap(new chosen(), true, true));
			i.x = x;
			i.y = y;
			i.pivotX = i.width / 2;
			i.pivotY = i.height / 2;
			i.rotation = Math.random() * 2 * Math.PI
			i.scaleX = i.scaleY = Math.random() * 0.8 + 0.2;
			r.draw(i);
		}
		
	}

}