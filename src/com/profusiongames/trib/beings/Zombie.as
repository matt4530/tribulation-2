package com.profusiongames.trib.beings 
{
	import com.profusiongames.trib.stamps.BloodSplatter;
	import com.profusiongames.trib.tile.Map;
	import com.profusiongames.trib.tile.Tile;
	import com.profusiongames.trib.util.Vector2D;
	import starling.display.Quad;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Zombie extends Entity
	{
		private var _map:Map;
		private var _halfHeight:int = 8;
		private var _halfWidth:int = 8;
		private var _height:int = 16;
		private var _width:int = 16;
		
		private var _boundDim:int = 23;
		public var radiusDim:int = 12;
		
		private var speed:Number = 0.5;
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		private var displaceXSpeed:Number = 0;
		private var displaceYSpeed:Number = 0;
		private var q:Quad;
		public function Zombie() 
		{
			_maxHealth = _health = 100;
			isAlive = true;
			
			q = new Quad(_width, _height, 0x00FF00);
			//q.x = -_halfWidth;
			//q.y = -_halfHeight;
			q.pivotX = _halfWidth;
			q.pivotY = _halfHeight;
			addChild(q);
			
			
			var e:Quad = new Quad(1, 1, 0xFF0000);
			addChild(e);
			_map = Map.getInstance();
		}
		
		public function update():void
		{
			if (canSeePlayer()) //or maybe within agro distance?
			{
				moveTowardsPlayer();
			}
			else
			{
				xSpeed = ySpeed = 0;
			}
			xSpeed += displaceXSpeed;
			ySpeed += displaceYSpeed
			displaceXSpeed = 0;
			displaceYSpeed = 0;
			move();
		}
		
		private function moveTowardsPlayer():void 
		{
			faceTowardPlayer();
			
		}
		
		private function move():void 
		{
			//x += xSpeed;
			//y += ySpeed;
			
			//trace(width, height);
			
			var topLeft:Tile;
			var topRight:Tile;
			var bottomLeft:Tile;
			var bottomRight:Tile;
				
			if (xSpeed < 0)
			{
				x += xSpeed;
				topLeft =_map.getTileAt(x - _boundDim/2, y - _boundDim/2);
				bottomLeft = _map.getTileAt(x - _boundDim/2, y + _boundDim/2);
				if (!topLeft.isFloorLevel() && x - _boundDim/2 < topLeft.x + topLeft.width)
				{
					x = topLeft.x + topLeft.width + _boundDim/2;
				}
				else if (!bottomLeft.isFloorLevel() && x - _boundDim/2 < bottomLeft.x + bottomLeft.width)
				{
					x = bottomLeft.x + topLeft.width + _boundDim/2;
				}
			}
			else if (xSpeed > 0)
			{
				x += xSpeed;
				topRight = _map.getTileAt(x + _boundDim/2, y - _boundDim/2);
				bottomRight = _map.getTileAt(x + _boundDim/2, y + _boundDim/2);
				if (!topRight.isFloorLevel() && x + _boundDim/2 > topRight.x)
				{
					x = topRight.x - _boundDim/2 - .1;
				}
				else if (!bottomRight.isFloorLevel() && x + _boundDim/2 > bottomRight.x)
				{
					x = bottomRight.x - _boundDim/2 - .1;
				}
			}				
			
			
			if (ySpeed < 0)
			{
				y += ySpeed;
				topLeft = _map.getTileAt(x - _boundDim/2, y - _boundDim/2);
				topRight = _map.getTileAt(x + _boundDim/2, y - _boundDim/2);
				//trace(topLeft.isFloorLevel(), topRight.isFloorLevel());
				if (!topLeft.isFloorLevel() && y - _boundDim/2 < topLeft.y + topLeft.height)
				{
					y = topLeft.y + topLeft.height + _boundDim/2;
				}
				else if (!topRight.isFloorLevel() && y - _boundDim/2 < topRight.y + topRight.height)
				{
					y = topRight.y + topRight.height + _boundDim/2;
				}
			}
			else if (ySpeed > 0)
			{
				y += ySpeed;
				bottomLeft = _map.getTileAt(x -_boundDim/2, y + _boundDim/2);
				bottomRight = _map.getTileAt(x + _boundDim/2, y + _boundDim/2);
				if (!bottomLeft.isFloorLevel() && y + _boundDim/2 > bottomLeft.y)
				{
					y = bottomLeft.y - _boundDim/2 - .01;
				}
				else if (!bottomRight.isFloorLevel() && y + _boundDim/2 > bottomRight.y)
				{
					y = bottomRight.y - _boundDim/2 - .01;
				}
			}
				
		}
		
		private function faceTowardPlayer():void 
		{
			var p:Player = Player.getInstance();
			var angleToPlayer:Number = Math.atan2(p.y - y, p.x -x) * 180 / Math.PI;
			var currentRotation:Number = q.rotation * 180 / Math.PI;
			var turn:Number = (angleToPlayer - currentRotation + 180) % 360 - 180;
			//trace(turn);
			if (turn > .05)
				q.rotation += 0.05;
			else if (turn < 0.05)
				q.rotation -= 0.05;
			xSpeed = Math.cos(q.rotation) * speed
			ySpeed = Math.sin(q.rotation) * speed
		}
		
		public function canSeePlayer():Boolean
		{
			var s:Vector2D = new Vector2D(Player.getInstance().x, Player.getInstance().y);
			var e:Vector2D = new Vector2D(x, y);
			return canSeePlayerHelper(s, e);
		}
		
		public function separate(zombieList:Vector.<Zombie>, startIndex:int):void 
		{
			var G:Number = 100;
			for (var i:int = startIndex; i < zombieList.length; i++)
			{
				var dx:Number = zombieList[i].x - x;
				var dy:Number = zombieList[i].y - y;
				var dist:Number = Math.sqrt(dx * dx + dy * dy);
				var fx:Number;
				var fy:Number;
				//trace(dist, zombieList[i].x, zombieList[i].y, x, y);
				if (dist < _boundDim + 10)//stronger
				{
					G = 100;
					dx /= dist;
					dy /= dist;
					fx = G / (dist * dist) * dx;
					fy = G / (dist * dist) * dy;
					
					zombieList[i].addSpeed(fx, fy);
					//trace("pushing away by ", fx, fy);
				}
				else if (dist < _boundDim + 15) //weaker
				{
					G = 10;
					dx /= dist;
					dy /= dist;
					fx = G / (dist * dist) * dx;
					fy = G / (dist * dist) * dy;
					
					zombieList[i].addSpeed(fx, fy);
				}
			}
		}
		
		public function addSpeed(sx:Number, sy:Number):void
		{
			displaceXSpeed += sx;
			displaceYSpeed += sy;
		}
		
		public function takeDamage(damage:Number):void 
		{
			BloodSplatter.draw(x, y);
			_health -= damage;
			if (_health < 0)
			{
				_health = 0;
				isAlive = false;
			}
		}
		
		private function canSeePlayerHelper(s:Vector2D, e:Vector2D):Boolean
		{
			var tileSize:int = 32;
			//trace(s.x, s.y, e.x, e.y, radians);
			var p1:Vector2D = new Vector2D(s.x / tileSize, s.y / tileSize);
			var p2:Vector2D = new Vector2D(e.x / tileSize, e.y / tileSize);
			
			//if its in same square, don't do it. This case will never happen. Leaving it in for future useage.
			if (int(p1.x) == int(p2.x) && int(p1.y) == int(p2.y))
				return true;
			
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
						return false;
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
						return false;
					}
				}
			}
			//no collision found, return endpoint
			return true;
		}
		
	}

}