package screens
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import com.greensock.TweenLite;
	
	public class Welcome extends Sprite
	{
		private var bg:Image;
		private var title:Image;
		private var hero:Image;
		
		private var playBtn:Button;
		private var aboutBtn:Button;
		
		public function Welcome()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			drawScreen();
		}
		
		private function drawScreen():void
		{
			bg = new Image(Assets.getTextures("BgWelcome"))
			addChild(bg);
			
			title = new Image(Assets.getTextures("WelcomeTitle"))
			title.x = 440;
			title.y = 20;
			addChild(title);
			
			hero = new Image(Assets.getTextures("WelcomeHero"))
			hero.x = -hero.width;
			hero.y = 100;
			addChild(hero);
			
			playBtn = new Button(Assets.getTextures("WelcomePlayBtn"));
			playBtn.x = 500;
			playBtn.y = 260;
			this.addChild(playBtn)
			
			aboutBtn = new Button(Assets.getTextures("WelcomeAboutBtn"))
			aboutBtn.x = 410;
			aboutBtn.y = 380;
			addChild(aboutBtn)
			
		}
		
		public function initialize():void
		{
			this.visible = true;
			
			hero.x = -hero.width;
			hero.y = 100;
		}
	}
}