package com.profusiongames.trib.util 
{
	import com.profusiongames.trib.beings.Zombie;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class ZombieList 
	{
		//unordered list of zombies that are alive
		private static var list:Vector.<Zombie> = new Vector.<Zombie>();
		//unordered list of zombies that are dead
		private static var pool:Vector.<Zombie> = new Vector.<Zombie>();
		public function ZombieList() 
		{
			
		}
		
		public static function removeZombie(z:Zombie):void
		{
			if (!z.isAlive)
			{
				var i:int = list.indexOf(z);
				list[i] = list[list.length - 1];
				list.length--;
				pool.push(z);
			}
		}
		
		public static function makeZombie():Zombie
		{
			if (pool.length == 0)
			{
				return new Zombie();
			}
			else
			{
				return pool.pop();
			}
		}
		
		public static function addZombie(z:Zombie):void
		{
			list.push(z);
		}
		
		public static function getList():Vector.<Zombie>
		{
			return list;
		}
	}

}