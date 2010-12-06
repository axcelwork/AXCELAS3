package org.shift_style.net {
	import flash.net.URLVariables;
	import flash.net.URLRequest;

	/**
	 * SNSやブックマーク共有サービスに投稿できるクラスです.
	 * 
	 * <p>対応しているのは、 Tiwitter、Facebook、はてブ、livedoorクリップ、
	 * Yahoo!ブックマーク、Googleブックマーク、mixiチェックです</p>
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/12/03
	 * @usage
	 * 
	 */
	public class SNSPost {
		public var _link:String;
		public var _title:String;
		
		public var _mixiDevelopCode:String;
		
		private var _request:URLRequest;
		private var _vers:URLVariables;
		private var _host:String;
		
		public function SNSPost(){
			this._vers = new URLVariables();
		}
		
		
		/**
		 * 各SNSやブックマーク共有サービスに対する URLRequest を作成します.
		 * 
		 * <p>パラメータには、tiwitter,facebook,hatena,livedoor,yahoo,google,mixi</p>
		 * 
		 * @param SNSName:String
	 	 * 
	 	 */
		public function queryRequest(SNSName:String):URLRequest{
			switch(SNSName) {
				case "twitter":
					this._host = "http://twitter.com/";
					this._vers.status = this._title + " - " + this._link;
				break;
				case "facebook":
					this._host = "http://www.facebook.com/sharer.php";
					this._vers.u = this._link;
					this._vers.t = this._title;
				break;
				case "yahoo":
					this._host = "http://bookmarks.yahoo.co.jp/bookmarklet/showpopup";
					this._vers.t = this._link;
				break;
				case "livedoor":
					this._host = "http://clip.livedoor.com/redirect";
					this._vers.link = this._link;
					this._vers.title = this._title;
				break;
				case "hatena":
					this._host = "http://b.hatena.ne.jp/entry";
					this._vers.mode = "confirm";
					this._vers.url = this._link;
					this._vers.title = this._title;
				break;
				case "google":
					this._host = "https://www.google.com/bookmarks/mark";
					this._vers.op = "add";
					this._vers.bkmk = this._link;
					this._vers.title = this._title;
				break;
				case "mixi":
					this._host = "http://mixi.jp/share.pl";
					this._vers.u = this._link;
					this._vers.k = this._mixiDevelopCode;
				break;
			}
			
			this._request = new URLRequest(this._host);
			this._request.data = this._vers;
			
			return this._request;
		}
		
		
	}
}
