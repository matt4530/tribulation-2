package com.profusiongames.trib.bullets 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.profusiongames.trib.beings.Player;
	import com.profusiongames.trib.beings.Zombie;
	import com.profusiongames.trib.tile.Map;
	import com.profusiongames.trib.util.Vector2D;
	import com.profusiongames.trib.util.ZombieList;
	import com.profusiongames.trib.weapons.Weapon;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Bullet extends Sprite
	{
		private var _map:Map;
		
		protected var _start:Vector2D;
		protected var _end:Vector2D;
		private var _shape:Shape;
		
		protected var _collidedWith:Vector.<Zombie> = new Vector.<Zombie>();
		protected var _damage:Number = 10;
		protected var _power:Number = 3.5;
		public function Bullet(map:Map) 
		{
			_map = map;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			TweenLite.to(this, 1, { alpha:0, onComplete:kill, ease:Cubic.easeIn } );
			//addEventListener(EnterFrameEvent.ENTER_FRAME, frame);
		}
		
		protected function kill():void 
		{
			parent.removeChild(this, true);
		}
		
		protected function frame(e:EnterFrameEvent):void 
		{
			alpha -= 0.1;
			if (alpha == 0)
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, frame);
				parent.removeChild(this);
			}
		}
		
		public function shootFromPlayer(player:Player, weapon:Weapon):void
		{
			_start = new Vector2D(player.x, player.y);
			_end = calculateEndPoint(_start, player.getRadians() + weapon.getRandomWiggle());
			scanForZombies();
			damageZombies();
			draw();
			addToScreen();
		}
		
		/*
		 * Should calculate the end point for draw, if needs to be shorter
		 * Returns vector of zombies that the line touched, depending on bullet type
		 */
		protected function scanForZombies():Vector.<Zombie> 
		{
			_collidedWith.length = 0;
			var _v:Vector.<Zombie> = ZombieList.getList();
			var _z:Zombie;
			for (var i:int = 0; i < _v.length; i++)
			{
				_z = _v[i];
				var obj:Object = lineIntersectCircle(_start, _end, new Vector2D(_z.x, _z.y), _z.radiusDim);
				if (obj.intersects)
				{
					_collidedWith.push(_z);
				}
			}
			return _collidedWith;
		}
		
		/*
		 * Push zombies back, deal damage
		 */
		protected function damageZombies():void 
		{
			var _z:Zombie;
			for (var i:int = 0; i < _collidedWith.length; i++)
			{
				_z = _collidedWith[i];
				var vAdd:Vector2D = new Vector2D(_start.x - _z.x,_start.y -  _z.y);
				vAdd.normalize().multiplyLength(-_power);
				_z.addSpeed(vAdd.x, vAdd.y);
				_z.takeDamage(_damage);
			}
		}
		
		protected function draw():void 
		{
			_shape = new Shape();
			_shape.graphics.lineStyle(2, 0xFFFFFF);
			_shape.graphics.moveTo(_start.x, _start.y);
			_shape.graphics.lineTo(_end.x, _end.y);
			addChild(_shape);
		}
		
		private function addToScreen():void 
		{
			_map.getItemLayer().addChild(this);
		}
		
		protected function calculateEndPoint(s:Vector2D, radians:Number, distanceOfBullet:Number = 999):Vector2D
		{
			var tileSize:int = 32;
			var e:Vector2D = new Vector2D(s.x + Math.cos(radians) * distanceOfBullet, s.y + Math.sin(radians) * distanceOfBullet);
			//trace(s.x, s.y, e.x, e.y, radians);
			var p1:Vector2D = new Vector2D(s.x / tileSize, s.y / tileSize);
			var p2:Vector2D = new Vector2D(e.x / tileSize, e.y / tileSize);
			
			//if its in same square, don't do it. This case will never happen. Leaving it in for future useage.
			if (int(p1.x) == int(p2.x) && int(p1.y) == int(p2.y))
				return p1;
			
			var stepX:int = ( p2.x > p1.x ) ? 1 : -1;
			var stepY:int = ( p2.y > p1.y ) ? 1 : -1;
				
			var rayDirection:Vector2D = new Vector2D( p2.x - p1.x, p2.y - p1.y );

			//find out how far to move on each axis for every whole integer step on the other
			var ratioX:Number = rayDirection.x / rayDirection.y;
			var ratioY:Number = rayDirection.y / rayDirection.x;

			var deltaY:Number = p2.x - p1.x;
			var deltaX:Number = p2.y - p1.y;
			//faster than Math.abs()...
			deltaX = deltaX < 0 ? -deltaX : deltaX;
			deltaY = deltaY < 0 ? -deltaY : deltaY;
			
			//initialise the integer test coordinates with the coordinates of the starting tile, in tile space ( integer )
			//Note: using noralised version of p1
			var testX:int = int(p1.x); 
			var testY:int = int(p1.y);

			//initialise the non-integer step, by advancing to the next tile boundary / ( whole integer of opposing axis )
			//if moving in positive direction, move to end of curent tile, otherwise the beginning
			var maxX:Number = deltaX * ( ( stepX > 0 ) ? ( 1.0 - (p1.x % 1) ) : (p1.x % 1) ); 
			var maxY:Number = deltaY * ( ( stepY > 0 ) ? ( 1.0 - (p1.y % 1) ) : (p1.y % 1) );
	
			var endTileX:int = int(p2.x);
			var endTileY:int = int(p2.y);
			
			var hit:Boolean;
			var collisionPoint:Vector2D = new Vector2D();
			while ( testX != endTileX || testY != endTileY ) {
				//trace("testX:", testX, "  testY:", testY, "  maxX:", maxX, "  maxY:",maxY);
				if (  maxX < maxY ) {
				
					maxX += deltaX;
					testX += stepX;
					
					if ( _map.getTileAtSlots( testX, testY ).isLightBlocking()) {
						collisionPoint.x = testX;
						if ( stepX < 0 ) collisionPoint.x += 1.0; //add one if going left
						collisionPoint.y = p1.y + ratioY * ( collisionPoint.x - p1.x);	
						collisionPoint.x *= tileSize;//scale up
						collisionPoint.y *= tileSize;
						return collisionPoint;
					}
				
				} else {
					
					maxY += deltaY;
					testY += stepY;
					if ( _map.getTileAtSlots( testX, testY ).isLightBlocking() ) {
						collisionPoint.y = testY;
						if ( stepY < 0 ) collisionPoint.y += 1.0; //add one if going up
						collisionPoint.x = p1.x + ratioX * ( collisionPoint.y - p1.y);
						collisionPoint.x *= tileSize;//scale up
						collisionPoint.y *= tileSize;
						return collisionPoint;
					}
				}
			}
			//no collision found, return endpoint
			return e;
		}
		
		
		/*---------------------------------------------------------------------------
			Returns an Object with the following properties:
				enter			-Intersection Point entering the circle.
				exit			-Intersection Point exiting the circle.
				inside			-Boolean indicating if the points of the line are inside the circle.
				tangent			-Boolean indicating if line intersect at one point of the circle.
				intersects		-Boolean indicating if there is an intersection of the points and the circle.
			 
			If both "enter" and "exit" are null, or "intersects" == false, it indicates there is no intersection.
			 
			This is a customization of the intersectCircleLine Javascript function found here:
			 
			http://www.kevlindev.com/gui/index.htm
			 
			----------------------------------------------------------------------------*/
		protected static function lineIntersectCircle(A : Vector2D, B : Vector2D, C : Vector2D, r : Number = 1):Object {
			var result : Object = new Object ();
			result.inside = false;
			result.tangent = false;
			result.intersects = false;
			result.enter=null;
			result.exit=null;
			var a : Number = (B.x - A.x) * (B.x - A.x) + (B.y - A.y) * (B.y - A.y);
			var b : Number = 2 * ((B.x - A.x) * (A.x - C.x) +(B.y - A.y) * (A.y - C.y));
			var cc : Number = C.x * C.x + C.y * C.y + A.x * A.x + A.y * A.y - 2 * (C.x * A.x + C.y * A.y) - r * r;
			var deter : Number = b * b - 4 * a * cc;
			if (deter <= 0 ) {
				result.inside = false;
			} else {
				var e : Number = Math.sqrt (deter);
				var u1 : Number = ( - b + e ) / (2 * a );
				var u2 : Number = ( - b - e ) / (2 * a );
				if ((u1 < 0 || u1 > 1) && (u2 < 0 || u2 > 1)) {
					if ((u1 < 0 && u2 < 0) || (u1 > 1 && u2 > 1)) {
						result.inside = false;
					} else {
						result.inside = true;
					}
				} else {
					if (0 <= u2 && u2 <= 1) {
						result.enter=Vector2D.interpolate (A, B, 1 - u2);
					}
					if (0 <= u1 && u1 <= 1) {
						result.exit=Vector2D.interpolate (A, B, 1 - u1);
					}
					result.intersects = true;
					if (result.exit != null && result.enter != null && result.exit.equals (result.enter)) {
						result.tangent = true;
					}
				}
			}
			return result;
		}
		
	}

}