package screens
{
	import com.greensock.TweenLite;
	
	import events.NavigationEvent;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class About extends Sprite
	{
		private var bg:Image;
		private var title:Image;
		
		private var aboutBackBtn:Button;
		
		public function About()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			drawScreen();
		}
		
		private function drawScreen():void
		{
			bg = new Image(Assets.getTextures("BgWelcome"))
			this.addChild(bg);
			
			title = new Image(Assets.getAtlas().getTexture("welcome_title"))
			title.x = 440;
			title.y = 20;
			addChild(title);
			
			aboutBackBtn = new Button(Assets.getAtlas().getTexture("about_backButton"))
			aboutBackBtn.x = 500;
			aboutBackBtn.y = 300;
			this.addChild(aboutBackBtn)
				
			this.addEventListener(Event.TRIGGERED, onAboutClick);
				
		}
		
		private function onAboutClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button
			if((buttonClicked as Button) == aboutBackBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "menu"}, true))
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			if(this.hasEventListener(Event.ENTER_FRAME))this.removeEventListener(Event.ENTER_FRAME, aboutAnimation)
		}
		
		public function initialize():void
		{
			this.visible = true;
			this.addEventListener(Event.ENTER_FRAME, aboutAnimation)
		}
		
		private function aboutAnimation(event:Event):void
		{
			var currentDate:Date = new Date();
			aboutBackBtn.y = 300 + (Math.cos(currentDate.getTime()*0.002)*6);
		}
	}
}