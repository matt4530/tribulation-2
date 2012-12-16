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
		
		public static function isValidRoomLocation(map:Map, r:Room):Boolean
		{
			if (r.x + r.width > map.mapWidth-1) return false;
			if (r.y + r.height > map.mapHeight-1) return false;
			if (r.x < 1 || r.y  < 1) return false;
			
			var tilesAlreadyRoom:int = 0;
			for (var i:int = r.x; i < r.x + r.width; i++)
			{
				for (var j:int = r.y; j < r.y + r.height; j++)
				{
					if (map.getTileAtSlots(i,j).frame != 2)
						tilesAlreadyRoom++;
				}
			}
			if (tilesAlreadyRoom > 2)
				return false;
			return true;
		}
		
	}

}