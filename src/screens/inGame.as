package screens
{
	import objects.GameBackground;
	import objects.Hero;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class inGame extends Sprite
	{
		private var hero:Hero
		private var bg:GameBackground
		
		public function inGame()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			drawGame();
		}
		
		private function drawGame():void
		{
			bg = new GameBackground
			bg.speed = 10;
			this.addChild(bg)
			
			hero = new Hero()
			hero.x = stage.stageWidth / 2;
			hero.y = stage.stageHeight / 2;
			this.addChild(hero)
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true
		}
	}
}