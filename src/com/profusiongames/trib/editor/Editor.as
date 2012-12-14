package com.profusiongames.trib.editor 
{
	import feathers.controls.Button;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author UG
	 */
	public class Editor extends Sprite 
	{
		private var btn:Button = new Button();
		public function Editor() 
		{
			btn.label = "Sup";
			addChild(btn);
		}
		
	}

}