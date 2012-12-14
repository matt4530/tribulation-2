package com.profusiongames.trib.beings 
{
	import com.profusiongames.trib.bullets.Bullet;
	import com.profusiongames.trib.tile.Map;
	import com.profusiongames.trib.tile.Tile;
	import com.profusiongames.trib.weapons.Pistol;
	import com.profusiongames.trib.weapons.Weapon;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.lighting.core.LightLayer;
	import starling.extensions.lighting.lights.PointLight;
	import starling.extensions.lighting.lights.SpotLight;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Player extends Entity 
	{
		private static var instance:Player;
		
		private var _upPressed:Boolean = false;
		private var _leftPressed:Boolean = false;
		private var _rightPressed:Boolean = false;
		private var _downPressed:Boolean = false;
		private var _mousePressed:Boolean = false;
		private var speed:int = 5;
		
		private var _halfHeight:int = 8;
		private var _halfWidth:int = 8;
		private var _height:int = 16;
		private var _width:int = 16;
		
		private var _lightLayer:LightLayer;
		private var _map:Map;
		
		private var _flashlight:SpotLight = new SpotLight(0, 0, 300, 0, 60, 40, 0xffffff, 1);
		private var _stageMouseX:Number = 0;
		private var _stageMouseY:Number = 0;
		private var _lastMapX:Number = 0;//cache for mouse not moving
		private var _lastMapY:Number = 0;//cache for mouse not moving
		private var _radians:Number = 0;
		
		private var _weapon:Weapon = new Pistol();
		public function Player(lightlayer:LightLayer ) 
		{
			instance = this;
			_map = Map.getInstance();
			_lightLayer = lightlayer;
			isAlive = true;
			
			var q:Quad = new Quad(_width, _height, 0xFF00FF);
			q.x = -_halfWidth;
			q.y = -_halfHeight;
			addChild(q);
			
			var e:Quad = new Quad(4, 4, 0xFF0000);
			addChild(e);
			
			x = 200;
			y = 50;
			
			lightlayer.addLight(_flashlight);
			
			_weapon.setLightLayer(lightlayer);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public static function getInstance():Player
		{
			return instance;
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_UP, kUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if (touch == null) return;
			if (touch.phase == TouchPhase.BEGAN)
			{
				_mousePressed = true;
				var p:PointLight = new PointLight(_stageMouseX, _stageMouseY, 200, 0xDDDDDD, 1);
				_lightLayer.addLight(p);
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				_mousePressed = false;
			}
			else if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.MOVED)
			{
				var mp:Point = touch.getLocation(_map);
				_stageMouseX = mp.x;
				_stageMouseY = mp.y;
				_lastMapX = _map.x;
				_lastMapY = _map.y;
				//_stageMouseX = touch.globalX;
				//_stageMouseY = touch.globalY;
			}
		}
		
		private function kDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 87) _upPressed = true;
			else if (e.keyCode == 83) _downPressed = true;
			if (e.keyCode == 68) _rightPressed = true;
			else if (e.keyCode == 65) _leftPressed = true;
		}
		
		private function kUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == 87) _upPressed = false;
			else if (e.keyCode == 83) _downPressed = false;
			else if (e.keyCode == 68) _rightPressed = false;
			else if (e.keyCode == 65) _leftPressed = false;
		}
		
		public function move():void 
		{
			
			var topLeft:Tile;
			var topRight:Tile;
			var bottomLeft:Tile;
			var bottomRight:Tile;
				
			if (_leftPressed)
			{
				x -= speed;
				topLeft =_map.getTileAt(x - _halfWidth, y - _halfHeight);
				bottomLeft = _map.getTileAt(x - _halfWidth, y + _halfHeight);
				if (!topLeft.isFloorLevel() && x - _halfWidth < topLeft.x + topLeft.width)
				{
					x = topLeft.x + topLeft.width + _halfWidth;
				}
				else if (!bottomLeft.isFloorLevel() && x - _halfWidth < bottomLeft.x + bottomLeft.width)
				{
					x = bottomLeft.x + topLeft.width + _halfWidth;
				}
			}
			else if (_rightPressed)
			{
				x += speed;
				topRight = _map.getTileAt(x + _halfWidth, y - _halfHeight);
				bottomRight = _map.getTileAt(x + _halfWidth, y + _halfHeight);
				if (!topRight.isFloorLevel() && x + _halfWidth > topRight.x)
				{
					x = topRight.x - _halfWidth - .01;
				}
				else if (!bottomRight.isFloorLevel() && x + _halfWidth > bottomRight.x)
				{
					x = bottomRight.x - _halfWidth - .01;
				}
			}				
			
			
			if (_upPressed)
			{
				y -= speed;
				topLeft = _map.getTileAt(x - _halfWidth, y - _halfHeight);
				topRight = _map.getTileAt(x + _halfWidth, y - _halfHeight);
				//trace(topLeft.isFloorLevel(), topRight.isFloorLevel());
				if (!topLeft.isFloorLevel() && y - _halfHeight < topLeft.y + topLeft.height)
				{
					y = topLeft.y + topLeft.height + _halfHeight;
				}
				else if (!topRight.isFloorLevel() && y - _halfHeight < topRight.y + topRight.height)
				{
					y = topRight.y + topRight.height + _halfHeight;
				}
			}
			else if (_downPressed)
			{
				y += speed;
				bottomLeft = _map.getTileAt(x - _halfWidth, y + _halfHeight);
				bottomRight = _map.getTileAt(x + _halfWidth, y + _halfHeight);
				if (!bottomLeft.isFloorLevel() && y + _halfHeight > bottomLeft.y)
				{
					y = bottomLeft.y - _halfHeight - .01;
				}
				else if (!bottomRight.isFloorLevel() && y + _halfHeight > bottomRight.y)
				{
					y = bottomRight.y - _halfHeight - .01;
				}
			}
			//trace(this.transformationMatrix);
		}
		
		public function pointFlashlight():void 
		{
			_flashlight.x = x;
			_flashlight.y = y;
			_flashlight.directionRadians = _radians = Math.atan2(_stageMouseY - y - (_map.y - _lastMapY), _stageMouseX - x - (_map.x - _lastMapX));
		}
		
		public function getRadians():Number
		{
			return _radians;
		}
		
		public function update():void 
		{
			move();
			pointFlashlight();
			_weapon.update(_mousePressed, x, y, _radians);
		}
		
	}

}