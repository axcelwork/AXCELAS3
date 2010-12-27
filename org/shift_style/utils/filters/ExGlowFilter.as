package org.shift_style.utils.filters {
	import flash.filters.GlowFilter;
	import flash.display.DisplayObject;
	
	/**
	 * GlowFilter を手軽に実装できる Singleton クラスです.
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/07/01
	 * @usage
	 * 
	 */
	public class ExGlowFilter{
		public static var _instance:GlowFilter;
		private var _filter:GlowFilter = new GlowFilter();
		
		/**
		 * 新しい ExGlowFilter インスタンスを作成します
		 */
		public static function get instance():GlowFilter {
			if ( _instance === null ) {
				_instance = new GlowFilter;
			}
			
			return _instance;
		}
		
		/**
		 * 引数として渡されたインスタンスに対して DropShadowFilter を適用します
		 * @param	target  GlowFilter を適用するインスタンス
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