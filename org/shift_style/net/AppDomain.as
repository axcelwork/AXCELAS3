package org.shift_style.net {
	import flash.net.LocalConnection;

	/**
	 * 再生環境に関するクラスです.
	 * 
	 * <p>取得できるのは、ドメインの名前・ローカルで再生されているか、です。</p>
	 * 
	 * @author axcel-work
	 * @version 0.1.1
	 * @since 2011/01/16
	 * @usage
	 * 
	 */
	public class AppDomain {
		// ドメイン名が格納されます.
		public var baseURL:String;
		
		/**
		 * 現在ローカルで再生されているかのフラグを取得します.
		 * @return isLocal : Boolean
		 */
		public static function isLocalHost():Boolean{
			var baseURL:String = new LocalConnection().domain;
			var isLocal:Boolean = false;
			
			if(baseURL == "localhost") {
				isLocal = true;			} else{
				isLocal = false;				
			}
			
			return isLocal;
		}
		
		/**
		 * [getter]Domain の名前を取得します.
		 */
		public function get DomainName():String{
			return new LocalConnection().domain;
		}
	}
}
