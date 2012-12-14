package com.profusiongames.trib.util {
	import com.profusiongames.trib.tile.Map;
	import com.profusiongames.trib.tile.Tile;
	//modified from rocketmandevelopment's AStar
	public class AStar {
		public static var heuristic:Function = manhattan;
		
		public function AStar() {
		}
		
		public static function aStar(start:Tile, end:Tile):Array {
			Map.getInstance().reset();
			var open:Array = [start];
			open[0].isOpen = true;
			var closed:Array = [];
			var currentTile:Tile;
			var path:Array;
			
			while (true) {
				if(open.length == 0) {
					break;
				}
				currentTile = getLowestF(open);
				if(currentTile.dx == end.dx && currentTile.dy == end.dy) {
					path = [currentTile];
					while(true) {
						path.push(currentTile.dParent);
						currentTile = currentTile.dParent;
						if(!currentTile.dParent) {
							path.reverse();
							break;
						}
					}
					break;
				}
				closed.push(currentTile);
				currentTile.isClosed = true;
				var n:Array = currentTile.neighbors;
				for(var i:int = 0; i < n.length; i++) {
					if(n[i] == null || !n[i].isWalkable) {
						continue;
					}
					if(!n[i].isOpen && !n[i].isClosed) {
						open.push(n[i]);
						n[i].isOpen = true;
						if(isDiagonal(currentTile, n[i])) {
							n[i].g = 1.4;
						} else {
							n[i].g = 1;
						}
						n[i].dParent = currentTile;
						n[i].g += n[i].dParent.g;
						n[i].h = heuristic(n[i], end);
						n[i].f = n[i].g + n[i].h;
					} else {
						var tg:Number;
						if(isDiagonal(currentTile, n[i])) {
							tg = 1.4;
						} else {
							tg = 1
						}
						tg += currentTile.g;
						if(tg < n[i].g) {
							n[i].g = tg;
							n[i].f = n[i].g + n[i].h;
							n[i].dParent = currentTile;
						}
					}
					
				}
			}
			return path;
		}
		
		public static function diagonal(current:Tile, end:Tile):Number {
			var xDistance:int = Math.abs(current.dx - end.dx);
			var yDistance:int = Math.abs(current.dy - end.dy);
			if(xDistance > yDistance) {
				return yDistance + (xDistance - yDistance);
			} else {
				return xDistance + (yDistance - xDistance);
			}
			return 0;
		}
		
		public static function manhattan(current:Tile, end:Tile):Number {
			return Math.abs(current.dx - end.dx) + Math.abs(current.dy + end.dy);
		}
		
		private static function getLowestF(list:Array):Tile {
			list.sortOn("f", Array.NUMERIC | Array.DESCENDING);
			return list.pop();
		}
		
		private static function isDiagonal(center:Tile, other:Tile):Boolean {
			if(center.dx != other.dx && center.dy != other.dy) {
				return true;
			}
			return false;
		}
	}
}