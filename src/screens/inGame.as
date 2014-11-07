package screens
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import objects.GameBackground;
	import objects.Hero;
	import objects.Item;
	import objects.Obstacle;
	import objects.Particle;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.deg2rad;
	
	public class inGame extends Sprite
	{
		private var startButton:Button;
		private var hero:Hero;
		private var bg:GameBackground;
		
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		private var gameState:String;
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		private const MIN_SPEED:Number = 650;
		
		private var scoreDistance:int;
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		private var obstaclesToAnimate:Vector.<Obstacle>;
		private var itemsToAnimate:Vector.<Item>;
		private var eatParticlesToAnimate:Vector.<Particle>;
		
		private var scoreText:starling.text.TextField
		
		public function inGame()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			drawGame();
			
			scoreText = new TextField(300, 100, "SCORE: 0", Assets.getFont().name, 24, 0xffffff)
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = 20;
			scoreText.y = 20;
			this.addChild(scoreText)
		}
		
		private function drawGame():void
		{
			bg = new GameBackground
			this.addChild(bg)
			
			hero = new Hero()
			hero.x = stage.stageWidth / 2;
			hero.y = stage.stageHeight / 2;
			this.addChild(hero)
			
			startButton = new Button(Assets.getAtlas().getTexture("startButton"));
			startButton.x = stage.stageWidth * 0.5; - startButton.width * 0.5;
			startButton.y = stage.stageHeight * 0.5 - startButton.height * 0.5;
			this.addChild(startButton)
				
			gameArea = new Rectangle(0, 100, stage.stageWidth, stage.stageHeight - 250);
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true
				
			this.addEventListener(Event.ENTER_FRAME, checkElapsed)
			
			hero.x = -stage.stageWidth;
			hero.y = stage.stageHeight * 0.5;
			
			gameState = "idle";
			
			playerSpeed = 0;
			hitObstacle = 0;
			
			bg.speed = 0;
			scoreDistance = 0;
			obstacleGapCount = 0;
			
			obstaclesToAnimate = new Vector.<Obstacle>();
			itemsToAnimate = new Vector.<Item>();
			eatParticlesToAnimate = new Vector.<Particle>();
			
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClick)
		}
		
		private function onStartButtonClick(event:Event):void
		{
			startButton.visible = false;
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonClick)
			launchHero()
		}
		
		private function launchHero():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onGameTick)
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(stage);
			
			touchX = touch.globalX;
			touchY = touch.globalY;
		}
		
		private function onGameTick(event:Event):void
		{
			switch(gameState)
			{
				case "idle":
					
					if(hero.x < stage.stageWidth * 0.5 * 0.5)
					{
						hero.x += ((stage.stageWidth * 0.5 * 0.5 + 10) - hero.x) * 0.05;
						hero.y = stage.stageHeight * 0.5;
							
						playerSpeed += (MIN_SPEED - playerSpeed) * 0.05;
						bg.speed = playerSpeed * elapsed;
					}
					else
					{
						gameState = "flying";
					}
					break
				case "flying":
					
					if (hitObstacle <= 0)
					{
						hero.y -= (hero.y - touchY) * 0.1;
						
						if( -( hero.y - touchY) < 150 && -(hero.y - touchY) > -150)
						{
							hero.rotation = deg2rad(-(hero.y - touchY) * 0.2);
						}
						if (hero.y > gameArea.bottom - hero.height * 0.5)
						{
							hero.y = gameArea.bottom - hero.height * 0.5;
							hero.rotation = deg2rad(0);
						}
						if(hero.y < gameArea.top + hero.height * 0.5)
						{
							hero.y = gameArea.top + hero.height * 0.5;
							hero.rotation = deg2rad(0);
						}
					}
					else
					{
						hitObstacle--;
						cameraShake();
					}
					
					playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
					bg.speed = playerSpeed * elapsed;
					
					scoreDistance -= (playerSpeed - MIN_SPEED) * 0.1;
					
					scoreText.text = "SCORE: " + scoreDistance;
					
					initObstacle();
					animateObstacles();
					
					createFoodItems()
					animateItems()
					animateEatPartile()
					
					trace("scoreDistance");
					break
				case "over":
					break
			}
		}
		
		private function animateEatPartile():void
		{
			for(var i:uint = 0; i < eatParticlesToAnimate.length; i++)
			{
				var eatParticleToTrack:Particle = eatParticlesToAnimate[i];
				
				if(eatParticleToTrack)
				{
					eatParticleToTrack.scaleX -= 0.03;
					eatParticleToTrack.scaleY = eatParticleToTrack.scaleX;
					
					eatParticleToTrack.y -= eatParticleToTrack.speedY;
					eatParticleToTrack.speedY -= eatParticleToTrack.speedY * 0.2;
					
					eatParticleToTrack.x += eatParticleToTrack.speedX;
					eatParticleToTrack.speedX--;
					
					eatParticleToTrack.rotation += deg2rad(eatParticleToTrack.spin)
					eatParticleToTrack.spin  *= 1.1;
					
					if(eatParticleToTrack.scaleY <= 0.02)
					{
						eatParticlesToAnimate.splice(i, 1);
						this.removeChild(eatParticleToTrack)
						eatParticleToTrack = null;
					}
				}
			}
		}
		
		private function animateItems():void
		{
			var itemToTrack:Item;
			
			for(var i:uint; i < itemsToAnimate.length; i++)
			{
				itemToTrack = itemsToAnimate[i];
				
				itemToTrack.x -= playerSpeed * elapsed;
				
				if (itemToTrack.bounds.intersects(hero.bounds))
				{
					createEatParticles(itemToTrack);
					
					itemsToAnimate.splice(i, 1);
					this.removeChild(itemToTrack);
				}
				
				if(itemToTrack.x < -50)
				{
					itemsToAnimate.splice(i, 1);
					this.removeChild(itemToTrack);
				}
			}
		}
		private function createEatParticles(itemToTrack:Item):void
		{
			var count:int = 5;
			
			while(count > 0)
			{
				count--;
				
				var eatParticle:Particle = new Particle();
				this.addChild(eatParticle);
				
				eatParticle.x = itemToTrack.x + Math.random() * 40 - 20;
				eatParticle.y = itemToTrack.y - Math.random() * 40;
				
				eatParticle.speedX = Math.random() * 2 + 1;
				eatParticle.speedY = Math.random() * 5;
				eatParticle.spin = Math.random() * 15;
				
				eatParticle.scaleX = eatParticle.scaleY = Math.random() * 0.3 + 0.3;
				
				eatParticlesToAnimate.push(eatParticle);
			}
		}
		
		private function createFoodItems():void
		{
			if(Math.random() > 0.95)
			{
				var itemToTrack:Item = new Item(Math.ceil(Math.random() * 5));
				itemToTrack.x = stage.stageWidth + 50;
				itemToTrack.y = int( Math.random() * (gameArea.bottom - gameArea.top)) + gameArea.top;
				this.addChild(itemToTrack);
				itemsToAnimate.push(itemToTrack);
			}
		}
		
		private function cameraShake():void
		{
			if (hitObstacle > 0)
			{
				this.x = Math.random() * hitObstacle;
				this.y = Math.random() * hitObstacle;
			}
			else if( x != 0 )
			{
				this.x = 0;
				this.y = 0;
			}
		}
		
		private function animateObstacles():void
		{
			var obstacleToTrack:Obstacle;
			
			for(var i:uint = 0;i<obstaclesToAnimate.length;i++)
			{
				obstacleToTrack = obstaclesToAnimate[i];
				
				if(obstacleToTrack.alreadyHit == false && obstacleToTrack.bounds.intersects(hero.bounds))
				{
					obstacleToTrack.alreadyHit = true;
					obstacleToTrack.rotation = deg2rad(70);
					hitObstacle = 30;
					playerSpeed *= 0.5;
				}
				
				if(obstacleToTrack.distance > 0)
				{
					obstacleToTrack.distance -= playerSpeed * elapsed;
				}
				else
				{
					if(obstacleToTrack.watchOut)
					{
						obstacleToTrack.watchOut = false;
					}
					obstacleToTrack.x -= (playerSpeed + obstacleToTrack.speed) * elapsed;
				}
				
				if(obstacleToTrack.x < -obstacleToTrack.width || gameState == "over")
				{
					obstaclesToAnimate.splice(i, 1);
					this.removeChild(obstacleToTrack);
				}
			}
		}
		
		private function initObstacle():void
		{
			if(obstacleGapCount < 1200)
			{
				obstacleGapCount += playerSpeed * elapsed;
			}
			else if(obstacleGapCount != 0)
			{
				obstacleGapCount = 0;
				createObstacle(Math.ceil(Math.random() * 4), Math.random() * 1000 + 1000);
				
			}
		}
		
		private function createObstacle(type:Number, distance:Number):void
		{
			var obstacle:Obstacle = new Obstacle(type, distance, true, 300);
			obstacle.x = stage.stageWidth;
			this.addChild(obstacle)
				
			if(type <= 3)
			{
				if(Math.random() > 0.5)
				{
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}
				else
				{
					obstacle.y = gameArea.bottom -obstacle.height;
					obstacle.position = "bottom";
				}
			}
			else
			{
				obstacle.y = int(Math.random() * (gameArea.bottom - obstacle.height - gameArea.top)) + gameArea.top;
				obstacle.position = "middle";
			}
			obstaclesToAnimate.push(obstacle);
		}
		
		private function checkElapsed(event:Event):void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed =(timeCurrent - timePrevious)* 0.001;
		}
	}
}