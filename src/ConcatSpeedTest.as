package
{
	import flash.display.*;
	import flash.utils.*;
	import flash.text.*;
 
	public class ConcatSpeedTest extends Sprite
	{
		private var __logger:TextField = new TextField();
		private function row(...cols): void
		{
			__logger.appendText(cols.join(",")+"\n");
		}
 
		public function ConcatSpeedTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
 
			__logger.autoSize = TextFieldAutoSize.LEFT;
			addChild(__logger);
 
			init();
		}
 
		private function init(): void
		{
			var beforeTime:int;
			var afterTime:int;
			var i:int;
			var j:int;
			var REPS:int = 10;
			var LENGTH:int = 100000;
			var absInt:int;
			var absNumber:Number;
			
			var v:Vector.<Number> = new Vector.<Number>();
			var v2:Vector.<Number> = new Vector.<Number>();
			
			var vfirst:Vector.<Number> = new Vector.<Number>();
			var vmiddle:Vector.<Number> = new Vector.<Number>();
			var vend:Vector.<Number> = new Vector.<Number>();
			
			var v4:Vector.<Number> = new Vector.<Number>();
			var v5:Vector.<Number> = new Vector.<Number>();
			for (i = 0; i < LENGTH; ++i)
			{
				v[i] = i;
				v2[i] = i;
				v4[i] = i;
				v5[i] = i;
			}
 
			row("Method", "Time");
			
			
			beforeTime = getTimer();
			for (i = 0; i < REPS; ++i)
			{
				/*vend = v2.slice(LENGTH - 1000);//anything at the end
				trace("V3", v3.length);
				v2 = v2.slice(0, 1000);
				trace("V2", v2.length);
				trace("Adding", v.slice(1000, LENGTH - 1000).length);
				v2 = v2.concat(v.slice(1000, LENGTH - 1000));
				trace("V2", v2.length);
				v2 = v2.concat(v3);
				trace("V2", v2.length);*/
				//v2.splice(1000, LENGTH - 2000, v.slice(1000, LENGTH - 1000));
			}
			afterTime = getTimer();
			row("slice", (afterTime-beforeTime));
			
			
 
			beforeTime = getTimer();
			for (i = 0; i < REPS; ++i)
			{
				for (j = 1000; j < LENGTH-1000; ++j)
				{
					v5[j] = v4[j];
				}
				
			}
			afterTime = getTimer();
			row("manual", (afterTime-beforeTime));
			
			//verify
			trace(v2.length, v5.length);
			for (i = 0; i < LENGTH; i++)
			{
				//if (v2[i] != v5[i])
					//trace("not the same");
			}
 
			
		}
	}
}