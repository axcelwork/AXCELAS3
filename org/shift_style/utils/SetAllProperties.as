package org.shift_style.utils {
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author axcel-work
	 */
	public class SetAllProperties {
		private static var _tf:TextFormat = new TextFormat();
		
		/**
		 * 複数のパラメータを指定したい時にこのメソッドを使うとよりスマートです。
		 * @param	parameters : Object
		 */
		public static function setsProperties( ary:Array, parameters:Object ):void {
			for (var i:int = 0; i < ary.length; i++) {
				for ( var value:* in parameters ) {
					ary[ i ][ value ] = parameters[ value ];
				}
			}			
		}
		
		/**
		 * 複数の TextFormat を指定したい時にこのメソッドを使うとよりスマートです。
		 * @param	parameters : Object
		 */
		public static function setsTextFormats( ary:Array, parameters:Object ):void {
			for (var i:int = 0; i < ary.length; i++) {
				for ( var value:* in parameters ) {
					_tf[ value ] = parameters[ value ];
				}
				
				if ( ary[ i ] == "" ) {
					TextField(ary[ i ]).defaultTextFormat = _tf;
				}
				else {
					TextField(ary[ i ]).setTextFormat( _tf );
				}
			}
		}
		
	}
	
}