package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BgLayer extends Sprite
	{
		private var image1:Image;
		private var image2:Image;
		
		private var _layer:int;
		private var _parallax:Number;
		
		public function BgLayer(layer:int)
		{
			super();
			this._layer = layer;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			if(_layer == 1)
			{
				image1 = new Image(Assets.getTextures("BgLayer" + _layer));
				image2 = new Image(Assets.getTextures("BgLayer" + _layer));
			}else{
				image1 = new Image(Assets.getAtlas().getTextures("BgLayer" + _layer));
			}
		}
		
		public function get parallax():Number
		{
			return _parallax;
		}

		public function set parallax(value:Number):void
		{
			_parallax = value;
		}

	}
}