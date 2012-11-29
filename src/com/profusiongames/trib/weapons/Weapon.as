package com.profusiongames.trib.weapons 
{
	import starling.display.Sprite;
	import starling.extensions.lighting.core.LightLayer;
	import starling.extensions.lighting.lights.PointLight;
	import starling.extensions.lighting.lights.SpotLight;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Weapon extends Sprite 
	{
		protected var delay:int = 0;
		protected var delayMax:int = 0;
		protected var clip:int = 0;
		protected var clipMax:int = 0;
		protected var ammoLeft:int = 0;
		protected var reload:int = 0;
		protected var reloadMax:int = 0;
		protected var damage:int = 0;
		protected var wiggle:Number = 0;
		protected var muzzleFlashDuration:int = 0;
		protected var muzzleFlash:SpotLight;
		protected var muzzleFlash2:SpotLight;
		protected var muzzleFlash3:SpotLight;
		protected var muzzleFlash4:SpotLight;
		protected var lightLayer:LightLayer;
		public function Weapon() 
		{
			
		}
		
		public function setLightLayer(_lightLayer:LightLayer):void
		{
			lightLayer = _lightLayer;
		}
		
		public function prime():void
		{
			delay = delayMax;
			clip = clipMax;
			//reload = reloadMax;
		}
		
		public function update(shouldFire:Boolean, x:Number, y:Number, radians:Number):void
		{
			
		}
		
		public function getRandomWiggle():Number
		{
			return Math.random() * wiggle - wiggle / 2;
		}
	}

}