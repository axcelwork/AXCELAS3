package org.shift_style.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * 背景に画像を敷いてタイリングしたいとき、簡単に実装できるクラスです.
	 * 
	 * <p>インスタンス作成時にStageを渡し、各プロパティに値を設定します。
	 * AddChild するとタイリング処理がかかります。</p>
	 * 
	 * <p>プロパティに値を設定するときに、まとめて設定したいときは setProperties() メソッドを用いると楽です。</p>
	 * 
	 * <p><strong>Exsample</strong></p>
	 * <listing>this._backGround = new RepeatBackGround( this.stage );
	 * this._backGround.tile = this.bmpImage;
	 * this._backGround.repeat = "repeat-x";
	 * 又は
	 * this._backGround.setProperties( { tile: this.bmpImage, repeat: "repeat-x" } );</listing>
	 * 
	 * <p><strong>Exsample</strong></p>
	 * <listing>setProperties( { tile: Bitmap(), repeat: String } );</listing>
	 * 
	 * <p>背景にタイリングさせるオブジェクトはBitmap, BitmapData, Spriteが指定できます。<br>
	 * 3つのプロパティすべてにインスtなすを設定した場合、Bitmap > BitmapData > Spriteの順で優先されるので注意が必要です。</p>
	 * 
	 * <p>repertプロパティに値を渡すときに定数を用いることも可能です。</p>
	 * 
	 * @author axcel-work
	 * @version 1.0
	 * @since 2010/06/11
	 * @usage
	 */
	public class RepeatBackGround extends Sprite {
		/**
		 * RepeatBackGround インスタンスを設置したい Stage を設定します。
		 */
		public var contenner:Stage;
		
		/**
		 * リピートさせたいインスタンスが Bitmap の場合このプロパティに設定します
		 */
		public var _bitmap:Bitmap;
		
		/**
		 * リピートさせたいインスタンスが BitmapData の場合このプロパティに設定します
		 */
		public var _bitmapData:BitmapData;
		
		/**
		 * リピートさせたいインスタンスが Sprite の場合このプロパティに設定します
		 */
		public var _sprite:Sprite;
		
		/**
		 * 水平方向に繰り返します。
		 */
		public static const REPEAT_X:String = "repeat-x";
		
		/**
		 * 垂直方向に繰り返します。
		 */
		public static const REPEAT_Y:String = "repeat-y";
		
		/**
		 * 両方向に繰り返します。
		 */
		public static const REPEAT:String = "repeat";
		
		/**
		 * 繰り返したい方向を指定します。
		 */
		public var repeat:String;
		
		private var tile:BitmapData;
		
		/**
		 * 新しい RepeatBackGround インスタンスを作成します。
		 */
		public function RepeatBackGround( contenner:Stage ) {
			this.contenner = contenner;
			this.addEventListener( Event.ADDED, addHandler );
		}
		
		private function addHandler(e:Event):void {
			if ( this._bitmap != null ) {
				this.tile = new BitmapData( this._bitmap.width, this._bitmap.height );
				this.tile.draw( this._bitmap );
			}
			else if ( this._bitmapData != null ) {
				this.tile = this._bitmapData; 
			}
			else if ( this._sprite != null ) {
				this.tile = new BitmapData( this._sprite.width, this._sprite.height );
				this.tile.draw( this._sprite );
			}
			
			this.update();
		}
		
		/**
		 * このインスタンスに複数のパラメータを指定したい時にこのメソッドを使うとよりスマートです。
		 * @param	parameters : Object
		 */
		public function setProperties( parameters:Object ):void {
			for ( var value:* in parameters ) {
				this[ value ] = parameters[ value ];
			}
		}
		
		
		/**
		 * RESIZEイベント時にこのメソッドを呼び出すことによって自動的に更新されます。
		 */
		public function update():void {
			this.graphics.clear();
			this.graphics.beginBitmapFill( this.tile );
			
			if ( this.repeat == "repeat-x" ) {
				this.graphics.drawRect( 0, 0, this.contenner.stageWidth, this.tile.height );
			}
			else if ( this.repeat == "repeat-y" ) {
				this.graphics.drawRect( 0, 0, this.tile.width, this.contenner.stageHeight );
			}
			else {
				this.graphics.drawRect( 0, 0, this.contenner.stageWidth, this.contenner.stageHeight );
			}
			
			this.graphics.endFill();
		}
		
	}

}