package org.shift_style.net {
	import flash.net.LocalConnection;

	/**
	 * @author yamaji
	 */
	public class AppDomain {
		public var baseURL:String;
		
		public static function isLocalHost():Boolean{
			var baseURL:String = new LocalConnection().domain;
			var isLocal:Boolean = false;
			
			if(baseURL == "localhost") {
				isLocal = true;			} else{
				isLocal = false;				
			}
			
			return isLocal;
		}
		
		public function get DomainName():String{
			return new LocalConnection().domain;
		}
	}
}
