package com.profusiongames.trib.util 
{
	import com.untoldentertainment.pathfinding.INode;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Node implements INode 
	{
		//Our interface variables since we inherit from MovieClip x and y are already set
		private var _parentNode:INode;		
		private var _f:Number;
		private var _g:Number;
		private var _h:Number;
		private var _traversable:Boolean = true;
		private var _x:Number;
		private var _y:Number;
		
		private var _row:int;
		private var _col:int;
		public function Node(r:int, c:int) 
		{
			_row = r;
			_col = c;
		}
		
		/* INTERFACE com.untoldentertainment.pathfinding.INode */
		public function get parentNode():INode { return _parentNode; }		
		public function set parentNode(value:INode):void 
		{
			_parentNode = value;
		}
		
		public function get f():Number { return _f; }		
		public function set f(value:Number):void 
		{
			_f = value;
		}
		
		public function get g():Number { return _g; }		
		public function set g(value:Number):void 
		{
			_g = value;
		}
		
		public function get h():Number { return _h; }		
		public function set h(value:Number):void 
		{
			_h = value;
		}
		
		public function get traversable():Boolean { return _traversable; }		
		public function set traversable(value:Boolean):void 
		{
			_traversable = value;
		}
		
		public function get row():int { return _row; }		
		public function set row(value:int):void 
		{
			_row = value;
		}
		
		public function get col():int { return _col; }		
		public function set col(value:int):void 
		{
			_col = value;
		}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void 
		{
			_x = value;
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void 
		{
			_y = value;
		}
		
	}

}