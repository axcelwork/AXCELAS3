package org.shift_style.text {
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.system.Capabilities;
	
	/**
	 * TextField を拡張したクラスです.
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/06/16
	 * @usage
	 * 
	 */
	public class ExTextField extends TextField {
		private var _tf:TextFormat = new TextFormat();
		private var _spancing:Number;
		
		/**
		 * 新しい ExTextField インスタンスを作成します。
		 */
		public function ExTextField() {
			var os:String = Capabilities.os.substring( 0, 3 );
			
			if ( os == "Mac" ) {
				this._spancing = 0;
			}
			else if ( os == "Win" ){
				this._spancing = 0.7;
			}
			
			this._tf.letterSpacing = this._spancing;
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
		 * このインスタンスの TextFormat に複数のパラメータを指定したい時にこのメソッドを使うとよりスマートです。
		 * @param	parameters : Object
		 */
		public function setTextFormats( parameters:Object ):void {
			for ( var value:* in parameters ) {
				this._tf[ value ] = parameters[ value ];
			}
			
			if ( this.text == "" ) {
				this.defaultTextFormat = this._tf;
			}
			else {
				this.setTextFormat( this._tf );
			}
		}
		
	}

}