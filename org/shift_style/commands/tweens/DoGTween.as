/**
 * 
 * @author Copyright (C) shift-Style.org, All Rights Reserved.
 * @version 0.1
 * 
 * Progression Libraries is dual licensed under the "Progression Library License" and "GPL".
 * http://progression.jp/license
 */
package org.shift_style.commands.tweens {
	import com.gskinner.motion.GTween;
	import jp.nium.core.debug.Logger;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import jp.progression.core.L10N.L10NCommandMsg;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">コマンド処理中に状態が更新された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteEvent.EXECUTE_UPDATE
	 */
	[Event( name="executeUpdate", type="jp.progression.events.ExecuteEvent" )]
	
	/**
	 * <span lang="ja">DoGTween クラスは、com.gskinner.motion.GTween パッケージのイージング機能を実行するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see http://gskinner.com/libraries/gtween/
	 * 
	 * @example <listing version="3.0">
	 * // DoGTween インスタンスを作成する
	 * var com:DoGTween = new DoGTween();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class DoGTween extends Command {
		
		/**
		 * <span lang="ja"></span>
		 * <span lang="en">Any object that will suffer a tweening. These objects are usually MovieClip, TextField, or Sound instances, or any other custom object with a numeric property that needs to be tweened.</span>
		 */
		public function get target():Object { return _target; }
		public function set target( value:Object ):void { _target = value; }
		private var _target:Object;
		
		public function get time():Number { return _time; }
		public function set time( value:Number ):void { _time = value; }
		private var _time:Number;
		
		
		/**
		 * <span lang="ja"></span>
		 * <span lang="en">An object containing various properties of the original object that you want to tween on the original objects, with their final values assigned (some special properties are also allowed), as well as some built-in Tweener properties used when defining tweening parameters. This is like the recipe for the tweening, declaring both what will be tweened, and how.</span>
		 */
		public function get parameters():Object { return _parameters; }
		public function set parameters( value:Object ):void { _parameters = value; }
		private var _parameters:Object;
		private var __parameters:Object;
		
		public function get props():* { return _props; }
		public function set props( value:* ):void { _props = value; }
		private var _props:Object;
		
		/**
		 * <span lang="ja">コマンドオブジェクトが ExecuteEvent.EXECUTE_UPDATE イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #scope
		 * @see jp.progression.events.ExecuteEvent#EXECUTE_UPDATE
		 */
		public function get onUpdate():Function { return _onUpdate; }
		public function set onUpdate( value:Function ):void { _onUpdate = value; }
		private var _onUpdate:Function;
		
		/**
		 * 対象を保持した配列を取得します。
		 */
		private var __targets:Array;
		
		/**
		 * 実行前のパラメータを取得します。
		 */
		private var _originalParameters:Object;		private var _originalProps:Object;
		
		private var __time:Number;		private var __props:*;
		
		
		private var _gTween:GTween;
		
		
		
		/**
		 * <span lang="ja">新しい DoGTween インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DoGTween object.</span>
		 * 
		 * @param target
		 * <span lang="ja"></span>
		 * <span lang="en">Any object that will suffer a tweening. These objects are usually MovieClip, TextField, or Sound instances, or any other custom object with a numeric property that needs to be tweened.</span>
		 * @param tweeningParameters
		 * <span lang="ja"></span>
		 * <span lang="en">An object containing various properties of the original object that you want to tween on the original objects, with their final values assigned (some special properties are also allowed), as well as some built-in Tweener properties used when defining tweening parameters. This is like the recipe for the tweening, declaring both what will be tweened, and how.</span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function DoGTween( target:Object, time:Number, parameters:Object, props:*, initObject:Object = null ) {
			// 引数を設定する
			_target = target;
			_parameters = parameters || {};
			__time = time;
			__props = props;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
			
			// initObject が DoTweener であれば
			var com:DoGTween = initObject as DoGTween;
			if ( com ) {
				// 特定のプロパティを継承する
				_onUpdate = com._onUpdate;
			}
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// 既存のイベントハンドラメソッドが存在したら例外をスローする
			switch ( true ) {
				case _parameters.onComplete			:
				case _parameters.onError			:
				case _parameters.onUpdate			:
				case _parameters.onCompleteParams	:
				case _parameters.onCompleteScope	:
				case _parameters.onErrorScope		:
				case _parameters.onOverwrite		:
				case _parameters.onOverwriteParams	:
				case _parameters.onOverwriteScope	:
				case _parameters.onStart			:
				case _parameters.onStartParams		:
				case _parameters.onStartScope		:
				case _parameters.onUpdateParams		:
				case _parameters.onUpdateScope		: { throw new Error( Logger.getLog( L10NCommandMsg.getInstance().ERROR_001 ).toString() ); }
			}
			
			// 現在の状態を保存する
			if ( _target is Array ) {
				__targets = _target as Array;
			}
			else {
				__targets = [ _target ];
			}
			_originalParameters = [];
			__parameters = {};
			for ( var p:String in _parameters ) {
				__parameters[p] = _parameters[p];
				
				for ( var i:int = 0, l:int = __targets.length; i < l; i++ ) {
					var target:Object = __targets[i];
					
					if ( p in target ) {
						_originalParameters[i] ||= {};
						_originalParameters[i][p] = target[p];
					}
				}
			}
			
			_originalProps = [];
			__props = {};
			for ( var sp:String in _props ) {
				__props[sp] = _props[p];
				
				for ( var j:int = 0, m:int = __targets.length; j < m; j++ ) {
					var targetp:Object = __targets[j];
					
					if ( sp in target ) {
						_originalProps[j] ||= {};
						_originalProps[j][sp] = targetp[sp];
					}
				}
			}
			
			// 初期化する
			__props.onComplete = _complete;
			__props.onChange = _update;
			//__props.onError = _error;
			
			// 実行する
			//Tweener.addTween( __targets, __parameters );			this._gTween = new GTween(_target, __time, __parameters, __props );
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			// 破棄する
			__targets = null;
			__parameters = null;
			_originalParameters = null;
		}
		
		/**
		 * 
		 */
		private function _complete(e:GTween):void {
			if ( __targets ) {
				// 対象リストから先頭を削除する
				__targets.shift();
				
				// まだリストに存在すれば終了する
				if ( __targets.length > 0 ) { return; }
			}
			
			// 破棄する
			_destroy();
			
			// 処理を終了する
			if ( super.state > 0 ) {
				super.executeComplete();
			}
			else {
				_interruptFunction();
			}
		}
		
		/**
		 * 
		 */
		private function _update(e:GTween):void {
			// イベントを送出する
			super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_UPDATE, false, false, this  ) );
			
			// イベントハンドラメソッドを実行する
			if ( _onUpdate != null ) {
				_onUpdate.apply( super.scope || this );
			}
		}
		
		/**
		 * 
		 */
		private function _error( errorScope:Object, metaError:Error ):void {
			errorScope;
			metaError;
			
			// 中断する
			_interruptFunction();
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			// 実行中のパラメータを取得する
			var params:Array = [ _target ];
			for ( var p:String in __parameters ) {
				params.push( p );
			}
			
			// 中断する
			try {
				//Tweener.removeTweens.apply( null, params );
			}
			catch ( err:Error ) {}
			
			// 中断方法によって処理を振り分ける
			switch ( super.interruptType ) {
				case 0	: {
					for ( var i:int = 0, l:int = __targets.length; i < l; i++ ) {
						var parameters:Object = _originalParameters[i];
						parameters.time = 0;
						this._gTween = new GTween(_target, __time, __parameters, __props );
						//Tweener.addTween( __targets[i], parameters );
					}
					break;
				}
				case 2	: {
					__parameters.time = 0;
					this._gTween = new GTween(_target, __time, __parameters, __props );
					//Tweener.addTween( __targets, __parameters );
					break;
				}
			}
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_target = null;			_time = 0;
			_parameters = null;			_props = null;
			_onUpdate = null;
		}
		
		/**
		 * <span lang="ja">DoTweener インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an DoTweener subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい DoTweener インスタンスです。</span>
		 * <span lang="en">A new DoTweener object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new DoGTween( _target, _time, _parameters, _props);
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "target" );
		}
	}
}
