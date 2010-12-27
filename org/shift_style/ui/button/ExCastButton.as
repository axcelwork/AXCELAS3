package org.shift_style.ui.button {
	import jp.progression.casts.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.commands.*;
	import jp.progression.data.*;
	import jp.progression.events.*;
	import jp.progression.scenes.*;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.external.ExternalInterface;
	
	import jp.ikekou.net.urlopener.*;
	
	/**
	 * ExCastButton.
	 *
	 * @author axcel-work
	 * @see $(See)
	 * @email axcelwork@gmail.com
	 * @version 1.0
	 * @date created 07/01/2010
	 */
	public class ExCastButton extends CastButton {
		/**
		 * ExCastButton インスタンスに表示したい Object を設定します。
		 */
		public var ButtonObject:MovieClip;
		
		/**
		 * ToolTip に表示したい文字列を設定します。
		 */
		public var alt:String = "";
		
		/**
		 * atCastMouseDown イベント発行時に移動させる SceneId を設定します。
		 */
		public var scene:String = "";
		
		/**
		 * atCastMouseDown イベント発行時に開くウインドウの URL を設定します。
		 */
		public var link:String = "";
		
		/**
		 * atCastMouseDown イベント発行時にURLを指定した時の targetWindow の種類を指定します。
		 */
		public var target:String = "_self";
		
		/**
		 * 新しくウインドウを開く場合ポップアップかどうかの設定をします。
		 */
		public var isPopup:Boolean = false;
		
		/**
		 * このインスタンスの幅を設定します。
		 */
		public var _width:int = 70;
		
		/**
		 * このインスタンスの高さを設定します。
		 */
		public var _height:int = 50;
		
		/**
		 * ポップアップウインドウの幅を設定します。
		 */
		public var _popupWidth:int;
		
		/**
		 * ポップアップウインドウの高さを設定します。
		 */
		public var _popupHeight:int;
		
		/**
		 * 新しい ExCastButton インスタンスを作成します。
		 */
		public function ExCastButton( initObject:Object = null ) {
			// 親クラスを初期化します。
			super( initObject );
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastAdded():void {
			this.toolTip.text = this.alt;
			this.buttonMode = true;
			
			if ( this.scene != "" ) {
				this.sceneId = new SceneId( scene );
			}
			else if( this.link != "" ) {
				if ( !isPopup ) {
					this.href = this.link;
					this.windowTarget = this.target;
				}
			}
			
			if ( this.ButtonObject == null ) {
				this.ButtonObject = this.isDammy();
			}
			
			// Command Excutor
			addCommand( new AddChild( this, this.ButtonObject ) );
		}
		
		/**
		 * IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRemoved():void {
			// Command Excutor
			addCommand( new RemoveChild( this, this.ButtonObject ) );
		}
		
		/**
		 * Flash Player ウィンドウの CastButton インスタンスの上でユーザーがポインティングデバイスのボタンを押すと送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastMouseDown():void {
			if ( isPopup ) {
				var url:String = this.link;
				var name:String = "_blank";
				var opt:String = "width=" + this._popupWidth +",height="+ this._popupHeight +",scrollbars=yes";
				ExternalInterface.call("function(u, n, o){var w = window.open(u, n, o); w.focus()}", url, name, opt);
			}
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastMouseUp():void {}
		
		/**
		 * ユーザーが CastButton インスタンスにポインティングデバイスを合わせたときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRollOver():void {
			this.ButtonObject.gotoAndStop( "over" );
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRollOut():void {
			this.ButtonObject.gotoAndStop( "out" );
		}
		
		
		/**
		 * この ExCastButton インスタンスを選択状態にします。
		 */
		public function atSelect():void {
			this.ButtonObject.gotoAndStop( "select" );
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.mouseEventEnabled = false;
		}
		
		
		/**
		 *  このExCastButton インスタンス非選択状態にします。
		 */
		public function atUnSelect():void {
			this.ButtonObject.gotoAndStop( "out" );
			
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.mouseEventEnabled = true;
		}
		
		
		/**
		 * _ButtonObjectプロパティに対して設定されなかったら、ダミーを作成します.
		 * @return
		 */
		private function isDammy():MovieClip {
			var _dammy:MovieClip = new MovieClip();
			_dammy.graphics.beginFill( Math.random() * 0x10000000, 1.0 );
			_dammy.graphics.drawRect( 0, 0, this._width, this._height );
			_dammy.graphics.endFill();
			
			return _dammy;
		}
		
	}
}