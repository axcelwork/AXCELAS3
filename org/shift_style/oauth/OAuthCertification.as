package org.shift_style.oauth {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.text.TextFieldType;
	
	import org.iotashan.oauth.OAuthToken;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	
	import org.httpclient.HttpRequest;
	import org.httpclient.events.HttpResponseEvent;
	import org.httpclient.http.Post;
	import org.httpclient.HttpClient;
	import com.adobe.net.URI;
	
	import org.shift_style.text.ExTextField;
	import org.shift_style.ui.button.ExCastButton;
	import org.shift_style.commands.display.*;
	import org.shift_style.commands.tweens.ExDoTweener;
	
	import jp.progression.commands.Prop;
	import jp.progression.commands.lists.SerialList;
	import jp.progression.commands.display.AddChild;
	import jp.progression.commands.display.RemoveChild;
	import jp.progression.commands.tweens.DoTweener;
	
	
	/**
	 * ...つくりかけ
	 * @author axcel-work
	 * 
	 * PIN形式以外、（Webアプリケーション）になるとクロスドメインでひっかかる
	 * └PHPが必要 @ikekou
	 * 
	 */
	public class OAuthCertification extends Sprite {
		public static const ON_COMPLETE:String = "complete";
		
		private var _stage:Stage;
		
		private var CONSUMER_KEY:String = "bog1nEiWjfaFxzMDAHMVzw";
		private var CONSUMER_SERCRET:String = "2y3nz1QGfKC4Yvoz4IlNBqx7wTG2D3EnuX5td7Kpog";
		
		private var REQUEST_TOKEN_URL:String = "https://twitter.com/oauth/request_token";
		private var AUTHORIZE_URL:String = "https://twitter.com/oauth/authorize?oauth_token=";
		private var ACCESS_TOKEN_URL:String = "https://twitter.com/oauth/access_token";
		
		//private var REQUEST_TOKEN_URL:String = "https://api.twitter.com/oauth/request_token";
		//private var AUTHORIZE_URL:String = "https://api.twitter.com/oauth/authorize?oauth_token=";
		//private var ACCESS_TOKEN_URL:String = "https://api.twitter.com/oauth/access_token";
		
		private var POST_API_URL:String = "http://api.twitter.com/1/statuses/update.xml";
		
		private var consumer:OAuthConsumer;
		private var request:OAuthRequest;
		private var accessToken:OAuthToken;
		private var OAuthURL:String;
		private var OAuthLoader:URLLoader;
		private var OAuthVariables:URLVariables;
		
		private var _wrapContents:Sprite;
		private var _inputPINCode:ExTextField;
		private var _btnCertification:ExCastButton;
		private var _backGround:Shape;
		
		private var _userID:String = "";
		private var _screenName:String = "";
		private var _validToken:String = "";
		private var _validTokenSecret:String = "";
		
		
		public function OAuthCertification( _stage:Stage ) {
			this._stage = _stage;
			
			//this._userID = "12927332";
			//this._screenName = "axcelwork";
			//this._validToken = "12927332-s5DyqX6yI29mTVFRiziasm7esEpZgMFO98vbK1sql";
			//this._validTokenSecret = "ckaeEWxQE0UODiG7mylnlEOCeqI6a6PbFMK5vLkY";
			
			this.atInit();
			if ( this._userID == "" ) {
				this.atRedy();
			}
			else {
				dispatchEvent( new Event( ON_COMPLETE ) );
			}
		}
		
		
		private function atInit():void {
			this.consumer = new OAuthConsumer( this.CONSUMER_KEY, this.CONSUMER_SERCRET );
			this.request = new OAuthRequest( "GET", this.REQUEST_TOKEN_URL, null, this.consumer );
			this.OAuthURL =  this.request.buildRequest( new OAuthSignatureMethod_HMAC_SHA1() );
		}
		
		private function atRedy():void {
			this.OAuthLoader = new URLLoader( new URLRequest( this.OAuthURL ) );
			this.OAuthLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			this.OAuthLoader.addEventListener( Event.COMPLETE, oAuthDataCompleteHandler );
		}
		
		private function oAuthDataCompleteHandler(e:Event):void {
			this.OAuthVariables = new URLVariables( e.target.data );
			
			//navigateToURL( new URLRequest( this.AUTHORIZE_URL + this.OAuthVariables.oauth_token ) );
			
			// 認証用のパーツ
			this._inputPINCode = new ExTextField();
			this._inputPINCode.type = TextFieldType.INPUT;
			this._inputPINCode.setProperties( { border: true, borderColor: 0x000000, height: 20 } );
			
			this._btnCertification = new ExCastButton();
			this._btnCertification.addEventListener( MouseEvent.CLICK, clickHandler );
			
			this._backGround = new Shape();
			this._backGround.graphics.beginFill( 0x000000, 0.6 );
			this._backGround.graphics.drawRect( 0, 0, this._stage.stageWidth, 100 );
			this._backGround.graphics.endFill();
			
			// Command Executor
			var sList:SerialList = new SerialList( null,
				new AddChildren( this._stage, [ this._backGround, this._inputPINCode, this._btnCertification ] ),
				new ExProp( [ this._backGround, this._inputPINCode, this._btnCertification ], { y: -100 } ),
				[
					new ExDoTweener( [ this._backGround, this._inputPINCode, this._btnCertification ], { y: 0, transition: "easeOutSine", time: 0.45 } )
				]
			);
			
			sList.execute();
		}
		
		private function clickHandler(e:MouseEvent):void {
			this.accessToken = new OAuthToken( this.OAuthVariables.oauth_token, this.OAuthVariables.oauth_token_secret );
			this.request = new OAuthRequest( "GET", this.ACCESS_TOKEN_URL, { oauth_verifier: this._inputPINCode.text, oauth_version: "1.0" }, this.consumer, this.accessToken );
			OAuthURL =  this.request.buildRequest( new OAuthSignatureMethod_HMAC_SHA1() );
			
			this.OAuthLoader = new URLLoader( new URLRequest( OAuthURL ) );
			this.OAuthLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			this.OAuthLoader.addEventListener( Event.COMPLETE, AccessTokenCompleteHandler );
		}
		
		private function AccessTokenCompleteHandler(e:Event):void {
			var vars:URLVariables = new URLVariables( e.target.data );
			
			this._validToken = vars.oauth_token;
			this._validTokenSecret = vars.oauth_token_secret;
			
			// 認証が完了したことを知らせます
			dispatchEvent( new Event( ON_COMPLETE ) );
			
			// Command Executor
			var sList:SerialList = new SerialList( null,
				new DoTweener( this._wrapContents, { y: -this._wrapContents.height, transition: "easeOutSine", time: 0.65 } ),
				new RemoveChildren( this._wrapContents, [ this._backGround, this._inputPINCode, this._btnCertification ] ),
				new RemoveChild( this._stage, this._wrapContents )
			);
			
			sList.execute();
		}
		
		
		
		/**
		 * Twitter に文字列を POST します。
		 * @param	msg - POST する文字列です。
		 */
		public function post( msg:String ):void {
			var req:OAuthToken = new OAuthToken( this._validToken, this._validTokenSecret );
			
			var oauthReq:OAuthRequest = new OAuthRequest( "POST", this.POST_API_URL, { oauth_version: "1.0", status: msg }, this.consumer, req );
			var auth:String = oauthReq.buildRequest( new OAuthSignatureMethod_HMAC_SHA1, OAuthRequest.RESULT_TYPE_POST );
			auth = auth.split( "&" ).join( "\"," );
			auth = auth.split( "=" ).join( "=\"" );
			auth = auth.replace( /,status=.*/, "" );
			var authHeader:URLRequestHeader = new URLRequestHeader( "Authorization", "OAuth " + auth );
			
			var httpRequest:HttpRequest = new Post();
			httpRequest.addHeader( authHeader.name, authHeader.value );
			httpRequest.setFormData( [ { name: "status", value: msg } ] );
			
			var client:HttpClient = new HttpClient();
			client.request( new URI( this.POST_API_URL ), httpRequest );
			
			client.addEventListener( HttpResponseEvent.COMPLETE, postCompleteHandler );
		}
		
		/**
		 * POST したときの Response の値
		 * @param	e
		 */
		private function postCompleteHandler(e:HttpResponseEvent):void {
			trace( e.response.code );
		}
		
	}
	
}