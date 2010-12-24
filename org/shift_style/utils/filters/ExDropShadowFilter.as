package org.shift_style.utils.filters {
	import flash.filters.DropShadowFilter;
	import flash.display.DisplayObject;
	
	/**
	 * DropShadowFilter を手軽に実装できる Singleton クラスです.
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/07/01
	 * @usage
	 * 
	 */
	public class ExDropShadowFilter{
		public static var _instance:ExDropShadowFilter;
		private var _filter:DropShadowFilter = new DropShadowFilter();
		
		/**
		 * 新しい DropShadow インスタンスを作成します
		 */
		public static function get instance():ExDropShadowFilter {
			if ( _instance === null ) {
				_instance = new ExDropShadowFilter;
			}
			
			return _instance;
		}
		
		/**
		 * 引数として渡されたインスタンスに対して DropShadowFilter を適用します
		 * @param	target  DropShadowFilter を適用するインスタンス
		 */
		public function setFilter( target:DisplayObject ):void {
			target.filters = [ _filter ];
		}
		
		/**
		 * このインスタンスに複数のパラメータを指定したい時にこのメソッドを使うとよりスマートです。
		 * @param	parameters
		 */
		public function setProperties( parameters:Object ):void {
			for ( var value:* in parameters ) {
				this._filter[ value ] = parameters[ value ];
			}
		}
	}
	
}