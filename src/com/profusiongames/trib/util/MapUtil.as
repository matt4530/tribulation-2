package com.profusiongames.trib.util 
{
	import com.profusiongames.trib.tile.Map;
	import com.profusiongames.trib.tile.Room;
	/**
	 * ...
	 * @author UG
	 */
	public class MapUtil 
	{
		
		public function MapUtil() 
		{
			
		}
		
		
		public static function serializeToJSON(m:Map):String
		{
			var s:String = '{ "map":"';
			m.getTiles().join(",");
			s += '" }';
			return s;
		}
		
		public static function isValidRoomLocation(layout:Array, r:Room):Boolean
		{
			var tilesAlreadyRoom:int = 0;
			for (var i:int = r.x; i < r.x + r.width; i++)
			{
				for (var j:int = r.y; j < r.y + r.height; j++)
				{
					if (layout[j][i] != 2)
						tilesAlreadyRoom++;
				}
			}
			if (tilesAlreadyRoom > 2)
				return false;
			return true;
		}
		
	}

}