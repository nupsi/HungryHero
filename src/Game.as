package
{
	import events.NavigationEvent;
	
	import screens.About;
	import screens.Welcome;
	import screens.inGame;
	
	import starling.display.Sprite;
	import starling.events.Event;

	
	public class Game extends Sprite
	{
		private var screenWelcome:Welcome;
		private var screenInGame:inGame;
		private var screenAbout:About
		
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			trace("Starling framework initialized")
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen)
			
			screenInGame = new inGame()
			screenInGame.disposeTemporarily()
			this.addChild(screenInGame);
			
			screenWelcome = new Welcome
			this.addChild(screenWelcome)
			screenWelcome.initialize()
				
			screenAbout = new About
			screenAbout.disposeTemporarily()
			this.addChild(screenAbout)
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch(event.params.id)
			{
				case "play":
					screenWelcome.disposeTemporarily();
					screenInGame.initialize();
					break;
				case "about":
					screenWelcome.disposeTemporarily();
					screenAbout.initialize();
					break;
				case "menu":
					screenAbout.disposeTemporarily();
					screenWelcome.initialize();
					break;
			}
			
		}
	}
}