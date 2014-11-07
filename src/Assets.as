package
{
	import flash.display.Bitmap;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.Direction;
	
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import starling.text.TextField;
	
	public class Assets
	{
		[Embed(source="../media/graphics/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		[Embed(source="../media/graphics/bgLayer1.jpg")]
		public static const BgLayer1:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source="../media/graphics/mySpritesheet.png")]
		public static const AtlasTextureGame:Class
		
		[Embed(source="../media/graphics/mySpritesheet.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class
		
		[Embed(source="../media/fonts/bitmap/fontScoreLabel.png")]
		public static const FontTexture:Class
		
		[Embed(source="../media/fonts/bitmap/fontScoreLabel.fnt", mimeType="application/octet-stream")]
		public static const FontXML:Class
		
		public static var myFont:BitmapFont;
		
		//[Embed(source="../media/fonts/bitmap/fontRegular.fnt", fontFamily = "MyFontName", embedAsCFF="false" )]
		//public static var MyFont:Class;
		
		public static function getFont():BitmapFont
		{
			var fontTexture:Texture = Texture.fromBitmap(new FontTexture())
			var fontXML:XML = XML(new FontXML())
				
			var font:BitmapFont = new BitmapFont(fontTexture, fontXML);
			TextField.registerBitmapFont(font);
			return font;
		}
		
		public static function getAtlas():TextureAtlas
		{
			if(gameTextureAtlas == null)
			{
				var texture:Texture = getTextures("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml)
			}
			return gameTextureAtlas
		}
		
		public static function getTextures(name:String):Texture
		{
			if(gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}

}