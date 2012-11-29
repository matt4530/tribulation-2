package com.profusiongames.trib.bullets 
{
	import com.profusiongames.trib.beings.Zombie;
	import com.profusiongames.trib.tile.Map;
	import com.profusiongames.trib.util.Vector2D;
	import com.profusiongames.trib.util.ZombieList;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class StandardBullet extends Bullet 
	{
		
		public function StandardBullet(map:Map) 
		{
			super(map);
		}
		
		
		/*
		 * Just get the closet zombie, since non-piercing round, shorten _end so it only draws to this zombie
		 */
		override protected function scanForZombies():Vector.<Zombie> 
		{
			_collidedWith.length = 0;
			var closest:Vector2D = null;
			var closestIndex:int = 0;
			var closestDistance:Number = (_end.x - _start.x) * (_end.x - _start.x) + (_end.y - _start.y) * (_end.y - _start.y);
			var _v:Vector.<Zombie> = ZombieList.getList();
			var _z:Zombie;
			for (var i:int = 0; i < _v.length; i++)
			{
				_z = _v[i];
				var obj:Object = lineIntersectCircle(_start, _end, new Vector2D(_z.x, _z.y), _z.radiusDim);
				if (obj.intersects)
				{
					if (obj.enter)
					{
						var dx:Number = obj.enter.x - _start.x;
						var dy:Number = obj.enter.y - _start.y;
						var distSquared:Number = dx * dx + dy * dy;
						if (distSquared < closestDistance)
						{
							closestDistance = distSquared;
							closest = obj.enter;
							closestIndex = i;
						}
					}
					else if (obj.exit)
					{
						var dx2:Number = obj.exit.x - _start.x;
						var dy2:Number = obj.exit.y - _start.y;
						var distSquared2:Number = dx2 * dx2 + dy2 * dy2;
						if (distSquared2 < closestDistance)
						{
							closestDistance = distSquared2;
							closest = obj.exit;
							closestIndex = i;
						}
					}
				}
			}
			if (closest != null)
			{
				_end = closest;
				_collidedWith.push(_v[closestIndex]);
			}
			return _collidedWith;
		}
		
	}

}