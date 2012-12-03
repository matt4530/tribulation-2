package starling.extensions.lighting.lights
{
	import starling.extensions.lighting.core.LightBase;
	/**
	 * @author Szenia
	 */
	public class PointLight extends LightBase
	{
		private var _x:int;
		private var _y:int;
		private var _shiftX:int = 0;
		private var _shiftY:int = 0;
		private var _radius:int;
		
		/**
		 * A light that illuminates the scene equally in all directions
		 * 
		 * @param x x position of the light in world cooridinates
		 * @param y y position of the light in world cooridinates
		 * @param radius radius of the light in world space
		 * @param color RGB color of the light. No alpha channel.
		 * @param brightness brightness modifier. Values > 1 dim the light, values < 1 brighten it.
		 */
		public function PointLight(x:int, y:int, radius:int, color:uint, brightness:Number = 1)
		{
			super(color, brightness);
			
			_x = x;
			_y = y;
			_radius = radius;
		}

		public function get x():int
		{
			return _x + _shiftX;
		}

		public function set x(x:int):void
		{
			_x = x;
		}

		public function get y():int
		{
			return _y + _shiftY;
		}

		public function set y(y:int):void
		{
			_y = y;
		}

		public function get radius():int
		{
			return _radius;
		}

		public function set radius(radius:int):void
		{
			_radius = radius;
		}
		
		public function get shiftX():int 
		{
			return _shiftX;
		}
		
		public function set shiftX(value:int):void 
		{
			_shiftX = value;
		}
		
		public function get shiftY():int 
		{
			return _shiftY;
		}
		
		public function set shiftY(value:int):void 
		{
			_shiftY = value;
		}
	}
}
