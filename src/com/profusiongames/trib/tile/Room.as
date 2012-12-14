package com.profusiongames.trib.tile 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author UG
	 */
	public class Room extends Rectangle
	{
		private var doors:Array = [];
		public function Room(x:int=0, y:int=0, width:int=0, height:int=0) 
		{
			super(x, y, width, height);
		}
		
		public function draw(layout:Array):void 
		{
			for (var i:int = x; i < x + width; i++)
			{
				for (var j:int = y; j < y + height; j++)
				{
					layout[j][i] = 1;
				}
			}
			for (var k:int = 0; k < doors.length; k++)
			{
				layout[doors[k][1]][doors[k][0]] = 2;
			}
		}
		
		public function generateDoors():void 
		{
			doors.length = 0;
			doors.push( [x + width - 1, 0 + y]);
			doors.push( [0 + x, y + height - 1]);
			trace(doors, doors[0], doors[0][0]);
		}
		
		public function doorAt(index:int):Point
		{
			return new Point(doors[index][0], doors[index][1]);
		}
		
		
	}

}