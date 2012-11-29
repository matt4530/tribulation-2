package com.profusiongames.trib.weapons 
{
	//http://www.fastswf.com/swfs/4lpl2HQ/DQFsH0I5DD9O1A
	import com.profusiongames.trib.beings.Player;
	import com.profusiongames.trib.bullets.Bullet;
	import com.profusiongames.trib.bullets.StandardBullet;
	import com.profusiongames.trib.tile.Map;
	import starling.extensions.lighting.core.LightLayer;
	import starling.extensions.lighting.lights.PointLight;
	import starling.extensions.lighting.lights.SpotLight;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Pistol extends Weapon 
	{
		
		public function Pistol() 
		{
			delayMax = 3;
			clipMax = 10;
			ammoLeft = 9999999999999;
			reloadMax = 1;
			damage = 10;
			wiggle = 0.1;
			muzzleFlashDuration = 2;
			muzzleFlash = new SpotLight(0, 0, 80, 0, 10, 90, 0xDC8909, 4);
			muzzleFlash2 = new SpotLight(0, 0, 120, 0, 50, 90, 0xDC8909, 4);
			muzzleFlash3 = new SpotLight(0, 0, 30, 0, 90, 50, 0xDC8909, 1);
			muzzleFlash4 = new SpotLight(0, 0, 30, 0, 90, 50, 0xDC8909, 1);
			prime();
		}
		
		
		
		override public function update(shouldFire:Boolean, x:Number, y:Number, radians:Number):void
		{
			delay++;
			if (delay == muzzleFlashDuration)//first frame
			{
				//trace("should remove");
				lightLayer.removeLight(muzzleFlash);
				lightLayer.removeLight(muzzleFlash2);
				lightLayer.removeLight(muzzleFlash3);
				lightLayer.removeLight(muzzleFlash4);
			}
			
			if (clip == 0) //empty clip
			{
				reload++;
				if (reload == reloadMax)//reload time over
				{
					if (ammoLeft > 0)//more clips
					{
						reload = 0; //reset reload counter
						clip = Math.min(clipMax, ammoLeft);//clip is now full
						ammoLeft -= clip;//subtract by how much ammo was reloaded
					}
				}
				else if (reload > reloadMax) //do nothing, ammo has run out
				{
					// Ammo has run out.
				}
			}
			else if (shouldFire)//clip has ammo, mouse is pressed
			{
				if (delay > delayMax)//allowed to fire
				{
					delay = 0; //reset delay counter
					clip--; //one less bullet in clip
					fire(x,y,radians); //fire bullet
				}
			}
		}
		
		override public function setLightLayer(_lightLayer:LightLayer):void
		{
			super.setLightLayer(_lightLayer);
			//_lightLayer.addLight(muzzleFlash);
			//_lightLayer.addLight(muzzleFlash2);
			//_lightLayer.addLight(muzzleFlash3);
			//_lightLayer.addLight(muzzleFlash4);
		}
		
		private function fire( x:Number, y:Number, radians:Number):void 
		{
			var bullet:StandardBullet = new StandardBullet(Map.getInstance());
			bullet.shootFromPlayer(Player.getInstance(), this);
			muzzleFlash.x = muzzleFlash2.x = muzzleFlash3.x = muzzleFlash4.x = x;
			muzzleFlash.y = muzzleFlash2.y = muzzleFlash3.y = muzzleFlash4.y = y;
			muzzleFlash.directionRadians = muzzleFlash2.directionRadians = radians;
			//trace(radians, Math.PI / 2);
			muzzleFlash3.directionRadians = radians + Math.PI / 3 + Math.random()*.2;
			muzzleFlash4.directionRadians = radians - Math.PI / 3 - Math.random()*.2;
			lightLayer.addLight(muzzleFlash);
			lightLayer.addLight(muzzleFlash2);
			lightLayer.addLight(muzzleFlash3);
			lightLayer.addLight(muzzleFlash4);
		}
	}

}