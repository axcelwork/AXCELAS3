package org.shift_style.net {
	import flash.net.URLVariables;
	import flash.net.URLRequest;

	/**
	 * Twitterに簡単にGET送信できるクラスです.
	 * 
	 * <p>Auth認証ではなく status で送ります。GET送信です.</p>
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/12/06
	 * @usage
	 * 
	 */
	public class TwitterPost {
		private var _request:URLRequest;
		private var _vers:URLVariables;
		private var _host:String;
		
		public function TwitterPost(){
			this._vers = new URLVariables();
		}
		
		
		/**
		 * Twitter にGET送信する URLRequest を作成します.
		 * 
		 * @param _status:String
	 	 * 
	 	 */
		public function queryRequest(_status:String):URLRequest{
			this._host = "http://twitter.com/";
			this._vers.status = _status;
			
			this._request = new URLRequest(this._host);
			this._request.data = this._vers;
			
			return this._request;
		}
		
		
	}
}
